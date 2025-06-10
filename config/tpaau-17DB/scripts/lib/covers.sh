source ~/.config/tpaau-17DB/scripts/lib/paths.sh
source ~/.config/tpaau-17DB/scripts/lib/logger.sh
source ~/.config/tpaau-17DB/scripts/lib/utils.sh
source ~/.config/tpaau-17DB/scripts/lib/locks.sh
source ~/.config/tpaau-17DB/scripts/tunables/media-fetcher-conf.sh

# Default track cover used when cover extraction failed or no media is playing
DEFAULT_COVER="$SHARE/sprites/unknown-cover.png"

# The cache directory for covers
COVERS_CACHE="$CACHE_DIR/covers"
mkdir -p "$COVERS_CACHE"

# Replaces '/' with '_'
#
# Args:
# 	$1: The filename to sanitize
sanitize_filename()
{
    local input="$1"
    echo "${input//[\/\\]/_}"
}

get_current_player()
{
	playerctl -a metadata --format '{{playerName}} {{status}}' | awk '$2 == "Playing" {print $1; exit}'
}

get_tmp_cover_name()
{
	local song="$1"
	echo "$TMP_DIR/tmp-$(date +%3N)-$song.png"
}

get_currently_playing()
{
	sanitize_filename "$(playerctl metadata --format "{{title}} - {{artist}}")"
}

verify_cover_fresh()
{
	local previous_playing="$1"

	if [[ "$previous_playing" == "$(get_currently_playing)" ]]; then
		return 0
	else
		log_warning "Currently playing media has changed, cover might have expired"
		log_warning "Previous was '$previous_playing', current is '$(get_currently_playing)'"
		return 1
	fi
}

# Limits image to 300x300 resolution and adds rounded corners to it.
#
# Args:
# 	$1: The path to the image to format
# 	$2 (optional, defaults to 15): The radius of the rounded corners
format_cover()
{
	local target="$1"
	local border_radius=$2

	log_debug "Preparing cover '$target'"

	is_int "$border_radius"
	if (( $? == 0 )); then
		border_radius=15
	fi

	magick "$target" \
	   \( +clone  -alpha extract \
		 -draw "fill black polygon 0,0 0,$border_radius $border_radius,0 fill white circle $border_radius,$border_radius $border_radius,0" \
		 \( +clone -flip \) -compose Multiply -composite \
		 \( +clone -flop \) -compose Multiply -composite \
	   \) -alpha off -compose CopyOpacity -composite "$target" #2>&1 >/dev/null 
}

extract_cover_cmus()
{
	local song="$1"
	local target="$2"
	
	# Make sure the current player is actually cmus
	log_debug "Attempting to extract cover from cmus"
	local cmus_data="$(cmus-remote -Q)"
	local artist="$(echo "$cmus_data" | awk '/^tag artist / { $1=""; $2=""; sub(/^  */, ""); print }')"
	local title="$(echo "$cmus_data" | awk '/^tag title / { $1=""; $2=""; sub(/^  */, ""); print }')"
	local source="$(echo "$cmus_data" | grep '^file ' | cut -d ' ' -f2-)"

	if [[ "$(sanitize_filename "$title - $artist")" != "$(get_currently_playing)" ]]; then
		log_warning "Cmus data doesn't mach, cover likely expired"
		log_warning "Previous was '$(sanitize_filename "$title - $artist"), current is '$(get_currently_playing)'"
		return 1
	fi

	ffmpeg -i "$source" -map 0:v -vf "scale=300:300:force_original_aspect_ratio=decrease,pad=300:300:(ow-iw)/2:(oh-ih)/2" -frames:v 1 -c:v png "$target" -y > /dev/null 2>&1 
	log_debug "Extracted to '$target'"
	return 0
}

extract_cover_url()
{
	local song="$1"
	local traget="$2"
	local url=$(playerctl metadata mpris:artUrl)

	log_error "Extracting covers from URLs is currently unsupported."
	echo ""
	return 1
}

