source ~/.config/tpaau-17DB/scripts/include/paths.sh
source $LIB_DIR/icons.sh

notify_err()
{
	local message="$1"
	notify-send -i "$ICON_WARN_RED" -u critical "$message"
}

notify_info()
{
	local message="$1"
	notify-send -i "$ICON_INFO_WHITE" -u normal "$message"
}

notify_low()
{
	local message="$1"
	notify-send -i "$ICON_INFO_WHITE" -u low "$message"
}
