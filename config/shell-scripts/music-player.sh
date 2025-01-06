#!/bin/bash

#
# This script is used to print song info in format
# ♫ [X%] song - artist
# It was desinged to be used with waybar.
#


song_percent() 
{
    position=$(playerctl position)
    length=$(playerctl metadata mpris:length)
    length_seconds=$(echo "scale=2; $length / 1000000" | bc)

    if [[ -z "$position" || -z "$length" || "$length" -eq 0 ]]; then
        echo "Elapsed: 0%"
        exit 1
    fi

    percent=$(echo "($position * 100) / $length_seconds" | bc)

    echo "${percent}%"
}


# Make the text shorter so it can fit on the screen
shorten_text() 
{
    local text="$1"
    local max_length=35

    if [ ${#text} -gt $max_length ]; then
        echo "${text:0:$((max_length-1))}…"
    else
        echo "$text"
    fi
}

# On click action (pause/play audio)
if [[ "$1" == "click" ]]; then
  player_status=$(playerctl status 2>/dev/null)
  if [ "$player_status" = "Playing" ]; then
    playerctl pause
  else
    playerctl play
  fi
  exit
fi

# Display audio status
while true; do 
    player_status=$(playerctl status)
    if [ "$player_status" = "Playing" ]; then
    artist=$(playerctl metadata artist)
    title=$(playerctl metadata title)
    song_elapsed=$(song_percent)
    shortened_text=$(shorten_text "♫ [$song_elapsed] $title - $artist")
    echo "$shortened_text"
    elif [ "$player_status" = "Paused" ]; then
        echo "▶ paused"
    else
        echo "☐ stopped"
    fi
    
    sleep 0.1
done
