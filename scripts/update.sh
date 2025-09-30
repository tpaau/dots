#!/usr/bin/env bash

SWAY_DIR="$HOME/.config/sway"
QUICKSHELL_DIR="$HOME/.config/quickshell"

main() {
	cd "$(git rev-parse --show-toplevel)" || return 1

	rm -r "config/" || return 2

	mkdir -p "config/$(basename "$SWAY_DIR")" || return 2
	mkdir -p "config/$(basename "$QUICKSHELL_DIR")" || return 2

	cp -r "$SWAY_DIR"/* "config/$(basename "$SWAY_DIR")" || return 2
	cp -r "$QUICKSHELL_DIR"/* "config/$(basename "$QUICKSHELL_DIR")" || return 2

	git status || return 1
}

main
