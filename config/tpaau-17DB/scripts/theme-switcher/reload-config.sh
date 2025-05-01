#!/bin/bash

source ~/.config/tpaau-17DB-scripts/logger.sh

info "Reloading config... " "" "n"

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
# kitten themes --reload-in=all

echo "done"

exit 0
