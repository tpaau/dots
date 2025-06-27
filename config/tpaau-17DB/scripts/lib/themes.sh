source ~/.config/tpaau-17DB/scripts/lib/apply-colors.sh
source ~/.config/tpaau-17DB/scripts/lib/utils.sh

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

# Returns pretty names of all themes found under THEMES_DIR.
#
# Takes no arguments.
get_themes_pretty()
{
	get_theme_paths | while read -r theme; do
		source "$THEMES_DIR/$theme"
		echo "$NAME_PRETTY"
	done
}

# Returns a relative path for a theme with the given name.
#
# Args:
# 	$1: The pretty name of the theme
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

# Checks if the given theme file exists and is usable.
#
# Args:
# 	$1: The absolute path of the theme file
check_theme()
{
	local theme="$1"
	if [[ ! -f "$theme" ]]; then
		log_error "Theme '$theme' does not exist!"
		return 1
	fi

	source "$theme"
	if (( $? != 0 )); then
		log_error "Sourcing '$theme' failed!"
		return 1
	fi
}

install_wallpaper()
{
	local wallpaper="$1"
	local restart_hyprpaper=$2

	if [[ ! -f "$wallpaper" ]]; then
		log_error "Cannot install wallpaper: '$wallpaper' is not a file"
		return 1
	else
		cp "$wallpaper" "$CURRENT_WALLPAPER"
	fi

	if [[ $restart_hyprpaper == true ]]; then
		log_debug "Restarting hyprpaper"
		while pgrep -x hyprpaper 2>&1 >/dev/null; do
			pkill hyprpaper 2>&1 >/dev/null
			sleep 0.01
		done

		hyprpaper 2>&1 >/dev/null &
	fi

	return $?
}

# Executes theme hooks.
# 
# Args:
# 	$1: The absolute path to the theme file to get hooks from
# 	$2: The hook type, can be one of the following:
# 	  - on-install
# 	  - on-uninstall
# 	  - on-load
run_hooks()
{
	local theme_file="$1"
	local hook_type="$2"

	local hook=""
	if [[ "$hook_type" == "on-install" ]]; then
		hook="ON_INSTALL"
	elif [[ "$hook_type" == "on-uninstall" ]]; then
		hook="ON_UNINSTALL"
	elif [[ "$hook_type" == "on-load" ]]; then
		hook="ON_LOAD"
	else
		log_error "Unknown hook type: '$hook_type'"
		return 1
	fi

	source "$theme_file"
	if (( $? == 0 )); then
		if [[ ! -z "${!hook}" ]]; then
			log_debug "Running $hook_type hook"
			bash -c "${!hook}"
			if (( $? != 0 )); then
				log_error "Failed running $hook_type hook: '${!hook}'"
			fi
			return $?
		else
			log_info "Skipping $hook_type hook: hook empty"
			return $?
		fi
	else
		log_error "Can't run $hook_type hooks: failed sourcing theme file '$theme_file'"
			return 1
	fi
}

on_theme_loaded()
{
	if [[ -f "$CURRENT_THEME" ]]; then
		local theme="${THEMES_DIR}/$(name_pretty_to_path_relative "$(cat "$CURRENT_THEME")")"
		run_hooks "$theme" "on-load"
	else
		log_error "Can't run on-load hooks: '$CURRENT_THEME' is missing"
	fi
}

# Installs theme from its NAME_PRETTY but doesn't apply it.
#
# Args:
# 	$1: The pretty name of the theme to install
install_theme()
{
	# We run this in a subshell so the settings from the next theme won't get
	# mixed with the settings of the current one
	$(
		if [[ -f "$CURRENT_THEME" ]]; then
			local prev_theme="${THEMES_DIR}/$(name_pretty_to_path_relative "$(cat "$CURRENT_THEME")")"
			run_hooks "$prev_theme" "on-uninstall"
		else
			log_error "Can't run on-uninstall hooks: '$CURRENT_THEME' is missing"
		fi
	)

	local name_pretty="$1"

	log_debug "Installing theme '$name_pretty'"

	local theme="$THEMES_DIR/$(name_pretty_to_path_relative "$name_pretty")"

	check_theme "$theme"
	if (( $? != 0 )); then
		return 1
	fi

	local status=0
	run_step install_wallpaper "$WALLPAPER"
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

	if (( status == 0 )); then
		log_debug "Successfully installed '$name_pretty'"
		echo "$name_pretty" > "$CURRENT_THEME"
	else
		log_err "Failed installing '$name_pretty'"
	fi

	return $status
}

# Installs and applies given theme if it's not yet the current theme.
#
# Args:
# 	$1: The pretty name of the theme to apply
apply_theme()
{
	local name_pretty="$1"

	log_debug "Applying '$name_pretty'"

	local current_theme=$(cat "$CURRENT_THEME")

	if [[ "$name_pretty" == "$current_theme" ]]; then
		log_warning "'$name_pretty' is already the current theme, ignoring request."
		return 0
	fi

	install_theme "$name_pretty"
	local status=$?

	run_step apply_colors
	kitten themes --reload-in all "$KITTY_THEME"
	if (( $? != 0 )); then
		log_error "Failed appling kitty theme, maybe you have no internet connection?"
	fi

	if (( $status == 0 )); then
		log_debug "Theme applied succesfully"
		"$SCRIPTS_DIR/restart.sh" programs
	else
		log_error "Failed loading '$name_pretty'"
		notify_err "Error" "Failed loading '$name_pretty'"
	fi

	if [[ -f "$CURRENT_THEME" ]]; then
		local theme="${THEMES_DIR}/$(name_pretty_to_path_relative "$(cat "$CURRENT_THEME")")"
		run_hooks "$theme" "on-install"
		run_hooks "$theme" "on-load"
	else
		log_error "Can't run on-install hooks: '$CURRENT_THEME' is missing"
	fi

	return $status
}
