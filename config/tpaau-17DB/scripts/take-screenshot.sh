#!/usr/bin/env bash

# Used for taking screenshots in a nice way

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/notifications.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh

check_dependencies grim slurp cat wl-copy notify-send

SS_NAME="screenshot.png"

clear_cache()
{
	if [[ -e "$TMP_DIR/$SS_NAME" ]]; then
		log_info "Cleaning cache"
		rm -rf "$TMP_DIR/$SS_NAME"
	fi
}

if [[ $(pgrep -x slurp) ]]; then
	log_warning "Another screenshot utility is likely running, stopping."
	exit 0
fi

clear_cache

mkdir -p "$TMP_DIR"

log_info "Taking screenshot" 
grim -g "$(slurp)" - >> "$TMP_DIR/$SS_NAME"

if [[ -z $(cat "$TMP_DIR/$SS_NAME") ]]; then
	log_warning "Screenshot empty, likely canceled. Stopping."
	exit 0
fi

log_info "Copying to clipboard"
cat "$TMP_DIR/$SS_NAME" | wl-copy

log_info "Sending notification"
notify-send -i "$TMP_DIR/$SS_NAME" "Screenshot taken!"

clear_cache
