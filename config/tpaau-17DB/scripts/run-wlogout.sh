#!/usr/bin/env bash

log_debug "Launching wlogout"

cd $HOME/.config/wlogout/
pidof wlogout || wlogout -b 4 --protocol layer-shell
