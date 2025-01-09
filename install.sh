#!/bin/bash

target_path="$HOME/.config"
wallpapers_path="$HOME/Pictures/wallpapers"
readonly_path="/usr/share/hyprdots/"

# set -x

read -p "This script will overwrite some files in $target_path/, $wallpapers_path/ and /usr/share/hyprdots/ Proceed anyway? (y/n)" choice
case "$choice" in
[Yy]* )
  echo "Proceeding."
  ;;
[Nn]* )
  exit 0
  ;;
* )
  echo "Invalid input. Please answer with 'y' or 'n'."
  exit 1
  ;;
esac

echo "Copying files from config/ to $target_path"

mkdir -p $target_path/cava/
cp config/cava/* $target_path/cava/

mkdir -p $target_path/fastfetch/
cp config/fastfetch/* $target_path/fastfetch/

mkdir -p $target_path/hypr/
cp -r config/hypr/* $target_path/hypr/

mkdir -p $target_path/kitty/
cp config/kitty/* $target_path/kitty/

mkdir -p $target_path/mako/
cp config/mako/* $target_path/mako/

mkdir -p $target_path/shell-scripts/
cp -r config/shell-scripts/* $target_path/shell-scripts/

mkdir -p $target_path/swaylock/
cp config/swaylock/* $target_path/swaylock/

mkdir -p $target_path/waybar/
cp config/waybar/* $target_path/waybar/

mkdir -p $target_path/wlogout/
cp config/wlogout/* $target_path/wlogout/

mkdir -p $target_path/wofi/
cp config/wofi/* $target_path/wofi/

echo "Copying wallpapers."
mkdir -p $HOME/Pictures/wallpapers/
cp wallpapers/* $wallpapers_path

echo "Copying some files to /usr/share/hyprdots/"
sudo bash -c "mkdir -p /usr/share/hyprdots/ &&
    cp -r config/usr.share.hyprdots/* /usr/share/hyprdots/"
