#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source $LIB_DIR/logger.sh

apply_theme()
{
	local theme="$1"
	local current_theme=$(cat "$CACHE_DIR/current-theme")
	local target="$THEMES_DIR/$theme.sh"
	local status=0

	if [[ "$theme" == "$current_theme" ]]; then
		log_warning "'$theme' is already the current theme, ignoring request."
		return 0
	fi

	log_info "Checking theme file"

	if [[ ! -f "$target" ]]; then
		log_error "Theme '$target' does not exist!"
		return 1
	fi

	source "$target"
	if [[ $? -ne 0 ]]; then
		log_error "Sourcing '$target' failed! Please make sure it has correct bash syntax."
		return 1
	fi

	cp "$WALLPAPER" "$CURRENT_WALLPAPER_PATH"
	((status+=$?))
	cp "$COLORS" "$CURRENT_COLORS_PATH"
	((status+=$?))
	source $LIB_DIR/apply-colors.sh
	((status+=$?))
	apply_colors
	((status+=$?))
	kitten themes --reload-in all "$KITTY_THEME"
	((status+=$?))

	if [[ $status -eq 0 ]]; then
		"$SCRIPTS_DIR/reload-config.sh"
		((status+=$?))
	fi

	if [[ $status -eq 0 ]]; then
		echo "$theme" > "$CACHE_DIR/current-theme"
	fi

	return $status
}
