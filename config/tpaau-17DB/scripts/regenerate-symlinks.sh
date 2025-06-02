#!/usr/bin/env bash

source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/logger.sh
source ~/.config/tpaau-17DB/scripts/include/check-dependencies.sh

check_dependencies ln

log_info "Regenerating symlinks"

cd "$HOME/.config/wofi/"
ln -sf "$CURRENT_COLORS" colors.css

cd "$HOME/.config/waybar/"
ln -sf "$CURRENT_COLORS" colors.css

cd "$HOME/.config/wlogout/"
ln -sf "$CURRENT_COLORS" colors.css

cd "$HOME/.config/eww/"
ln -sf "$CURRENT_COLORS" colors.css
