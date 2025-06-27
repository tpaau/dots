#!/usr/bin/env bash

# This script is to be run at every startup.

source ~/.config/tpaau-17DB/scripts/lib/check-dependencies.sh
source ~/.config/tpaau-17DB/scripts/lib/themes.sh

if (( $# != 0 )); then
	log_warning "Any arguments passed to this script will be ignored"
fi

status=0

run_step run_all_depchecks
run_setp on_theme_loaded

if (( $status == 0 )); then
	log_debug "Executed successfully"
	exit $status
else
	notify_err "Error" "Failed to execute all on-startup commands. Enable file logging, reboot your system and run \`./logs.sh\` for more info."
	log_error "Failed to execute all the on-startup commands, see errors above"
	exit $status
fi
