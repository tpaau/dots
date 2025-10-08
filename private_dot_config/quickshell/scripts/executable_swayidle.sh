#!/usr/bin/env bash

killall "swayidle"

SCRIPTS="$HOME/.config/quickshell/scripts"

(swayidle -w\
	timeout 300 "$HOME/.local/bin/lock-screen.sh"\
	before-sleep "$HOME/.local/bin/lock-screen.sh"\
	lock "$HOME/.local/bin/lock-screen.sh") &

swayidle \
	timeout 240 "brightnessctl -s s 1%" \
	resume "brightnessctl -r" \
	timeout 250 "niri msg action power-off-monitors" \
	timeout 250 "bash -c \"if [[ \"$(cat /sys/class/power_supply/AC/online)\" == \"1\" ]]; then systemctl sleep\"" \
	resume "brightnessctl -r"
