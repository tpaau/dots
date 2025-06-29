#!/usr/bin/env bash

if (( LOGGER_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/logger.sh; fi
if (( PATHS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/paths.sh; fi

WIDGET_NAME=""

if (( $# != 1 )); then
	log_error "Expected exactly one argument!"
	exit 1
else
	WIDGET_NAME="$1"
fi

if eww active-windows | grep -q "$WIDGET_NAME"; then
	log_debug "Closing "$WIDGET_NAME
	if [[ "$WIDGET_NAME" == "status-menu" ]]; then
		~/.config/tpaau-17DB/scripts/smenu-fetcher.sh stop &
	fi
	eww close "$WIDGET_NAME"
else
	log_debug "Opening "$WIDGET_NAME
	if [[ "$WIDGET_NAME" == "status-menu" ]]; then
		~/.config/tpaau-17DB/scripts/smenu-fetcher.sh start &
	fi
	eww open "$WIDGET_NAME"
fi
