#!/usr/bin/env bash

# Starts a loop that watches whether the system is connected to an external
# power supply and starts a countdown to `systemctl sleep` when it is not.
#
# It's main function is to be executed by a system idler like `hypridle` to
# ensure the system will only go to sleep when it is not plugged in.

# The time between checks in seconds
DELTA=10

# The time to system sleep, also in seconds
TIMEOUT=120

start()
{
	local countdown=$TIMEOUT
	while true; do
		if [[ "$(cat /sys/class/power_supply/AC/online)" == "1" ]]; then
			countdown=$TIMEOUT
		else
			if (( countdown <= 0 )); then
				countdown=$TIMEOUT
				systemctl sleep
			else
				countdown=$((countdown - DELTA))
			fi
		fi
		sleep $DELTA
	done
}

start
exit $?
