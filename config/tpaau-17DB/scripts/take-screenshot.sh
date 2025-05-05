#!/usr/bin/env bash

# Used for taking screenshots in a nice way

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source $LIB_DIR/notifications.sh
source $LIB_DIR/logger.sh
source $LIB_DIR/check-dependencies.sh

check_dependencies grim slurp cat wl-copy notify-send

TMP_DIR="$HOME/.take-screenshot"
SS_NAME="screenshot.png"

clear_cache()
{
	if [[ -e "$TMP_DIR" ]]; then
		log_info "Cleaning cache"
		rm -rf "$TMP_DIR/"
	fi
}

clear_cache

mkdir -p "$TMP_DIR"

log_info "Taking screenshot" 
grim -g "$(slurp)" - > "$TMP_DIR/$SS_NAME"

log_info "Copying to clipboard"
cat "$TMP_DIR/$SS_NAME" | wl-copy

log_info "Sending notification"
notify-send -i "$TMP_DIR/$SS_NAME" "Screenshot taken!"

clear_cache

log_info "done."
