source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/apply-colors.sh

# Returns relative paths of all the theme files under THEMES_DIR.
#
# Takes no arguments.
get_theme_paths()
{
	local themes=""
	for theme in $(ls "$THEMES_DIR" | grep -v "template.sh"); do
		themes+="$theme\n"
	done
	echo -en "$themes"
}

get_themes_pretty()
{
	get_theme_paths | while read -r theme; do
		source "$THEMES_DIR/$theme"
		echo "$NAME_PRETTY"
	done
}

name_pretty_to_path_relative()
{
	local name="$1"
	while read -r theme; do
		source "$THEMES_DIR/$theme"
		if [[ "$name" == "$NAME_PRETTY" ]]; then
			echo "$theme"
			return 0
		fi
	done < <(get_theme_paths)

	log_error "No theme with pretty name '$name'"
	return 1
}

# Runs given command, if the command exists with a non-zero code, global status
# variable is set to 1.
#
# Args:
# 	$1: The command to run
run_step()
{
    "$@" || status=1
}

check_theme()
{
	local theme="$1"
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

# Installs theme from its NAME_PRETTY but doesn't apply it.
install_theme()
{
	local name_pretty="$1"

	log_info "Installing theme '$name_pretty'"

	local theme="$THEMES_DIR/$(name_pretty_to_path_relative "$name_pretty")"

	check_theme "$theme"
	if [[ $? -ne 0 ]]; then
		return 1
	fi

	local status=0
	run_step cp "$WALLPAPER" "$CURRENT_WALLPAPER"
	run_step cp "$MAKO_CONF" "$CONF/mako/config"
	run_step cp "$WAYBAR_CONF" "$CONF/waybar/config.jsonc"
	run_step cp "$WAYBAR_CSS" "$CONF/waybar/style.css"
	run_step cp "$WLOGOUT_CONF" "$CONF/wlogout/layout"
	run_step cp "$WLOGOUT_CSS" "$CONF/wlogout/style.css"
	run_step cp "$WOFI_CONF" "$CONF/wofi/config"
	run_step cp "$WOFI_CSS" "$CONF/wofi/style.css"
	run_step cp "$COLORS" "$CURRENT_COLORS"
	if [[ -f "$CURRENT_LOCKSCREEN" ]]; then
		rm "$CURRENT_LOCKSCREEN"
	fi
	if [[ ! -z "$LOCKSCREEN" ]]; then
		run_step cp "$LOCKSCREEN" "$CURRENT_LOCKSCREEN"
	else
		log_warning "Theme doesn't contain lockscreen wallpaper, hyprlock will fall back to backgound color."
	fi

	if [[ $status -eq 0 ]]; then
		log_info "Successfully installed '$name_pretty'"
		echo "$name_pretty" > "$CURRENT_THEME"
	else
		log_err "Failed installing '$name_pretty'"
	fi

	return $status
}

# Takes pretty theme name as argument and applies it if it's not yet the
# current theme.
apply_theme()
{
	local name_pretty="$1"

	log_info "Applying '$name_pretty'"

	local current_theme=$(cat "$CURRENT_THEME")

	if [[ "$name_pretty" == "$current_theme" ]]; then
		log_warning "'$name_pretty' is already the current theme, ignoring request."
		return 0
	fi

	install_theme "$name_pretty"
	local status=$?

	log_info "Applying '$name_pretty'"

	run_step apply_colors
	run_step kitten themes --reload-in all "$KITTY_THEME"

	if [[ $status -eq 0 ]]; then
		log_info "Theme applied succesfully"
		"$SCRIPTS_DIR/restart.sh" programs
	else
		log_error "Failed loading '$name_pretty'"
		notify_err "Failed loading '$name_pretty'"
	fi

	return $status
}
