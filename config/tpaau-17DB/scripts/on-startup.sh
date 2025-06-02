#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/logger.sh

if [[ $# -ne 1 ]]; then
	log_warning "Any arguments passed to this script will be ignored"
fi

smenu-utils.sh regenerate-variables
