source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/utils.sh

# The order in which the cover is to be extracted
COVER_SOURCE_ORDER=("cmus" "mpris:artUrl")

# The directory containing cached covers as well as the covers database
COVERS_DIR="$CACHE_DIR/covers"
mkdir -p "$COVERS_DIR"

# The covers database file
COVERS_DB="$COVERS_DIR/covers.csv"

# The covers database lock
COVERS_DB_LOCK="$COVERS_DB.lock"

# Temporary file holding used for caching a cover until it's processed
COVER_TMP="$TMP_DIR/cover.png"

# Lock for the COVER_TMP file
COVER_TMP_LOCK="$COVER_TMP.lock"

# Default track cover used when cover extraction failed or no media is playing
DEFAULT_COVER="$SHARE/sprites/unknown-cover.png"

# Replaces '/' with '_'
#
# Args:
# 	$1: The filename to sanitize
sanitize_filename()
{
    local input="$1"
    echo "${input//[\/\\]/_}"
}

# Reads an entry from the cover database file.
#
# Args:
# 	$1: The name of the entry in format "SONG TITLE - ARTIST"
read_entry() {
	local name="$1"

    local line=$(grep -F "$name," "$COVERS_DB")
	if [ ! -z "$line" ]; then
		IFS=',' read -r entry_name entry_date entry_path <<< "$line"

		if [[ ! -f "$entry_path" ]]; then
			delete_entry "$entry_name"
			return 1
		fi

		if [[ "$entry_date" != "$(date +%d-%m)" ]]; then
			log_info "Updating date for entry $name"
			write_to_cover_db "$entry_name" "$entry_path"
		fi
		echo "$line"
		return 0
    else
        log_error "Can't read '$name', the entry does not exist!"
        return 1
    fi
}

# Returns 0 when given entry exists in the database and 1 otherwise.
#
# Args:
# 	$1: The name of the entry in format "SONG TITLE - ARTIST"
exists_in_db()
{
	local name="$1"
	grep -F "$name," "$COVERS_DB" 2>&1 >/dev/null
	return $?
}

# Requires to lock the COVERS_DB_LOCK
delete_entry()
{
	local name="$1"

	log_info "Attempting to remove '$name' from '$COVERS_DB'"

	lock_db "$COVERS_DB_LOCK"

	exists_in_db "$name"
	if [[ $? -eq 0 ]]; then
		local filtered="$(grep -Fv "$name" "$COVERS_DB")"
		log_info "Deleted entry '$name'"
    else
		log_warning "Cannot delete '$name', entry does not exist"
    fi

	unlock_db "$COVERS_DB_LOCK"
}

#Writes an entry to the covers database. If an entry with the given name
# already exists, it's overwritten.
#
# Args:
# 	$1: The name of the entry in format "SONG TITLE - ARTIST"
# 	$2: The path to the cover art of the given track
write_to_cover_db()
{
	local name="$1"
	local path="$2"

	log_info "Writing '$name' to '$COVERS_DB'"

	lock_db "$COVERS_DB_LOCK"

	local new_entry="$name,$(date +%d-%m),$path"

    if grep -F "$name," "$COVERS_DB"; then
        local escaped_entry=$(printf '%s\n' "$new_entry" | sed 's/[&/\]/\\&/g')
        sed -i.bak "s|^$name,.*|$escaped_entry|" "$COVERS_DB" && rm "$COVERS_DB.bak"
    else
        echo "$new_entry" >> "$COVERS_DB"
    fi

	unlock_db "$COVERS_DB_LOCK"
}

# Limits image to 300x300 resolution and adds rounded corners to it.
#
# Args:
# 	$1: The path to the image to format
# 	$2 (optional, defaults to 15): The radius of the rounded corners
format_cover()
{
	log_info "Preparing cover"

	local cover_path="$1"
	local border_radius=$2

	if [[ $(is_number "$border_radius") ]]; then
		border_radius=15
	fi

	magick "$cover_path" \
	   \( +clone  -alpha extract \
		 -draw "fill black polygon 0,0 0,$border_radius $border_radius,0 fill white circle $border_radius,$border_radius $border_radius,0" \
		 \( +clone -flip \) -compose Multiply -composite \
		 \( +clone -flop \) -compose Multiply -composite \
	   \) -alpha off -compose CopyOpacity -composite "$cover_path" > /dev/null 2>&1
}

# Expects string in format 'SONG - ARTIST'
get_cover()
{
	log_info "Getting cover"

	local song="$(sanitize_filename "$1")"

	exists_in_db "$song"
	if [[ $? -eq 0 ]]; then
		IFS=',' read -r entry_name entry_date entry_path <<< "$(read_entry "$song")"
		log_info "Found cover at path '$entry_path'"
		echo "$entry_path"
		return 0
	else
		log_info "No '$song' found in '$COVERS_DB"
		lock_db "$COVER_TMP_LOCK"
		extract_cover
		if [[ $? -eq 0 ]]; then
			mv "$COVER_TMP" "$COVERS_DIR/$song.png"
			write_to_cover_db "$song" "$COVERS_DIR/$song.png"
			unlock_db "$COVER_TMP_LOCK"
			echo "$COVERS_DIR/$song.png"
			return 0
		fi
	fi

	echo "$DEFAULT_COVER"
	return 1
}

extract_cover_cmus()
{
	# Make sure the current player is actually cmus
	log_info "Attempting to extract cover from cmus"
	local player=$(playerctl -l | head -n 1)
	if [[ "$player" == "cmus" ]]; then
		local source="$(cmus-remote -Q | grep '^file ' | cut -d ' ' -f2-)"
		ffmpeg -i "$source" -map 0:v -vf "scale=300:300:force_original_aspect_ratio=decrease,pad=300:300:(ow-iw)/2:(oh-ih)/2" -frames:v 1 -c:v png "$COVER_TMP" -y > /dev/null 2>&1
		log_info "Extracted to '$COVER_TMP'"
		return 0
	else
		log_warning "Current player is '$player', not 'cmus'. Wrong cover would likely be extracted."
		return 1
	fi
}

extract_cover_url()
{
	local url=$(playerctl -p $(playerctl -l | head -n 1) metadata mpris:artUrl)

	log_error "Extracting covers from URLs is currently unsupported."
	echo ""
	return 1
}

extract_cover()
{
	local result
	for src in "${COVER_SOURCE_ORDER[@]}"; do
		case "$src" in
			[cmus]* )
				extract_cover_cmus
				if [[ $? -eq 0 ]]; then
					log_info "Got cover from cmus"
					format_cover "$COVER_TMP"
					return 0
				fi
				;;
			[mpris:atUrl]* )
				extract_cover_url
				if [[ $? -eq 0 ]]; then
					log_info "Got cover from url"
					format_cover "$COVER_TMP"
					return 0
				fi
				;;
			* )
				log_error "No such source '$src'"
				return 1
				;;
		esac
	done
	log_error "Could not extract the cover from all the provided sources"
	return 1
}
