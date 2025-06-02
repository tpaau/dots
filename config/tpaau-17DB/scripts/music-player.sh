#!/usr/bin/env bash

# Used to print track info in format:
# ♫ [X%] title - artist
#
# It can also be used to play/pause

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh
source ~/.config/tpaau-17DB/scripts/include/coversdb.sh
source ~/.config/tpaau-17DB/scripts/include/utils.sh

check_dependencies playerctl bc sed eww

RUNTIME_LOCK="$TMP_DIR/music-player.lock"

MAX_LENGTH=45

DELTA=0.01

track_percent()
{
    local pos=$(echo "$(playerctl position) * 1000000" | bc)
    local len=$(playerctl metadata mpris:length)

    if [[ -z "$pos" || -z "$len" || "$len" -eq 0 ]]; then
        echo "0%"
        return
    fi

    local percent=$(echo "($pos * 100) / $len" | bc)
    echo "$percent"
}

# Make the text shorter so it can fit on the screen
shorten_text() 
{
    local text="$1"

    if [ ${#text} -gt $MAX_LENGTH ]; then
		text="${text:0:$((MAX_LENGTH-1))}"
		text=$(echo "$text" | sed 's/[[:space:]]*$//')
        echo "$text…"
	else
		echo "$text"
    fi
}

update_eww_default_state()
{
	eww update playing-icon=""
	eww update cover-path="$DEFAULT_COVER"
	eww update track-title="Unknown"
	eww update track-artist="Unknown"
	eww update track-len="--:--"
	eww update track-elapsed="--:--"
	eww update track-elapsed-percent="0"
}

format_time_sec()
{
	sec=${1%.*}

	hours=$((sec / 3600))
	mins=$(((sec % 3600) / 60))
	secs=$((sec % 60))

	if [ "$hours" -gt 0 ]; then
		printf "%d:%02d:%02d\n" "$hours" "$mins" "$secs"
	else
		printf "%d:%02d\n" "$mins" "$secs"
	fi
}

# Display audio status
watch()
{
	local prev_title=""
	local prev_artist=""
	local prev_status=""
	local perv_elapsed=""
	local cover_path=""
	while true; do 
		local status=$(playerctl status)

		if [ "$status" = "Playing" ]; then
			eww update playing-icon=""
			eww update track-elapsed="$(format_time_sec $(playerctl position))"
			local artist=$(playerctl metadata artist)
			local title=$(playerctl metadata title)
			local elapsed="$(track_percent)%"

			if [[ "$artist" != "$prev_artist" ]] || [[ "$title" != "$prev_title" ]]\
			|| [[ "$status" != "$prev_status" ]] || [[ "$elapsed" != "$prev_elapsed" ]]; then
				local format="♫ [$elapsed] $title - $artist"
				local shortened_format=$(shorten_text "$format")
		
				if [[ "$artist" != "$prev_artist" ]] || [[ "$title" != "$prev_title" ]]; then
					cover_path="$(get_cover "$(playerctl metadata --format "{{title}} - {{artist}}")")"

					if [[ ! -z "$cover_path" ]]; then
						eww update cover-path="$cover_path"
					else
						log_warning "Falling back to default cover"
						eww update cover_path="$DEFAULT_COVER"
					fi
				else
					eww update cover-path="$cover_path"
				fi
				eww update track-artist="$artist"
				eww update track-title="$title"

				prev_artist="$artist"
				prev_title="$title"
				prev_elapsed="$elapsed"
				eww update track-elapsed-percent="$(track_percent)"
				if [[ ! -z "$(playerctl metadata mpris:length)" ]]; then
					track_len=$(($(playerctl metadata mpris:length) / 1000000))
					eww update track-len="$(format_time_sec $track_len)"
				fi

				echo "$shortened_format"
			fi
		elif [ "$status" = "Paused" ]; then
			if [[ "$prev_status" != "Paused" ]]; then
				eww update playing-icon=""
				echo "Paused"
            fi
		else
			if [[ "$prev_status" != "$status" ]]; then
				update_eww_default_state
				echo "Not playing"
			fi
		fi

		prev_status="$status"
		sleep $DELTA
	done
}

if [[ $# -ne 1 ]]; then
	log_error "Expected exactly one argument!"
	exit 1
elif [[ "$1" == "watch" ]]; then
	pgrep -u $(whoami) -af "music-player\.sh watch" | grep -v $$ 1>&2 >/dev/null
	if [[ $? -eq 0 ]]; then
		log_error "Another instance is running!"
		exit 1
	fi
	watch
	exit 0
elif [[ "$1" == "clean-cache" ]]; then
	log_info "Cleaning cover cache"
	clean_items "$COVERS_DIR"
	mkdir -p "$COVERS_DIR"
	exit 0
else
	log_err "Unknown argument: '$1'"
	exit 1
fi
