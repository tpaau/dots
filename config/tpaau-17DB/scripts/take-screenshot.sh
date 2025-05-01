#!/bin/bash

source ~/.config/tpaau-17DB-scripts/logger.sh

TMP_DIR="$HOME/.take-screenshot"
SS_NAME="screenshot.png"

clear_cache()
{
	if [[ -e "$TMP_DIR" ]]; then
		info "Cleaning cache..."
		rm -rf "$TMP_DIR/"
	fi
}

clear_cache

mkdir -p "$TMP_DIR"

grim -g "$(slurp)" - > "$TMP_DIR/$SS_NAME"

cat "$TMP_DIR/$SS_NAME" | wl-copy

notify-send -i "$TMP_DIR/$SS_NAME" "Screenshot taken!"

clear_cache
