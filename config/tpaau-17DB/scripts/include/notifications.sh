source ~/.config/tpaau-17DB/scripts/include/paths.sh
source ~/.config/tpaau-17DB/scripts/include/icons.sh

notify_err()
{
	local message="$1"
	notify-send -i "$ICON_WARN_WHITE" -u critical "$message"
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
