#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh

check_dependencies pkill wofi

if [ $(pgrep wlogout) ]; then
	log_error "wlogout running, stopping"
	exit 1
fi

log_debug "Launching wofi"

cd "$HOME/.config/wofi/"
pkill wofi || wofi -n "$@" 2>/dev/null
