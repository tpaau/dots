#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Expected exactly one argument!"
elif [[ $1 == "toggle-pause" ]]; then
    cmus-remote --pause
    status=$(playerctl --player=spotify status)
    if [ "$status" = "Playing" ]; then
        playerctl --player=spotify pause
    else 
        playerctl --player=spotify play
    fi
fi
