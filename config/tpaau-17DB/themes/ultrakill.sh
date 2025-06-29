# THIS IS JUST A TEMPLATE FILE, DO NOT SOURCE

source ~/.config/tpaau-17DB/scripts/lib/paths.sh

# The name displayed in wofi
NAME_PRETTY="ULTRAKILL"

# Path to the wallpaper
WALLPAPER="$WALLPAPERS_DIR/ultrakill-v1.png"

# Path to the lockscreen wallpaper, usually the same as regular wallpaper
# When set to an empty string, hyprlock will fall back to background color
LOCKSCREEN="$WALLPAPERS_DIR/ultrakill-v1.png"

# Path to the CSS colors file
COLORS="$COLORS_DIR/ultrakill.css"

# The name of the kitty theme to apply
KITTY_THEME="Black Metal"

# Path to mako config file
MAKO_CONF="$TP_CONF/mako/config"

# Paths to waybar config files
WAYBAR_CONF="$TP_CONF/waybar/config.jsonc"
WAYBAR_CSS="$TP_CONF/waybar/floating.css"

# Paths to wlogout config files
WLOGOUT_CONF="$TP_CONF/wlogout/layout"
WLOGOUT_CSS="$TP_CONF/wlogout/style.css"

# Paths to wofi config files
WOFI_CONF="$TP_CONF/wofi/config"
WOFI_CSS="$TP_CONF/wofi/style.css"

# THEME HOOKS
# 
# They are triggered on certain actions
#
# Leave them empty to do nothing

# Command to execute by bash when installing the theme
ON_INSTALL=""

# Command to execute by bash when uninstalling the theme
ON_UNINSTALL=""

# Command to execute by bash when the theme is loaded (applied or reapplied)
ON_LOAD=""

# Neovim colorscheme (requires the colorscheme to be installed)
NVIM_COLORSCHEME="onedark_dark"
