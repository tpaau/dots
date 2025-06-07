source ~/.config/tpaau-17DB/scripts/lib/logger.sh
source ~/.config/tpaau-17DB/scripts/lib/icons.sh

notify_err()
{
	local message="$1"
	log_debug "Sending an error-level system notification: '$message'"
	notify-send -i "$ICON_WARN_WHITE" -u critical "$message"
}

notify_info()
{
	local message="$1"
	log_debug "Sending a nofice-level system notification: '$message'"
	notify-send -i "$ICON_INFO_WHITE" -u normal "$message"
}

notify_low()
{
	local message="$1"
	log_debug "Sending a low-priority system notification: '$message'"
	notify-send -i "$ICON_INFO_WHITE" -u low "$message"
}