prepare_extracted()
{
	local song="$1"
	local tmp="$2"
	local target="$COVERS_CACHE/$song.png"
	local meta="$COVERS_CACHE/$song.meta"

	local status=0
	format_cover "$tmp" || status=1

	
	if [[ "$song" != "$(get_currently_playing)" ]]; then
		log_warning "Audio data doesn't match, cover likely expired"
		return 1
	elif [[ $COVER_CHANGED == false ]]; then
		log_warning "Cover expred"
		return 1
	fi

	mv "$tmp" "$target" || status=1
	echo "last_accessed=$(date +%Y-%m-%d)" > "$meta" || status=1
	
	if (( $status == 0 )); then
		echo "$target"
	else
		log_error "Failed preparing cover. See errors above"
		echo "$DEFAULT_COVER"
		return 1
	fi
}

extract_cover()
{
	local song="$1"
	local tmp="$(get_tmp_cover_name "$song")"
	local target="$COVERS_CACHE/$song.png"
	local meta="$COVERS_CACHE/$song.meta"

	log_debug "Extracting cover for '$song'"

	for src in "${COVER_SOURCE_ORDER[@]}"; do
		case "$src" in
			[cmus]* )
				extract_cover_cmus "$song" "$tmp"
				if (( $? == 0 )); then
					prepare_extracted "$song" "$tmp"
					return $?
				fi
				;;
			[mpris:atUrl]* )
				extract_cover_url "$song" "$tmp"
				if (( $? == 0 )); then
					prepare_extracted "$song" "$tmp"
					return $?
				fi
				;;
			* )
				log_error "No such source '$src'"
				echo "$DEFAULT_COVER"
				return 1
				;;
		esac
	done
	log_error "Failed extracting cover from all sources"
	echo "$DEFAULT_COVER"
	return 1
}

verify_cover()
{
	local song="$1"
	local img="$COVERS_CACHE/$song.png"
	local meta="$COVERS_CACHE/$song.meta"
	local img_exists=false
	local meta_exists=false

	if [[ -f "$img" ]]; then
		img_exists=true
	fi

	if [[ -f "$meta" ]]; then
		meta_exists=true
	fi

	if [[ $img_exists == true && $meta_exists == true ]]; then
		log_debug "Found cover for '$song'"
		echo "exists"
		return 0
	elif [[ $img_exists == true && $meta_exists == false ]]; then
		rm "$img"
		log_warning "Removed '$img', no corresponding meta file found"
		echo "removed"
		return 0
	elif [[ $img_exists == false && $meta_exists == true ]]; then
		rm "$meta"
		log_warning "Removed '$meta', no corresponding image file found"
		echo "removed"
		return 0
	else
		log_debug "Entry for '$song' does not exist"
		echo "not-found"
		return 0
	fi
}

update_access_date()
{
	local meta_file="$1"
	local last_accessed="$(grep -o 'last_accessed=.*' "$meta_file" | cut -d'=' -f2-)"

	if [[ "$last_accessed" != "$CURRENT_DATE" ]]; then
		echo "last_accessed=$(date +%Y-%m-%d)" > "$meta_file"
		log_debug "Updated '$meta_file': '$last_accessed' -> '$CURRENT_DATE'"
	fi
}

load_cover()
{
	local song="$1"
	local cover="$COVERS_CACHE/$song.png"
	local meta="$COVERS_CACHE/$song.meta"

	update_access_date "$meta"

	echo "$cover"
	return 0
}

# Attempts to get song cover for a given string in format "TITLE - ARIST".
#
# Returns the path to the default cover if failed.
#
# Takes no arguments.
get_cover()
{
	local song="$(get_currently_playing)"
	local meta="$COVERS_CACHE/$song.meta"
	local cover_status="$(verify_cover "$song")"

	lock_db "$COVER_EXTRACTION_LOCK"

	case $cover_status in
		exists)
			load_cover "$song"
			unlock_db "$COVER_EXTRACTION_LOCK"
			return $?
			;;
		removed|not-found)
			extract_cover "$song"
			unlock_db "$COVER_EXTRACTION_LOCK"
			return $?
			;;
		*)
			log_error "Unknown result: '$result'"
			unlock_db "$COVER_EXTRACTION_LOCK"
			echo "$DEFAULT_COVER"
			return 1
			;;
	esac

	unlock_db "$COVER_EXTRACTION_LOCK"
	echo "$DEFAULT_COVER"
	return 1
}
