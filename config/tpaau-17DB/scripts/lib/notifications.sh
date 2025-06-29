NOTIFICATIONS_SOURCED=1

if (( LOGGER_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/logger.sh; fi
if ((ICONS_SOURCED != 1 )); then source ~/.config/tpaau-17DB/scripts/lib/icons.sh; fi

notify_err()
{
	local title="$1"
	local message="$2"
	log_debug "Sending an error-level system notification: '$message'"
	notify-send -i "$ICON_WARN_WHITE" -u critical "$title" "$message" -a "tpaau-17DB script: $0"
}

notify_info()
{
	local title="$1"
	local message="$2"
	log_debug "Sending a nofice-level system notification: '$message'"
	notify-send -i "$ICON_INFO_WHITE" -u normal "$title" "$message" -a "tpaau-17DB script: $0"
}

notify_low()
{
	local title="$1"
	local message="$2"
	log_debug "Sending a low-priority system notification: '$message'"
	notify-send -i "$ICON_INFO_WHITE" -u low "$title" "$message" -a "tpaau-17DB script: $0"
}
