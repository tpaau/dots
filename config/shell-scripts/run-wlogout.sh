#!/bin/bash

if pgrep "wlogout" > /dev/null; then
	echo "error: wlogout is already running. Ignoring request."
else
	wlogout -b 3 --protocol layer-shell
fi
