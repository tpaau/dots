#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh
source ~/.config/tpaau-17DB/scripts/include/themes.sh

check_dependencies pkill pgrep waybar mako hyprpaper wofi wlogout

# Restarts various programs and utilities.
#
# Takes no arguments.
restart_programs()
{
	log_debug "Restarting some programs"

	log_debug "Restarting waybar"
	pkill -x waybar 2>&1 >/dev/null

	while pgrep -x waybar 2>&1 >/dev/null; do
		sleep 0.1
	done

	waybar 2>&1 >/dev/null &


	log_debug "Restarting mako"
	pkill -x mako 2>&1 >/dev/null

	while pgrep -x mako 2>&1 >/dev/null; do
		sleep 0.1
	done

	mako 2>&1 >/dev/null &


	log_debug "Restarting hyprpaper"
	while pgrep -x hyprpaper 2>&1 >/dev/null; do
		pkill hyprpaper 2>&1 >/dev/null
		sleep 0.1
	done

	hyprpaper 2>&1 >/dev/null &


	log_debug "Reloading eww"
	eww reload 2>&1 >/dev/null &

	./smenu-utils.sh regenerate-variables

	log_debug "Reload hyprland"
	hyprctl reload 2>&1 >/dev/null &

	# Kill leftovers
	log_debug "Killing any unclosed wofi instances"
	pkill wofi 2>&1 >/dev/null

	log_debug "Killing any unclosed wlogout instances"
	pkill wlogout 2>&1 >/dev/null
}

# Reinstalls config files for the current theme and restart affected programs.
#
# Takes no arguments.
full_restart()
{
	log_debug "Starting a full restart"

	local name_pretty="$(cat "$CURRENT_THEME")"
	install_theme "$name_pretty"

	log_debug "Reloading config"

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
