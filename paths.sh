# This file contains various source and destination files meant to be sourced
# by the install script. It is not an executable. 

CONF="config"

CAVA_DST="$CONF/cava"
CAVA_SRC="$HOME/.config/cava/config"

FASTFETCH_DST="$CONF/fastfetch"
FASTFETCH_SRC="$HOME/.config/fastfetch/config.jsonc"

HYPR_SRC=("$HOME/.config/hypr/sources/style.conf"
	"$HOME/.config/hypr/hyprlock.conf"
	"$HOME/.config/hypr/sources/animations.conf")
HYPR_DST="$CONF/hypr"

TP_SRC="$HOME/.config/tpaau-17DB"
TP_DST="$CONF/tpaau-17DB"

EWW_SRC=("$HOME/.config/eww/eww.yuck"
	"$HOME/.config/eww/eww.css")
EWW_DST="$CONF/eww"

SHARE_DST="$CONF/usr.share.tpaau-17DB-dots.wlogout"
SHARE_SRC="/usr/share/tpaau-17DB-dots/wlogout/"
