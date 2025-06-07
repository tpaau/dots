#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/lib/logger.sh

if [ $(pgrep wlogout) ]; then
	log_info "wlogout already running, stopping"
	exit 1
fi

log_debug "Launching wofi"

cd "$HOME/.config/wofi/"
pkill wofi || wofi -n "$@" 2>/dev/null
