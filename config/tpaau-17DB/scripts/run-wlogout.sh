#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/lib/paths.sh

log_debug "Launching wlogout"

cd $HOME/.config/wlogout/
pidof wlogout || wlogout -b 4 --protocol layer-shell
