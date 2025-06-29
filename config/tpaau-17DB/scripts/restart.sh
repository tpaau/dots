#!/usr/bin/env bash

if (( THEMES_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/themes.sh; fi
if (( NOTIFICATIONS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/notifications.sh; fi

# Restarts various programs and utilities.
#
# Takes no arguments.
restart_programs()
{
	log_debug "Restarting some programs"

	(
		log_debug "Restarting waybar"
		pkill waybar
		waybar
	) &

	(
		log_debug "Restarting hyprpaper"
		pkill hyprpaper
		hyprpaper
	) &

	(
		log_debug "Reloading eww"
		eww reload
	) &

	(
		log_debug "Reload hyprland"
		hyprctl reload
	) &

	# Kill leftovers
	(
		log_debug "Killing any unclosed wofi instances"
		pkill wofi

		log_debug "Killing any unclosed wlogout instances"
		pkill wlogout
	) &

	# mako mustn't be run asynchronously as it needs to notify user when the
	# theme is reloaded
	log_debug "Restarting mako"
	pkill -x mako
	mako &
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

	notify_low "Reloaded config" "Reapplied the current theme and restarted all relevant programs."

	on_theme_loaded
}

if (( $# != 1 )); then
	log_error "Expected exactly one argument!"
	exit 1
fi

if [[ "$1" == "full" ]]; then
	full_restart
	exit $?
elif [[ "$1" == "programs" ]]; then
	restart_programs
	exit $?
else
	log_error "Unknown argument: '$1'"
	exit 1
fi
