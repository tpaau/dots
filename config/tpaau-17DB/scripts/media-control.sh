#!/usr/bin/env bash

# This script is basically just a wrapper for playerctl, but a damn necessary
# one. Without it, there would be countless race conditions in the shitty media
# fetcher I made.
#
# It's structured in such a way to be the most responsive.
# The `source` commands all over the place aren't (just) my stupidity, they are
# precisely placed only where they are needed.
#
# This, of course, makes the script hard to read and possibly unpredictable,
# but hey, the responsiveness is what counts. Also, it's a small script so the
# spaghetti code is quite manageable.
#
# Without the audio-control widget visible, it should perform just slightly
# under straight up executing `playerctl next` or `playerctl previous`.

SKIP_LOCK_FILE="$TMP_DIR/music-control-skip.lock"

if [[ $# -ne 1 ]]; then
	source ~/.config/tpaau-17DB/scripts/include/logger.sh
	log_error "Expected exactly one argument!"
	exit 1
elif [[ "$1" == "next" ]]; then
	eww active-windows | grep "audio-control" >/dev/null
	if (( $? == 0 )); then
		if [[ -f "$SKIP_LOCK_FILE" ]]; then
			exit 0
		fi
		source ~/.config/tpaau-17DB/scripts/include/paths.sh
		source ~/.config/tpaau-17DB/scripts/include/locks.sh
		touch "$SKIP_LOCK_FILE"
		lock_db "$COVER_EXTRACTION_LOCK"
		playerctl next
		unlock_db "$COVER_EXTRACTION_LOCK"
		rm "$SKIP_LOCK_FILE"
	else
		playerctl next
	fi
elif [[ "$1" == "previous" ]]; then
	eww active-windows | grep "audio-control" >/dev/null
	if (( $? == 0 )); then
		if [[ -f "$SKIP_LOCK_FILE" ]]; then
			exit 0
		fi
		source ~/.config/tpaau-17DB/scripts/include/paths.sh
		source ~/.config/tpaau-17DB/scripts/include/locks.sh
		touch "$SKIP_LOCK_FILE"
		lock_db "$COVER_EXTRACTION_LOCK"
		playerctl previous
		unlock_db "$COVER_EXTRACTION_LOCK"
		rm "$SKIP_LOCK_FILE"
	else
		playerctl previous
	fi
elif [[ "$1" == "clean-cache" ]]; then
	source ~/.config/tpaau-17DB/scripts/include/logger.sh
	log_info "Cleaning cover cache"
	source ~/.config/tpaau-17DB/scripts/include/utils.sh
	source ~/.config/tpaau-17DB/scripts/include/paths.sh
	clean_items "$COVERS_CACHE"
	mkdir -p "$COVERS_CACHE"
	exit 0
else
	source ~/.config/tpaau-17DB/scripts/include/logger.sh
	log_error "Unknown argument: '$1'"
	exit 1
fi
