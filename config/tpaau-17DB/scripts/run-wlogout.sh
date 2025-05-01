#!/bin/bash

# make sure we are not running multiple instances of wlogout
pidof wlogout || wlogout -b 4 --protocol layer-shell
