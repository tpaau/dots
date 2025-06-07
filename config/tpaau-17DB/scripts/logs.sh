#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/lib/logger.sh
source ~/.config/tpaau-17DB/scripts/lib/paths.sh
source ~/.config/tpaau-17DB/scripts/lib/utils.sh

COMMAND=""
SUBCOMMAND_REQUIRED=true
SUBCOMMAND=""

print_usage()
{
	echo "This is going to be a help message!" >&2
}

set_command()
{
	local command="$1"
	case $command in
		show)
			COMMAND=$command
			SUBCOMMAND_REQUIRED=false
			;;
		clean)
			COMMAND=$command
			SUBCOMMAND_REQUIRED=true
			;;
		*)
			log_error "Unknown command: '$command'"
			return 1
			;;
	esac
}

set_subcommand()
{
	local subcommand="$1"
	case $subcommand in
		today)
			if [[ $COMMAND == "show" || $COMMAND == "clean" ]]; then
				SUBCOMMAND=$subcommand
			fi
			;;
		*)
			if [[ $COMMAND == "show" || $COMMAND == "clean" ]]; then
				if [[ $COMMAND == "clean" ]]; then
					if [[ $subcommand == "all" ]]; then
						SUBCOMMAND=$subcommand
						return 0
					fi
				fi
				date -d "$subcommand" 2>&1 >/dev/null
				if (( $? == 0 )); then
					SUBCOMMAND=$subcommand
					return 0
				else
					log_error "Not a valid date: '$subcommand'"
					log_info "Provide date in format '%Y-%d-%m', like so: $(date +%Y-%d-%m)"
					return 1
				fi
			else
				log_error "Unknown subcommand for '$COMMAND': '$subcommand'"
				return 1
			fi
			;;
	esac
}

parse_args()
{
	local subcommand_next=false
	for arg in "$@"; do
		if [[ $subcommand_next == false ]]; then
			case $arg in
				clean|show)
					set_command "$arg"
					local status=$?
					if (( $status != 0 )); then
						log_error "Failed setting command '$arg'"
						return $status
					fi
					subcommand_next=true
					;;
				*)
					log_error "Unknown argument: '$arg'"
					print_usage
					return 1
					;;
			esac
		else
			set_subcommand "$arg"
			local status=$?
			if (( $status != 0 )); then
				log_error "Failed setting subcommand '$arg'"
				return $?
			fi
		fi
	done

	if [[ $SUBCOMMAND_REQUIRED == true && -z $SUBCOMMAND ]]; then
		log_error "Expected subcommand for '$COMMAND'"
	fi
}

run_command()
{
	case $COMMAND in
		show)
			if [[ -z $SUBCOMMAND || $SUBCOMMAND == "today" ]]; then
				view_logs "$LOG_FILE"
				return $?
			else
				local log_file="dots-$SUBCOMMAND.log"
				view_logs "$log_file"
				return $?
			fi
			;;
		clean)
			if [[ -z $SUBCOMMAND ]]; then
				log_error "Subcommand for '$COMMAND' is required"
				return 1
			elif [[ $SUBCOMMAND == "today" ]]; then
				clean_items "$LOG_FILE"
				return $?
			elif [[ $SUBCOMMAND == "all" ]]; then
				clean_items "$LOG_DIR/"
				return $?
			else
				local log_file="$dots-$SUBCOMMAND.log"
				clean_items "$log_file"
				return $?
			fi
			;;
		*)
			log_error "Unknown command: '$COMMAND'"
			log_info "Could the script have been altered?"
			return 1
			;;
	esac
}

if (( $# == 0 )); then
	view_logs "$LOG_FILE"
	exit 0
else
	parse_args "$@"
	status=$?
	if (( $status == 0 )); then
		run_command
		exit $?
	else
		log_error "Failed parsing args: '$@'"
		exit 1
	fi
fi
