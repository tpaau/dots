#!/usr/bin/env bash

# Used to print track info in format:
# ♫ [X%] title - artist
#
# It can also be used to play/pause

source ~/.config/tpaau-17DB/scripts/lib/paths.sh
source ~/.config/tpaau-17DB/scripts/lib/logger.sh
source ~/.config/tpaau-17DB/scripts/lib/utils.sh
source ~/.config/tpaau-17DB/scripts/lib/covers.sh
source ~/.config/tpaau-17DB/scripts/tunables/media-fetcher-conf.sh

SEP=$'\x1e'

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

update_cover()
{
	local cover_path="$(get_cover "$(playerctl metadata --format "{{title}} - {{artist}}")")"
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

update_eww_default_state()
{
	eww update playing-icon=""
	eww update cover-path="$DEFAULT_COVER"
	log_info "Updated eww cover to '$DEFAULT_COVER'"
	eww update track-title="Unknown"
	eww update track-artist="Unknown"
	eww update track-len="--:--"
	eww update track-elapsed="--:--"
	eww update track-elapsed-percent="0"
}

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

watch_main_meta()
{
	while true; do
		playerctl --follow metadata --format '{{mpris:trackid}}' | while read -r track_id; do
			log_debug "Fetching media metadata"
			update_cover
			eww update track-artist="$(playerctl metadata artist)"
			eww update track-title="$(playerctl metadata title)"
			local track_len=$(($(playerctl metadata mpris:length) / 1000000))
			eww update track-len="$(format_time_sec $track_len)"
		done
		sleep 0.5
	done
}

watch_status()
{
	playerctl --follow status | while read -r status; do
		case "$status" in
			Playing)
				eww update playing-icon=""
				;;
			Paused)
				eww update playing-icon=""
				;;
			*)
				update_eww_default_state
				;;
		esac
	done
}

watch_elapsed_meta() {
    local prev_pos=0
    local prev_meta=""
    local prev_elapsed=""

    while true; do
		IFS="$SEP" read -r title artist pos_sec len status <<< "$(playerctl metadata --format "{{title}}$SEP{{artist}}$SEP{{position}}$SEP{{mpris:length}}$SEP{{status}}")"
		case $status in
			Playing)
				local meta="$title - $artist"
				local pos=$(track_percent "$pos_sec" "$len")
				local elapsed_formatted=$(format_time_sec "$pos")

				if [[ "$elapsed_formatted" != "$prev_elapsed" ]]; then
					eww update track-elapsed="$elapsed_formatted"
					prev_elapsed="$elapsed_formatted"
				fi

				if (( prev_pos != pos )) || [[ "$meta" != "$prev_meta" ]]; then
					eww update track-elapsed-percent=$pos
					echo "[$pos%] $(shorten_text "$meta" $MAX_OUTPUT_LENGTH)"
					prev_pos=$pos
					prev_meta="$meta"
				fi
				;;
			Paused)
				echo "Paused"
				;;
			*)
				echo "Not playing"
				;;
		esac

        sleep $FETCH_DELTA
    done
}

watch_all()
{
	watch_main_meta &
	local p1=$!

	watch_status &
	local p2=$!
	
	trap "kill $p1 $p2 2>/dev/null; pkill -f 'playerctl --follow'; exit" SIGINT SIGTERM EXIT

	watch_elapsed_meta
}

if (( $# != 1 )); then
	log_error "Expected exactly one argument!"
	exit 1
elif [[ "$1" == "start" ]]; then
	watch_all
	exit 0
else
	log_error "Unknown argument: '$1'"
	exit 1
fi
