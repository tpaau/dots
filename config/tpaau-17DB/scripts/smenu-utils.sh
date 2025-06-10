#!/usr/bin/env bash

# This script is used by the status-menu eww widget.
#
# This script needs to be fast as it can potentially be run hundreds of times
# a seconds when invoked from a slider.

wifi_active()
{
	nmcli radio wifi | grep -q "enabled"
	return $?
}

ether_active()
{
	nmcli device status | grep -q "ethernet.*connected"
	return $?
}

is_int()
{
	if [[ "$1" =~ ^-?[0-9]+$ ]]; then
		return 1
	fi
	return 0
}

powersave_status()
{
	if [[ -f "$POWERSAVE_STATUS" ]]; then
		if [[ "$(cat "$POWERSAVE_STATUS")" == "1" ]]; then
			return 1
		else
			return 0
		fi
	else
		echo 0 > "$POWERSAVE_STATUS"
	fi
}

toggle_wifi()
{
	source ~/.config/tpaau-17DB/scripts/lib/logger.sh
	wifi_active
	if (( $? == 0 )); then
		eww update wifi-active=false
		nmcli radio wifi off
		log_debug "WiFi turned off"
	else
		eww update wifi-active=true
		nmcli radio wifi on
		log_debug "WiFi turned on"
	fi
}

toggle_ether()
{
	source ~/.config/tpaau-17DB/scripts/lib/logger.sh
	ether_active
	if (( $? == 0 )); then
		eww update ethernet-active=false
		nmcli device disconnect "$ETHER_DEVICE"
		log_debug "Ethernet turned off"
	else
		eww update ethernet-active=true
		nmcli device connect "$ETHER_DEVICE"
		log_debug "Ethernet turned on"
	fi
}

toggle_bluetooth()
{
	source ~/.config/tpaau-17DB/scripts/lib/logger.sh
	bluetooth | grep "on"
	if (( $? == 0 )); then
		eww update bluetooth-active=false
		bluetooth off
		log_debug "Bluetooth turned off"
	else
		eww update bluetooth-active=true
		bluetooth on
		log_debug "Bluetooth turned on"
	fi
	return 0
}

toggle_powersave()
{
	source ~/.config/tpaau-17DB/scripts/lib/logger.sh
	powersave_status
	if (( $? == 0 )); then
		echo 1 > "$POWERSAVE_STATUS"
		eww update powersave-active=true
		log_debug "Powersave on"
	else
		echo 0 > "$POWERSAVE_STATUS"
		eww update powersave-active=false
		log_debug "Powersave off"
	fi

	return 0
}

ste_brightness()
{
	is_int "$1"
	if (( $? == 1 )); then
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
	is_int "$1"
	if (( $? == 1 )); then
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
	is_int "$1"
	if (( $? == 1 )); then
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

regenerate_variables()
{
	source ~/.config/tpaau-17DB/scripts/lib/logger.sh
	log_debug "Regenerating eww variables"

	if (( $# != 0 )); then
		log_warning "Any further argument will be ignored"
	fi

	if [[ "$(nmcli radio wifi)" == "enabled" ]]; then
		eww update wifi-active=true
	else
		eww update wifi-active=false
	fi

	eww update brightness-percent="$(bc <<< "100 * $(brightnessctl get) / $(brightnessctl max)"))"
	bluetooth | grep "on"
	if (( $? == 0 )); then
		eww update bluetooth-active=true
	else
		eww update bluetooth-active=false
	fi

	powersave_status
	if (( $? == 0 )); then
		eww update powersave-active=false
	else
		eww update powersave-active=true
	fi

	local speaker=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
	eww update speaker-volume=$speaker

	local mic=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -oP '\d+(?=%)' | head -1)
	eww update mic-volume=$mic

	return 0
}

if (( $# == 0 )); then
	source ~/.config/tpaau-17DB/scripts/lib/logger.sh
	log_error "Expected at least one argument!"
	exit 1
elif (( $# > 2 )); then
	source ~/.config/tpaau-17DB/scripts/lib/logger.sh
	log_error "Expected at most two arguments!"
	exit 1
else
	if [[ "$1" == "toggle-wifi" ]]; then
		toggle_wifi
		exit $?
	elif [[ "$1" == "toggle-ether" ]]; then
		toggle_ether
		exit $?
	elif [[ "$1" == "toggle-bluetooth" ]]; then
		toggle_bluetooth
		exit $?
	elif [[ "$1" == "toggle-powersave" ]]; then
		toggle_powersave
		exit $?
	elif [[ "$1" == "set-brightness" ]]; then
		ste_brightness "$2"
		exit $?
	elif [[ "$1" == "set-mic" ]]; then
		set_mic_volume $2
		exit $?
	elif [[ "$1" == "set-speaker" ]]; then
		set_speaker_volume $2
		exit $?
	elif [[ "$1" == "regenerate-variables" ]]; then
		regenerate_variables
		exit $?
	else
		log_error "Unknown argument: '$1'"
		exit 1
	fi
fi
