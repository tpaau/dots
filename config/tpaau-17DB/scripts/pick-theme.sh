#!/usr/bin/env bash

# Used for picking themes with wofi

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source $LIB_DIR/logger.sh
source $LIB_DIR/notifications.sh
source $LIB_DIR/apply-theme.sh
source $LIB_DIR/check-dependencies.sh

check_dependencies grep wofi

themes=""

log_info "Getting themes"
for theme in $(ls "$THEMES_DIR" | grep -v "template.sh"); do
	themes+="${theme%.sh}\n"
done

log_info "Launching wofi"
theme=$(echo -en "$themes"\
	| "$SCRIPTS_DIR/run-wofi.sh" --dmenu --allow-images --prompt "Pick a theme..." 2>/dev/null)

if [ ! -z "$theme" ]; then
	log_info "Picked '$theme'"
	apply_theme "$theme"
	if [ $? -ne 0 ]; then
		log_error "Loading theme failed, please check the logs."
		notify_err "Loading theme failed, please check the logs."
		exit 1
	fi
else
	log_warning "No theme picked, ignoring."
fi
