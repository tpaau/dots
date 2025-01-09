#!/bin/bash

target_path="$HOME/.config"
conf_path="$(pwd)/config"

# set -x

read -p "This script will overwrite some files in $target_path. Proceed anyway? (y/n)" choice
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

echo "Copying files from $conf_path to $target_path"

mkdir -p $target_path/cava/
cp $conf_path/cava/* $target_path/cava/

mkdir -p $target_path/fastfetch/
cp $conf_path/fastfetch/* $target_path/fastfetch/

mkdir -p $target_path/hypr/
cp -r $conf_path/hypr/* $target_path/hypr/

mkdir -p $target_path/kitty/
cp $conf_path/kitty/* $target_path/kitty/

mkdir -p $target_path/mako/
cp $conf_path/mako/* $target_path/mako/

mkdir -p $target_path/shell-scripts/
cp -r $conf_path/shell-scripts/* $target_path/shell-scripts/

mkdir -p $target_path/swaylock/
cp $conf_path/swaylock/* $target_path/swaylock/

mkdir -p $target_path/waybar/
cp $conf_path/waybar/* $target_path/waybar/

mkdir -p $target_path/wlogout/
cp $conf_path/wlogout/* $target_path/wlogout/

mkdir -p $target_path/wofi/
cp $conf_path/wofi/* $target_path/wofi/
