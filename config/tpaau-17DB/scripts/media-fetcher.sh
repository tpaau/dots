#!/usr/bin/env bash

# Attaches to the first media player it finds and fetches media from that
# player.
#
# Updates eww variables to reflect the changes in the media control widget.

source ~/.config/tpaau-17DB/scripts/lib/paths.sh
source ~/.config/tpaau-17DB/scripts/lib/logger.sh
source ~/.config/tpaau-17DB/scripts/lib/utils.sh
source ~/.config/tpaau-17DB/scripts/lib/covers.sh
source ~/.config/tpaau-17DB/scripts/tunables/media-fetcher.sh

SEP=$'\x1e'

# Returns the percent elapsed of the current track.
#
# *Takes no arguments.*
track_percent()
{
    local pos="$1"
    local len="$2"

	if [[ -z "$pos" || -z "$len" ]] || (( len == 0 )); then
        echo 0
        return
    fi

	echo $(( pos * 100 / len ))
}

# Updates the eww cover image.
#
# The current artist and title metadata must be up to date, unless you want to
# end up with damaged cover cache.
#
# And yes, I could go with `playerctl metadata`, but that would degrade
# performance and increase latency.
#
# Args:
# 	$1: The artist name
# 	$2: The title
update_cover()
{
	local artist="$1"
	local title="$2"

	local cover_path="$(get_cover "$artist - $title")"
	if (( $? != 0 )); then
		log_error "Failed getting cover, exited with a non-zero code"
		eww update cover-path="$cover_path"
		return 1
	elif [[ -z "$cover_path" ]]; then
		log_info "Got an empty cover path, will retry in ${FETCH_DELTA}s"
		sleep $FETCH_DELTA
		update_cover
		return 0
	fi
	eww update cover-path="$cover_path"
	log_debug "Updated cover"
	return 0
}

# Reverts eww media-control widget to its default state.
#
# *Takes no arguments.*
update_not_playing()
{
	eww update media-playing=false
	eww update cover-path="$DEFAULT_COVER"
	eww update track-title="Unknown"
	eww update track-artist="Unknown"
	eww update track-len="--:--"
	eww update track-elapsed="--:--"
	eww update track-elapsed-percent="0"
}

# Formats given integer treated as the number of seconds into HH:MM:SS format.
#
# Args:
# 	$1: The time to format in seconds
format_time_sec()
{
	local sec=${1%.*}

	local hours=$((sec / 3600))
	local mins=$(((sec % 3600) / 60))
	local secs=$((sec % 60))

	if (( hours > 0 )); then
		printf "%d:%02d:%02d\n" "$hours" "$mins" "$secs"
	else
		printf "%d:%02d\n" "$mins" "$secs"
	fi
}

# The main loop for watching metadata.
#
# *Takes no arguments.*
watch() {
    local prev_pos_percent=0
    local prev_artist=""
    local prev_title=""
    local prev_elapsed=""
	local prev_status=""
	local prev_len=0

    while true; do
		local update_diplay=false
		local update_cover=false
		IFS="$SEP" read -r title artist len pos_sec status <<< "$(playerctl metadata --format "{{title}}$SEP{{artist}}$SEP{{mpris:length}}$SEP{{position}}$SEP{{status}}")"
		case $status in
			Playing)
				if [[ "$prev_status" != "pl" ]]; then
					eww update media-playing=true
				fi
				prev_status="pl"
				local pos_percent=$(track_percent "$pos_sec" "$len")
				local pos_sec=$(( pos_sec / 1000000 ))

				local elapsed_formatted=$(format_time_sec $pos_sec)
				if [[ "$elapsed_formatted" != "$prev_elapsed" ]]; then
					eww update track-elapsed="$elapsed_formatted"
					prev_elapsed="$elapsed_formatted"
				fi

				if (( prev_pos_percent != pos_percent )); then
					eww update track-elapsed-percent=$pos_percent
					prev_pos_percent=$pos_percent
					update_diplay=true
				fi

				if [[ "$artist" != "$prev_artist" ]]; then
					eww update track-artist="$artist"
					prev_artist="$artist"
					update_cover=true
					update_diplay=true
				fi

				if [[ "$title" != "$prev_title" ]]; then
					prev_title="$title"
					eww update track-title="$title"
					update_cover=true
					update_diplay=true
				fi
				
				if (( len != prev_len )); then
					eww update track-len=$(format_time_sec $((len / 1000000 )))
				fi

				if [[ $update_diplay == true ]]; then
					echo "[$pos_percent%] $(shorten_text "$title - $artist" $MAX_OUTPUT_LENGTH)"
				fi

				if [[ $update_cover == true ]]; then
					update_cover "$artist" "$title" &
				fi
				;;
			Paused)
				echo "Paused"
				if [[ "$prev_status" != "pa" ]]; then
					eww update media-playing=false
				fi
				prev_status="pa"
				;;
			*)
				echo "Not playing"
				if [[ "$prev_status" != "np" ]]; then
					update_not_playing
				fi
				prev_status="np"
				;;
		esac
        sleep $FETCH_DELTA
    done
}

if (( $# != 1 )); then
	log_error "Expected exactly one argument!"
	exit 1
elif [[ "$1" == "start" ]]; then
	watch
	exit 0
else
	log_error "Unknown argument: '$1'"
	exit 1
fi
