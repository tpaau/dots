#!/usr/bin/env bash

killall "swayidle"

SCRIPTS="$HOME/.config/tpaau-17DB/scripts"

swayidle -w\
	timeout 300 "$HOME/.local/bin/lock-screen.sh"\
	before-sleep "$HOME/.local/bin/lock-screen.sh"\
	lock "$HOME/.local/bin/lock-screen.sh" &

swayidle \
	timeout 240 "$SCRIPTS/dim-screen.sh dim"\
		resume "$SCRIPTS/dim-screen.sh undim"
	timeout 310 "$SCRIPTS/sleep-on-bat.sh"
		resume "pkill -f \"$SCRIPTS/sleep-on-bat.sh\"" &
