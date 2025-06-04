#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh

check_dependencies pidof wlogout

log_debug "Launching wlogout"

cd $HOME/.config/wlogout/
pidof wlogout || wlogout -b 4 --protocol layer-shell
