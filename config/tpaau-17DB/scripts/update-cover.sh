#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh
source ~/.config/tpaau-17DB/scripts/include/covers.sh

check_dependencies eww

WAITTIME=0.1

update_cover()
{
	eww active-windows | grep "audio-control" >/dev/null
	if (( $? != 0 )); then
		log_debug "Widget 'audio-control' not open, cancelling cover update"
		return 0
	fi

	local cover_path="$(get_cover "$(playerctl metadata --format "{{title}} - {{artist}}")")"
	if (( $? != 0 )); then
		log_error "Failed getting cover, exited with a non-zero code"
		eww update cover-path="$cover_path"
		return 1
	elif [[ -z "$cover_path" ]]; then
		log_info "Got an empty cover path, will retry in ${WAITTIME}s"
		sleep $WAITTIME
		update_cover &
		return 0
	fi
	eww update cover-path="$cover_path"
	log_debug "Updated cover"
	return 0
}

update_cover
exit $?
