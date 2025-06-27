#!/usr/bin/env bash

# Script used to update status menu data.

source ~/.config/tpaau-17DB/scripts/lib/logger.sh
source ~/.config/tpaau-17DB/scripts/lib/smenu.sh

# Time to wait in-between updates in seconds
DELTA=1

THREAD_NAME="smenu-fetcher.sh"
START_THREAD_NAME="smenu-fetcher.sh start"

start()
{
	log_debug "Starting '$THREAD_NAME'"

	while true; do
		local wifi_enabled=false
		if [[ $(wifi_active) -eq 1 ]]; then
			wifi_enabled=true
		fi

		local wifi_name_tmp="$(wifi_name)"
		local wifi_connected=false
		if [[ ! -z "$wifi_name_tmp" ]]; then
			wifi_connected=true
		else
			wifi_name_tmp="Disconnected"
		fi

		local brightness=$(( 1 + 100 * $(brightnessctl get) / $(brightnessctl max) ))
		if (( brightness > 100 )); then
			brightness=100
		fi

		local bt_enabled=false
		bluetooth | grep "on" && bt_enabled=true

		local bt_connected=false
		local bt_name="$(bluetooth_name)"
		if [[ ! -z "$bt_name" ]]; then
			bt_connected=true
		else
			bt_name="Disconnected"
		fi

		local bt_battery=0
		if [[ $bt_connected == true && ! -z "$bt_name" ]]; then
			local bat=$(bluetooth_battery_percentage "$(bluetooth_name_to_mac "$bt_name")")
			if (( $? == 0 )); then
				bt_battery=$bat
			fi
		fi

		local caffeine=false
		if [[ $(caffeine_enabled) -eq 1 ]]; then
			caffeine=true
		fi

		local speaker_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
		local mic_volume=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -oP '\d+(?=%)' | head -1)

		eww update wifi-enabled=$wifi_enabled \
			wifi-connected=$wifi_connected \
			wifi-name="$wifi_name_tmp" \
			brightness-percent=$brightness \
			bluetooth-enabled=$bt_enabled \
			bluetooth-connected=$bt_connected \
			bluetooth-name="$bt_name" \
			bluetooth-battery=$bt_battery \
			caffeine-enabled=$caffeine \
			speaker-volume=$speaker_volume \
			mic-volume=$mic_volume

		sleep $DELTA
	done

	return $?
}

stop()
{
	log_debug "Stopping '$START_THREAD_NAME'"

	pkill -f "$START_THREAD_NAME"
	local status=$?
	if (( $status != 0 )); then
		log_warning "Failed to kill '$START_THREAD_NAME'. A bug perhaps?"
		exit $status
	fi
}

if (( $# != 1 )); then
	log_error "Expected exactly one argument"
else
	if [[ "$1" == "start" ]]; then
		start
		exit $?
	elif [[ "$1" == "stop" ]]; then
		stop
		exit $?
	else
		log_error "Unknown argument: '$1'"
		exit 1
	fi
fi
