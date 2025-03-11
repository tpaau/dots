#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Expected exactly one argument!"
else
    player_status=$(playerctl status 2>/dev/null)
    if [ "$player_status" = "Playing" ]; then
        playerctl pause
    else
        playerctl play
    fi
fi
