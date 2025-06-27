#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/lib/logger.sh

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
