# This file contains various source and destination files meant to be sourced
# by the install script. It is not an executable. 

CONF="config"

CAVA_DST="$CONF/cava"
CAVA_SRC="$HOME/.config/cava/config"

FASTFETCH_DST="$CONF/fastfetch"
FASTFETCH_SRC="$HOME/.config/fastfetch/config.jsonc"

HYPR_DST="$CONF/hypr"
HYPR_SRC=("$HOME/.config/hypr/sources/style.conf"
	"$HOME/.config/hypr/sources/animations.conf")

TP_DST="$CONF/tpaau-17DB/"
TP_SRC="$HOME/.config/tpaau-17DB"

ICONS_SRC="$HOME/.config/tpaau-17DB/icons"
ICONS_DST="$CONF/tpaau-17DB/icons"

SHARE_DST="$CONF/usr.share.tpaau-17DB-dots.wlogout"
SHARE_SRC="/usr/share/tpaau-17DB-dots/wlogout/"
