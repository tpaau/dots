#!/usr/bin/env bash

cd "$HOME/.config/wofi/"
pkill wofi || wofi -n "$@"
