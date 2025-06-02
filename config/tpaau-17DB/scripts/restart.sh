#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh
source ~/.config/tpaau-17DB/scripts/include/themes.sh

check_dependencies pkill pgrep waybar mako hyprpaper wofi wlogout

# Just restart all the programs
restart_programs()
{
	log_info "Restarting all the programs"

	# Relaunch waybar
	log_info "Reloading waybar"
	pkill -x waybar > /dev/null 2>&1

	while pgrep -x waybar > /dev/null 2>&1; do
		sleep 0.1
	done

	waybar > /dev/null 2>&1 &


	# Relaunch mako
	log_info "Reloading mako"
	pkill -x mako > /dev/null 2>&1

	while pgrep -x mako > /dev/null 2>&1; do
		sleep 0.1
	done

	mako > /dev/null 2>&1 &


	# Relaunch hyprpaper
	log_info "Reloading hyprpaper"
	while pgrep -x hyprpaper > /dev/null 2>&1; do
		pkill hyprpaper > /dev/null 2>&1
		sleep 0.1
	done

	hyprpaper > /dev/null 2>&1 &

	log_info "Reloading eww"
	eww reload 2>&1 &

	./smenu-utils.sh regenerate-variables

	# Kill leftovers
	log_info "Killing any unclosed wofi instances"
	pkill wofi > /dev/null 2>&1

	log_info "Killing any unclosed wlogout instances"
	pkill wlogout > /dev/null 2>&1
}

# Reinstall the theme and restart alll the programs
full_restart()
{
	log_info "Starting a full restart"

	local name_pretty="$(cat "$CURRENT_THEME")"
	install_theme "$name_pretty"

	log_info "Reloading config"

	$SCRIPTS_DIR/regenerate-symlinks.sh

	restart_programs
}

if [[ $# -ne 1 ]]; then
	log_error "Expected exactly one argument!"
	exit 1
fi

if [[ "$1" == "full" ]]; then
	full_restart
	exit 0
elif [[ "$1" == "programs" ]]; then
	restart_programs
	exit 0
else
	log_error "Unknown argument: '$1'"
	exit 1
fi
