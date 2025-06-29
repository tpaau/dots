#!/usr/bin/env bash

if ((LOGGER_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/logger.sh; fi

parse_notification()
{
	local notifications="$(makoctl history)"

	if [[ ! -z "$notifications" ]]; then
		return 0
	else
		log_error "'makoctl history' gave an empty string"
	fi

	return $?
}

parse_notification
exit $?
