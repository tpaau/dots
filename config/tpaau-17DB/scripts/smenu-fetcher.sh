#!/usr/bin/env bash

# Script used to update status menu data.

if (( LOGGER_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/logger.sh; fi
if ((SMENU_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/smenu.sh; fi

# Time to wait in-between updates in seconds
DELTA=1

THREAD_NAME="smenu-fetcher.sh"
START_THREAD_NAME="smenu-fetcher.sh start"

start() {
    log_debug "Starting '$THREAD_NAME'"

    local last_bt_name=""
    local last_bt_battery=0

    while true; do
        local wifi_enabled=false
        if [[ $(wifi_active) -eq 1 ]]; then
            wifi_enabled=true
        fi

        local wifi_name_tmp="$(wifi_name)"
        local wifi_connected=false
		local wifi_strength_tmp=0
        if [[ -n "$wifi_name_tmp" ]]; then
            wifi_connected=true
			wifi_strength_tmp=$(wifi_strength)
        else
            wifi_name_tmp="Disconnected"
        fi

        local brightness_now=$(brightnessctl get)
        local brightness_max=$(brightnessctl max)
        local brightness=$(( 1 + 100 * brightness_now / brightness_max ))
        (( brightness > 100 )) && brightness=100

        local bt_enabled=false
        if bluetooth | grep -q "on"; then
            bt_enabled=true
        fi

        local bt_name="$(bluetooth_name)"
        local bt_connected=false
        if [[ -n "$bt_name" ]]; then
            bt_connected=true
        else
            bt_name="Disconnected"
        fi

        local bt_battery=0
        if $bt_connected && [[ "$bt_name" != "$last_bt_name" ]]; then
            local mac="$(bluetooth_name_to_mac "$bt_name")"
            local bat=$(bluetooth_battery_percentage "$mac" 2>/dev/null)
            if [[ $? -eq 0 && "$bat" =~ ^[0-9]+$ ]]; then
                bt_battery=$bat
                last_bt_battery=$bat
                last_bt_name="$bt_name"
            else
                bt_battery=$last_bt_battery
            fi
        elif $bt_connected; then
            bt_battery=$last_bt_battery
        fi

        local caffeine=false
        if [[ $(caffeine_enabled) -eq 1 ]]; then
            caffeine=true
        fi

        local speaker_volume=0
        local mic_volume=0
        local sink_vol_line
        sink_vol_line=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null)
        if [[ $sink_vol_line =~ ([0-9]+)% ]]; then
            speaker_volume=${BASH_REMATCH[1]}
        fi

        local source_vol_line
        source_vol_line=$(pactl get-source-volume @DEFAULT_SOURCE@ 2>/dev/null)
        if [[ $source_vol_line =~ ([0-9]+)% ]]; then
            mic_volume=${BASH_REMATCH[1]}
        fi

        eww update \
            wifi-enabled=$wifi_enabled \
            wifi-connected=$wifi_connected \
            wifi-name="$wifi_name_tmp" \
			wifi-strength=$wifi_strength_tmp \
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
