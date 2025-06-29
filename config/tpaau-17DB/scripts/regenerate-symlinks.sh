#!/usr/bin/env bash

if (( UTILS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/utils.sh; fi
if (( LOGGER_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/logger.sh; fi
if (( PATHS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/paths.sh; fi

log_debug "Regenerating symlinks"

run_step cd "$HOME/.config/wofi/"
run_step ln -sf "$CURRENT_COLORS" colors.css

run_step cd "$HOME/.config/waybar/"
run_step ln -sf "$CURRENT_COLORS" colors.css

run_step cd "$HOME/.config/wlogout/"
run_step ln -sf "$CURRENT_COLORS" colors.css

run_step cd "$HOME/.config/eww/"
run_step ln -sf "$CURRENT_COLORS" colors.css

if (( status == 0 )); then
	log_debug "Successfully regenerated symlinks"
	exit 0
else
	log_error "Errors occured while regenerating symlinks, some things might not work properly!"
	exit 1
fi
