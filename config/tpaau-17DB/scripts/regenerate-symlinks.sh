#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/lib/paths.sh
source ~/.config/tpaau-17DB/scripts/lib/logger.sh
source ~/.config/tpaau-17DB/scripts/lib/utils.sh

log_debug "Regenerating symlinks"

run_step cd "$HOME/.config/wofi/"
run_step ln -sf "$CURRENT_COLORS" colors.css

crun_step cd "$HOME/.config/waybar/"
lrun_step ln -sf "$CURRENT_COLORS" colors.css

crun_step cd "$HOME/.config/wlogout/"
lrun_step ln -sf "$CURRENT_COLORS" colors.css

crun_step cd "$HOME/.config/eww/"
lrun_step ln -sf "$CURRENT_COLORS" colors.css

if (( status == 0 )); then
	log_debug "Successfully regenerated symlinks"
	exit 0
else
	log_error "Errors occured while regenerating symlinks, some things might not work properly!"
	exit 1
fi
