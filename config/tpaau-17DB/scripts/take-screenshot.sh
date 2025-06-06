#!/usr/bin/env bash

# Used for taking screenshots in a nice way

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/notifications.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh

SS_NAME="screenshot.png"

cleanup()
{
	if [[ -e "$TMP_DIR/$SS_NAME" ]]; then
		log_debug "Cleaning temporary files"
		rm -rf "$TMP_DIR/$SS_NAME"
	fi
}

if [[ $(pgrep -x slurp) ]]; then
	log_warning "Another screenshot utility is likely running, stopping."
	exit 0
fi

cleanup

mkdir -p "$TMP_DIR"

log_debug "Taking screenshot" 

geomery="$(slurp)"

if [[ "$geomery" == "selection cancelled" ]]; then
	log_debug "Screenshot cancelled"
	cleanup
	exit 0
fi

grim -g "$geomery" - >> "$TMP_DIR/$SS_NAME"

if [[ -z $(cat "$TMP_DIR/$SS_NAME") ]]; then
	log_error "Screenshot empty!"
	exit 1
fi

log_debug "Copying to clipboard"
cat "$TMP_DIR/$SS_NAME" | wl-copy

notify-send -i "$TMP_DIR/$SS_NAME" "Screenshot taken!"

cleanup
