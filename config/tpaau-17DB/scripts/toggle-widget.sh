#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/lib/paths.sh
source ~/.config/tpaau-17DB/scripts/lib/logger.sh

WIDGET_NAME=""

if (( $# != 1 )); then
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
	if [[ "$WIDGET_NAME" == "status-menu" ]]; then
		brightness=$(( 100 * $(brightnessctl get) / $(brightnessctl max) ))
		if (( brightness != 100 )); then
			brightness=$(( brightness + 1 ))
		fi
		eww update brightness-percent=$brightness
	fi
	eww open "$WIDGET_NAME"
fi
