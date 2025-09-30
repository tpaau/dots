#!/usr/bin/env bash

# Smooth screen dimming with state restore

if (( LOCKS_SOURCED != 1 )); then source "$HOME/.config/tpaau-17DB/scripts/lib/locks.sh"; fi
if (( PATHS_SOURCED != 1 )); then source "$HOME/.config/tpaau-17DB/scripts/lib/paths.sh"; fi
if (( SCREEN_DIM_TUNABLES_SOURCED != 1 )); then source "$HOME/.config/tpaau-17DB/scripts/tunables/screen-dim.sh"; fi

dim()
{
	if ((DIM_TARGET < 1)); then
		brightnessctl s 1%
		return 1
	fi

	local brightness
	brightness="$(brightnessctl -P g)" || return 1
	
	if ((brightness <= DIM_TARGET)); then
		return 1
	fi

	echo "$brightness" > "$BRIGHTNESS_TMP" || return 1

	while true; do
		if (( brightness <= DIM_TARGET )); then
			return 0
		fi

		brightness=$((brightness - STEP))

		if ((brightness < DIM_TARGET)); then
			brightness="$DIM_TARGET"
		fi

		brightnessctl s "$brightness%" >/dev/null 2>&1 || return 1
		sleep "$DELTA"
	done
}

undim()
{
	if [[ -f "$BRIGHTNESS_TMP" ]]; then
		local target_brightness
		target_brightness="$(cat "$BRIGHTNESS_TMP")"

		if (( target_brightness > 100 )); then
			brightnessctl s 100%
			return 1
		fi

		local brightness
		brightness="$(brightnessctl -P g)"

		while true; do
			if ((brightness >= target_brightness)); then
				rm "$BRIGHTNESS_TMP"
				return 0
			fi
			
			brightness=$((brightness + STEP))
			if ((brightness > target_brightness)); then
				brightness=$target_brightness
			fi

			brightnessctl s "$brightness%" >/dev/null 2>&1 || return 1

			sleep "$DELTA"
		done
	else
		return 1
	fi
}

if (( $# == 1 )); then
	if [[ "$1" == "dim" ]]; then
		lock "$SCREEN_DIM_LOCK"
		dim
		unlock "$SCREEN_DIM_LOCK"
		exit $?
	elif [[ "$1" == "undim" ]]; then
		lock "$SCREEN_DIM_LOCK"
		undim
		unlock "$SCREEN_DIM_LOCK"
		exit $?
	else
		if ((LOGGER_SOURCED != 1 )); then source "$HOME/.config/tpaau-17DB/scripts/lib/logger.sh"; fi
		log_error "Unknown argument: '$#'"
		exit 1
	fi
else
	if ((LOGGER_SOURCED != 1 )); then source "$HOME/.config/tpaau-17DB/scripts/lib/logger.sh"; fi
	log_error "Expected exactly one argument!"
	exit 1
fi
