#!/usr/bin/env bash

# For `wofi` to open your CLI programs in your preferred terminal, you might
# want to use `ln` to spoof your terminal as konsole or gnome terminal:
# ```
# # ln -s /usr/bin/kitty /usr/bin/gnome-terminal
# ```

source ~/.config/tpaau-17DB/scripts/lib/logger.sh

if [ $(pgrep wlogout) ]; then
	log_info "wlogout already running, stopping"
	exit 1
fi

log_debug "Launching wofi"

cd "$HOME/.config/wofi/"
pkill wofi || wofi -n "$@"
