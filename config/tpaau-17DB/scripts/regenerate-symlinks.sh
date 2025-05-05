#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source $LIB_DIR/logger.sh
source $LIB_DIR/check-dependencies.sh

check_dependencies ln

COLOR="$COLORS_DIR/current.css"

log_info "Regenerating symlinks"

cd "$HOME/.config/wofi/"
ln -sf "$COLOR" colors.css

cd "$HOME/.config/waybar/"
ln -sf "$COLOR" colors.css

cd "$HOME/.config/wlogout/"
ln -sf "$COLOR" colors.css
