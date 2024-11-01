#!/bin/bash

# Make the text shorter so it can fit on the screen
shorten_text() {
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
    song_elapsed=$(/home/mikolaj/.config/HyprV/waybar/scripts/song-percent.sh)
    shortened_text=$(shorten_text "♫ [$song_elapsed] $title - $artist")
    echo "$shortened_text"
    elif [ "$player_status" = "Paused" ]; then
        echo "▶ paused"
    else
        echo "stopped"
    fi
    
    sleep 0.1
done
