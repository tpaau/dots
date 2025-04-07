#!/bin/bash

# relaunch waybar


pkill -x waybar

while pgrep -x waybar > /dev/null; do
    sleep 0.1
done

waybar &


# relaunch mako
pkill -x mako

while pgrep -x mako > /dev/null; do
    sleep 0.1
done

mako &

# Reload kitty theme
kitten themes --reload-in=all

exit 0
