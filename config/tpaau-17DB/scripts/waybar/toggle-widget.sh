#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/notifications.sh
source ~/.config/tpaau-17DB/scripts/include/covers.sh

WIDGET_NAME=""

if [[ $# -ne 1 ]]; then
	log_error "Expected exactly one argument!"
	exit 1
else
	WIDGET_NAME="$1"
fi

if eww active-windows | grep -q "$WIDGET_NAME"; then
	log_debug "Closing "$WIDGET_NAME
	eww close "$WIDGET_NAME"
else
	log_debug "Opening "$WIDGET_NAME
	if [[ "$WIDGET_NAME" == "audio-control" ]]; then
		~/.config/tpaau-17DB/scripts/update-cover.sh &
	fi
	eww open "$WIDGET_NAME"
fi
