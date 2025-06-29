PATHS_SOURCED=1

# Directory containing various config files
CONF="$HOME/.config"

# The base directory for tpaau-17DB dots
TP="$CONF/tpaau-17DB"

# Directory containing various files for absolute path access
SHARE="/usr/share/tpaau-17DB-dots"

# Directory containing cached files
CACHE_DIR="$TP/cache"
mkdir -p "$CACHE_DIR/"

# Directory containing temporary items
TMP_DIR="/tmp/tpaau-17DB"
mkdir -p "$TMP_DIR/"
chmod -R 700 "$TMP_DIR/"

# The output of '$(date +%Y-%m-%d)'
CURRENT_DATE="$(date +%Y-%m-%d)"

# File holding powersave mode state
POWERSAVE_STATUS="$CACHE_DIR/powersave"

# Neovim colorscheme for the current theme
NVIM_COLORSCHEME_FILE="$CACHE_DIR/nvim-colorscheme"

# Directory containing wallpapers
WALLPAPERS_DIR="$TP/wallpapers"

# Target directory containing currently used wallpapers
CURRENT_WALLPAPERS_DIR="$HOME/Pictures/wallpapers"

# The current desktop wallpaper
CURRENT_WALLPAPER="$CURRENT_WALLPAPERS_DIR/current.png"

# The current lockscreen wallpaper. If this file does not exist, screen lock
# will fall back to background color of the current theme.
CURRENT_LOCKSCREEN="$CURRENT_WALLPAPERS_DIR/lockscreen.png"

# File containing the current colorscheme
CURRENT_COLORS="$TP/cache/current-colors.css"

# Directory containing CSS color themes
COLORS_DIR="$TP/colors"

# Directory containing themes
THEMES_DIR="$TP/themes"

# File containing the pretty name of the current theme
CURRENT_THEME="$CACHE_DIR/current-theme"

# Directory containing all the executable scripts
SCRIPTS_DIR="$TP/scripts"

# Directory containing various config files
TP_CONF="$TP/config"

COVER_EXTRACTION_LOCK="$TMP_DIR/cover-extraction.lock"
