#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/lib/paths.sh
source ~/.config/tpaau-17DB/scripts/lib/logger.sh
source ~/.config/tpaau-17DB/scripts/lib/themes.sh

themes=$(get_themes_pretty)

theme=$(echo -en "$themes"\
	| "$SCRIPTS_DIR/run-wofi.sh" --dmenu --allow-images --prompt "Pick a theme...")

if [ ! -z "$theme" ]; then
	log_debug "Picked '$theme'"
	apply_theme "$theme"
	exit $?
else
	log_warning "No theme picked, ignoring."
fi
