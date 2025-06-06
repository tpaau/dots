#!/usr/bin/env bash

# This script is to be run at every startup. It ensures any leftovers from
# previous boot are removed, essential variables and temporary files
# regenerated, and the environment set up for action.

source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/notifications.sh
source ~/.config/tpaau-17DB/scripts/include/locks.sh
source ~/.config/tpaau-17DB/scripts/include/utils.sh

if (( $# != 0 )); then
	log_warning "Any arguments passed to this script will be ignored"
fi

status=0

run_step ./smenu-utils.sh regenerate-variables
run_step remove_locks
run_step remove_leftover_tmp
run_step run_all_depchecks

if (( $status == 0 )); then
	log_debug "Executed successfully"
	exit $status
else
	notify_err "Failed to execute all on-startup commands. Enable file logging, reboot your system and run \`./logs.sh\` for more info."
	log_error "Failed to execute all the on-startup commands, see errors above"
	exit $status
fi
