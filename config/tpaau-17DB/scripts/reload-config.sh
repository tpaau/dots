#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source $LIB_DIR/logger.sh
source $LIB_DIR/check_dependencies.sh

check_dependencies pkill pgrep waybar mako hyprpaper wofi wlogout

log_info "Reloading config"

$SCRIPTS_DIR/regenerate-symlinks.sh

# relaunch waybar
log_info "Reloading waybar"
pkill -x waybar

while pgrep -x waybar > /dev/null; do
    sleep 0.1
done

waybar & &>/dev/null


# relaunch mako
log_info "Reloading mako"
pkill -x mako

while pgrep -x mako > /dev/null; do
    sleep 0.1
done

mako & &>/dev/null

# relaunch hyprpaper
log_info "Reloading hyprpaper"
while pgrep -x hyprpaper > /dev/null; do
	pkill hyprpaper
    sleep 0.1
done

hyprpaper & &>/dev/null

log_info "Killing any unclosed wofi instances"
pkill wofi

log_info "Killing any unclosed wlogout instances"
pkill wlogout

exit 0
