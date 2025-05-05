#!/usr/bin/env bash

# Used to print song info in format:
# ♫ [X%] song - artist
#
# It can also be used to play/pause

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source $LIB_DIR/logger.sh
source $LIB_DIR/check-dependencies.sh

check_dependencies playerctl bc sed

MAX_LENGTH=45

print_usage() {
	BOLD="\033[1m"
	GREEN="\033[0;32m"
	CYAN="\033[0;36m"
	NC="\033[0m"

	echo -e "${BOLD}Usage:${NC} ${CYAN}music-player.sh [args]${NC}\n"
	echo -e "${BOLD}Args:${NC}"
	echo -e "  ${GREEN}--help${NC}       Show this help message"
	echo -e "  ${GREEN}watch${NC}        Display song status"
	echo -e "  ${GREEN}play-pause${NC}   Toggle player status"
}

play_pause()
{
	local player_status=$(playerctl status 2>/dev/null)
    if [ "$player_status" = "Playing" ]; then
        playerctl pause
    else
        playerctl play
    fi
}

song_percent() 
{
    local position=$(playerctl position)
    local length=$(playerctl metadata mpris:length)
    local length_seconds=$(echo "scale=2; $length / 1000000" | bc)

    if [[ -z "$position" || -z "$length" || "$length" -eq 0 ]]; then
        echo "Elapsed: 0%"
        exit 1
    fi

    local percent=$(echo "($position * 100) / $length_seconds" | bc)
    echo "${percent}%"
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

# Display audio status
watch()
{
	while true; do 
		player_status=$(playerctl status)
		if [ "$player_status" = "Playing" ]; then
			local artist=$(playerctl metadata artist)
			local title=$(playerctl metadata title)
			local song_elapsed=$(song_percent)
			local shortened_text=$(shorten_text "♫ [$song_elapsed] $title - $artist")
			echo "$shortened_text"
		elif [ "$player_status" = "Paused" ]; then
			echo "▶ paused"
		else
			echo "n/a"
		fi
		
		sleep 0.1
	done
}

if [[ $# -ne 1 ]] || [[ -z "$1" ]]; then
	log_error "Expected exactly one argument!"
	echo ""
	print_usage
	exit 1
elif [[ "$1" == "--help" ]]; then
	print_usage
	exit 0
elif [[ "$1" == "watch" ]]; then
	watch
	exit 0
elif [[ "$1" == "play-pause" ]]; then
	play_pause
	exit 0
else
	log_err "Unknown argument: '$1'"
	exit 1
fi
