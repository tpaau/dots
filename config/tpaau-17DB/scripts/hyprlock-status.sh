#!/usr/bin/env bash

# Display some info on the lock screen

if (( $(cat /sys/class/power_supply/AC/online) == 1 )); then
	echo -n " plugged"
else
	echo -n " unplugged"
fi

echo -n "   0: $(cat /sys/class/power_supply/BAT0/capacity)%"
echo -n "   1: $(cat /sys/class/power_supply/BAT1/capacity)%"

exit 0
