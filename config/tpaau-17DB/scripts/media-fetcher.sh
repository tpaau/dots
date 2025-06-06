#!/usr/bin/env bash

# Used to print track info in format:
# ♫ [X%] title - artist
#
# It can also be used to play/pause

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/utils.sh
source ~/.config/tpaau-17DB/scripts/include/covers.sh
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

# Make the text shorter so it can fit on the screen
shorten_text() 
{
    local text="$1"

	if (( $MAX_OUTPUT_LENGTH == 0 )); then
		echo "$text"
		return 0
	fi

    if [ ${#text} -gt $MAX_OUTPUT_LENGTH ]; then
		text="${text:0:$((MAX_OUTPUT_LENGTH-1))}"
		text=$(echo "$text" | sed 's/[[:space:]]*$//')
        echo "$text…"
	else
		echo "$text"
    fi
}

update_cover()
{
	local cover_path="$(get_cover "$(playerctl metadata --format "{{title}} - {{artist}}")")"
	if (( $? != 0 )); then
		log_error "Failed getting cover, exited with a non-zero code"
		eww update cover-path="$cover_path"
		return 1
	elif [[ -z "$cover_path" ]]; then
		log_info "Got an empty cover path, will retry in ${WAITTIME}s"
		sleep $WAITTIME
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

	if [ "$hours" -gt 0 ]; then
		printf "%d:%02d:%02d\n" "$hours" "$mins" "$secs"
	else
		printf "%d:%02d\n" "$mins" "$secs"
	fi
}

watch_main_meta()
{
	playerctl --follow metadata --format '{{mpris:trackid}}' | while read -r track_id; do
		log_debug "Fetching media metadata"
		eww update track-artist="$(playerctl metadata artist)"
		eww update track-title="$(playerctl metadata title)"
		local track_len=$(($(playerctl metadata mpris:length) / 1000000))
		eww update track-len="$(format_time_sec $track_len)"
		update_cover
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
		IFS="$SEP" read -r title artist pos_sec len <<< "$(playerctl metadata --format "{{title}}${SEP}{{artist}}${SEP}{{position}}${SEP}{{mpris:length}}")"
        local meta="$title - $artist"
        local pos=$(track_percent "$pos_sec" "$len")
        local elapsed_formatted=$(format_time_sec "$pos")

        if [[ "$elapsed_formatted" != "$prev_elapsed" ]]; then
            eww update track-elapsed="$elapsed_formatted"
            prev_elapsed="$elapsed_formatted"
        fi

        if (( prev_pos != pos )) || [[ "$meta" != "$prev_meta" ]]; then
            eww update track-elapsed-percent=$pos
            echo "[$pos%] $(shorten_text "$meta")"
            prev_pos=$pos
            prev_meta="$meta"
        fi

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

if [[ $# -ne 1 ]]; then
	log_error "Expected exactly one argument!"
	exit 1
elif [[ "$1" == "start" ]]; then
	watch_all
	exit 0
else
	log_error "Unknown argument: '$1'"
	exit 1
fi
