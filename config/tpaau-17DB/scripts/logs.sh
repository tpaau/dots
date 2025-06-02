#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/utils.sh

if [[ $# -eq 0 ]]; then
	log_info "For more options run \`logs.sh --help\`"
	view_logs "$LOG_FILE"
	exit 0
elif [[ $# -eq 2 ]]; then
	if [[ "$1" == "clean" ]]; then
		if [[ "$2" == "today" ]]; then
			clean_items "$LOG_FILE"
			exit 0
		elif [[ "$2" == "all" ]]; then
			clean_items "$LOG_DIR"
			mkdir -p "$LOG_DIR"
			exit 0
		else
			log_error "Unknown subcommand '$2'"
			exit 1
		fi
	else
		log_error "Unknown command: '$1'"
		exit 1
	fi
else
	log_error "Expected at most two arguments!"
	exit 1
fi
