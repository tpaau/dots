#!/usr/bin/env bash

# Offset can be added so that if it's invoked from a  widget the widget has
# some time to fade away
if (( $# > 0 )); then
	if [[ $2 == true ]]; then
		~/.config/tpaau-17DB/scripts/toggle-widget.sh status-menu
	fi
	sleep "$1"
fi

# Running multiple instances of hyprshot is fun
pkill hyprshot || hyprshot --freeze -o ~/Pictures/Screenshots -m region -m eDP-1
