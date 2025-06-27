#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/lib/themes.sh

if [[ $1 == true ]]; then
	~/.config/tpaau-17DB/scripts/toggle-widget.sh status-menu
fi

pick_wallpaper()
{
	wallpapers=$(ls "$WALLPAPERS_DIR")

	wallpaper=$(echo -en "$wallpapers"\
		| "$SCRIPTS_DIR/run-wofi.sh" --dmenu --allow-images --prompt "Pick a wallpaper...")

	if [ ! -z "$wallpaper" ]; then
		log_debug "Picked '$wallpaper'"
		install_wallpaper "$WALLPAPERS_DIR/$wallpaper" true
		return $?
	else
		log_warning "No theme picked, ignoring."
	fi
}

pick_wallpaper
exit $?
