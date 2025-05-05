#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source $LIB_DIR/logger.sh

run_step()
{
    "$@" || status=1
}

check_theme()
{
	local theme="$1"
	log_info "Checking theme file"
	if [[ ! -f "$theme" ]]; then
		log_error "Theme '$theme' does not exist!"
		return 1
	fi

	source "$theme"
	if [[ $? -ne 0 ]]; then
		log_error "Sourcing '$theme' failed!"
		return 1
	fi
}

apply_theme()
{
	local theme="$1"
	local current_theme=$(cat "$CACHE_DIR/current-theme")
	local theme="$THEMES_DIR/$theme.sh"
	status=0

	if [[ "$theme" == "$current_theme" ]]; then
		log_warning "'$theme' is already the current theme, ignoring request."
		return 0
	fi

	check_theme "$theme"
	if [[ $? -ne 0 ]]; then
		return 1
	fi

	run_step cp "$WALLPAPER" "$CURRENT_WALLPAPER_PATH"
	run_step cp "$MAKO_CONF" "$CONF/mako/config"
	run_step cp "$WAYBAR_CONF" "$CONF/waybar/config.jsonc"
	run_step cp "$WAYBAR_CSS" "$CONF/waybar/style.css"
	run_step cp "$WLOGOUT_CONF" "$CONF/wlogout/layout"
	run_step cp "$WLOGOUT_CSS" "$CONF/wlogout/style.css"
	run_step cp "$WOFI_CONF" "$CONF/wofi/config"
	run_step cp "$WOFI_CSS" "$CONF/wofi/style.css"
	run_step cp "$COLORS" "$CURRENT_COLORS_PATH"
	run_step source $LIB_DIR/apply-colors.sh
	run_step apply_colors
	run_step kitten themes --reload-in all "$KITTY_THEME"

	if [[ $status -eq 0 ]]; then
		"$SCRIPTS_DIR/reload-config.sh"
		((status+=$?))
	fi

	if [[ $status -eq 0 ]]; then
		echo "$theme" > "$CACHE_DIR/current-theme"
	fi

	return $status
}
