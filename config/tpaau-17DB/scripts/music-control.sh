#!/bin/bash

source ~/.config/tpaau-17DB-scripts/logger.sh

if [[ $# -ne 1 ]]; then
    error "Expected exactly one argument!"
else
    player_status=$(playerctl status 2>/dev/null)
    if [ "$player_status" = "Playing" ]; then
        playerctl pause
    else
        playerctl play
    fi
fi
