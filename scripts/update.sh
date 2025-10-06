#!/usr/bin/env bash

NIRI_DIR="$HOME/.config/niri"
QUICKSHELL_DIR="$HOME/.config/quickshell"

main() {
	cd "$(git rev-parse --show-toplevel)" || return 1

	rm -r "config/" || return 2

	mkdir -p "config/$(basename "$NIRI_DIR")" || return 2
	mkdir -p "config/$(basename "$QUICKSHELL_DIR")" || return 2

	cp -r "$NIRI_DIR"/* "config/$(basename "$NIRI_DIR")" || return 2
	cp -r "$QUICKSHELL_DIR"/* "config/$(basename "$QUICKSHELL_DIR")" || return 2

	git status || return 1
}

main
