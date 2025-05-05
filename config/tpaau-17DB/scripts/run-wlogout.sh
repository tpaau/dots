#!/usr/bin/env bash

cd $HOME/.config/wlogout/
pidof wlogout || wlogout -b 4 --protocol layer-shell
