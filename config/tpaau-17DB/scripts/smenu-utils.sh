#!/usr/bin/env bash

# This script is used by the status-menu eww widget.
#
# This script needs to be fast as it can potentially be run hundreds of times
# a seconds when invoked from a slider.

if (( SMENU_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/smenu.sh; fi
if (( UTILS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/utils.sh; fi
if (( LOGGER_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/logger.sh; fi

toggle_wifi()
{
	local active=$(wifi_active)
	if (( active == 1 )); then
		eww update wifi-enabled=false
		nmcli radio wifi off
		log_debug "WiFi turned off"
	else
		eww update wifi-enabled=true
		nmcli radio wifi on
		log_debug "WiFi turned on"
	fi
}

toggle_bluetooth()
{
	bluetooth | grep "on"
	if (( $? == 0 )); then
		eww update bluetooth-enabled=false
		bluetooth off
		log_debug "Bluetooth turned off"
	else
		eww update bluetooth-enabled=true
		bluetooth on
		log_debug "Bluetooth turned on"
	fi
	return 0
}

set_brightness()
{
	if [[ $(is_int $1) -eq 1 ]]; then
		input=$(( $1 + 1 ))
		brightnessctl set $(bc <<< "($input * $(brightnessctl max)) / 100")
		eww update brightness-percent=$input
		return 0
	else
		return 1
	fi
}

set_mic_volume()
{
	if [[ $(is_int $1) -eq 1 ]]; then
		local volume=$(( $1 + 1 ))
		if (( $volume == 1 )); then
			pactl set-source-volume @DEFAULT_SOURCE@ 0%
			eww update mic-volume=0
		else
			pactl set-source-volume @DEFAULT_SOURCE@ ${volume}%
			eww update mic-volume=$volume
		fi
	else
		return 1
	fi
}

set_speaker_volume()
{
	if [[ $(is_int $1) -eq 1 ]]; then
		local volume=$(( $1 + 1 ))
		if (( $volume == 1 )); then
			pactl set-sink-volume @DEFAULT_SINK@ 0%
			eww update speaker-volume=0
		else
			pactl set-sink-volume @DEFAULT_SINK@ ${volume}%
			eww update speaker-volume=$volume
		fi
	else
		return 1
	fi
}

toggle_caffeine()
{
	if [[ $(caffeine_enabled) == 0 ]]; then
		eww update caffeine-enabled=true
		enable_caffeine
		return $?
	else
		eww update caffeine-enabled=false
		disable_caffeine
		return $?
	fi
}

if (( $# == 0 )); then
	log_error "Expected at least one argument!"
	exit 1
elif (( $# > 2 )); then
	log_error "Expected at most two arguments!"
	exit 1
else
	if [[ "$1" == "toggle-wifi" ]]; then
		toggle_wifi
		exit $?
	elif [[ "$1" == "toggle-bluetooth" ]]; then
		toggle_bluetooth
		exit $?
	elif [[ "$1" == "toggle-caffeine" ]]; then
		toggle_caffeine
		exit $?
	elif [[ "$1" == "set-brightness" ]]; then
		set_brightness "$2"
		exit $?
	elif [[ "$1" == "set-mic" ]]; then
		set_mic_volume $2
		exit $?
	elif [[ "$1" == "set-speaker" ]]; then
		set_speaker_volume $2
		exit $?
	else
		log_error "Unknown argument: '$1'"
		exit 1
	fi
fi
