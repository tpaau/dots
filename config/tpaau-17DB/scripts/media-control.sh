#!/usr/bin/env bash

# This script is basically just a wrapper for playerctl, but a damn necessary
# one. Without it, there would be countless race conditions in the shitty media
# fetcher I made.
#
# Note the carefully placed `source` statements to save precious seconds.
#
# I look forward to deleting ts once I finish my customizable, memory-safe,
# blazingly-fast media fetcher in rust.

if (( $# != 1 )); then
	source ~/.config/tpaau-17DB/scripts/lib/logger.sh
	log_error "Expected exactly one argument!"
	exit 1
elif [[ "$1" == "next" ]]; then
	# Prevent multiskip
	pgrep -f "media-control next" || pgrep -f "media-control previous"
	if (( $? != 0 )); then
		source ~/.config/tpaau-17DB/scripts/lib/locks.sh
		lock_db "$COVER_EXTRACTION_LOCK"
		playerctl next
		unlock_db "$COVER_EXTRACTION_LOCK"
		exit 0
	fi
	exit 1
elif [[ "$1" == "previous" ]]; then
	# Prevent multiskip
	pgrep -f "media-control next" || pgrep -f "media-control previous"
	if (( $? != 0 )); then
		source ~/.config/tpaau-17DB/scripts/lib/locks.sh
		lock_db "$COVER_EXTRACTION_LOCK"
		playerctl previous
		unlock_db "$COVER_EXTRACTION_LOCK"
		exit 0
	fi
	exit 1
elif [[ "$1" == "clean-cache" ]]; then
	source ~/.config/tpaau-17DB/scripts/lib/covers.sh
	log_info "Cleaning cover cache"
	clean_items "$COVERS_CACHE"
	mkdir -p "$COVERS_CACHE"
	exit 0
else
	source ~/.config/tpaau-17DB/scripts/lib/logger.sh
	log_error "Unknown argument: '$1'"
	exit 1
fi
