#!/usr/bin/env bash

SCREENSHOT_OUTPUT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_OUTPUT_DIR"

ensure_no_slurp() {
	if pgrep "slurp"; then
		return 1
	fi
	return 0
}

take_screenshot()
{
	local immediate="$1"
	if [[ "$immediate" != true ]]; then
		ensure_no_slurp || return 1
	fi

	if [[ "$immediate" != true ]]; then
		local geometry
		geometry="$(slurp)" || return 1
		if [[ "$geometry" == "selection cancelled" ]]; then
			return 0
		fi
	fi

	local output
	output="$SCREENSHOT_OUTPUT_DIR/screenshot_$(date +%Y-%d-%m-%H%M%S).png" || return 1
	touch "$output" || return 1
	if [[ "$immediate" == true ]]; then
		grim "$output" || return 1
	else
		grim -g "$geometry" "$output" || return 1
	fi
	wl-copy < "$output" || return 1
	notify-send -a "$(basename "$0")" -i "$output" "Screenshot taken" "Screenshot saved to $output and copied to clipboard."
}

take_screenshot "$1"
exit $?
