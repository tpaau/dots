# This file contains various source and destination files meant to be sourced
# by the install script. It is not an executable. 

CONF="config"

CAVA_DST="$CONF/cava"
CAVA_SRC="$HOME/.config/cava/config"

FASTFETCH_DST="$CONF/fastfetch"
FASTFETCH_SRC="$HOME/.config/fastfetch/config.jsonc"

HYPR_DST="$CONF/hypr"
HYPR_SRC="$HOME/.config/hypr/sources/style.conf\
	$HOME/.config/hypr/sources/animations.conf"

MAKO_DST="$CONF/mako"
MAKO_SRC="$HOME/.config/mako/config"

SCRIPTS_DST="$CONF/tpaau-17DB/scripts"
SCRIPTS_SRC="$HOME/.config/tpaau-17DB/scripts/"

SHARE_DST="$CONF/usr.share.tpaau-17DB-dots.wlogout"
SHARE_SRC="/usr/share/tpaau-17DB-dots/wlogout/"

WAYBAR_DST="$CONF/waybar"
WAYBAR_SRC="$HOME/.config/waybar/config.jsonc\
	$HOME/.config/waybar/style-black-floating.css\
	$HOME/.config/waybar/style-black-static.css"

WLOGOUT_DST="$CONF/wlogout"
WLOGOUT_SRC="$HOME/.config/wlogout/layout\
	$HOME/.config/wlogout/style.css"

WOFI_DST="$CONF/wofi"
WOFI_SRC="$HOME/.config/wofi/config\
	$HOME/.config/wofi/style.css"
