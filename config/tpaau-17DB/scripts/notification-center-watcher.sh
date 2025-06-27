#!/usr/bin/env bash

ACTIVATION_X=1900
ACTIVATION_Y=1050
DEACTIVATION_X=1400
DEACTIVATION_Y=600

DELTA=0.5

activate()
{
	eww open notification-center
}

deactivate()
{
	eww close notification-center
}

watch()
{
	local pos_x=0
	local pos_y=0
	local out=""
	local active=false
	while true; do
		sleep $DELTA
		out="$(hyprctl cursorpos)"
		pos_x=${out%%,*}
		pos_y=${out#*, }
		if [[ $active == false ]]; then
			if (( pos_x > ACTIVATION_X && pos_y > ACTIVATION_Y )); then
				active=true
				activate
			fi
		else
			if (( pos_x < DEACTIVATION_X || pos_y < DEACTIVATION_Y )); then
				active=false
				deactivate
			fi
		fi
	done
}

watch
exit $?
