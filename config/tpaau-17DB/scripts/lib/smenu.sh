CAFFEINE_COMMAND="systemd-inhibit sleep 250214400"

# Returns whether wifi is enabled as exit status. Note that this only checks
# if wifi is *enabled*, not *connected*.
#
# *Takes not arguments*
wifi_active()
{
	nmcli radio wifi | grep -q "enabled" && echo 1 && exit 0
	echo 0
}

# *Takes not arguments*
ether_active()
{
	nmcli device status | grep -q "ethernet.*connected" && echo 1 && exit 0
	echo 0
}

# *Takes not arguments*
wifi_name()
{
	nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2
}

# Returns battery percentage of given bluetooth device.
#
# Args:
# 	$1: The MAC address of the device
bluetooth_battery_percentage()
{
	bluetoothctl info "$MAC" | grep "Battery Percentage" | grep -oP '\(\K[0-9]+(?=\))'
	return $?
}

# Gives MAC address of the specified device name as long as it's connected.
#
# Args:
# 	$1: The name of the device
bluetooth_name_to_mac()
{
	bluetoothctl devices Connected | grep "$1" | awk '{print $2}'
	return $?
}

# *Takes not arguments*
bluetooth_name()
{
	local out="$(bluetoothctl devices Connected 2>/dev/null | head -n 1)"

	echo "$out" | grep "Device " >/dev/null
	if (( $? == 0 )); then
		echo "$out" | awk '{for (i=3; i<=NF; i++) printf $i " "; print ""}'
	else
		echo ""
	fi
}

# Enables caffeine mode.
#
# *Takes no arguments*
enable_caffeine()
{
	disable_caffeine
	$(${CAFFEINE_COMMAND}) & 2>&1 >/dev/null
	return $?
}

# Disables caffeine mode.
#
# *Takes no arguments*
disable_caffeine()
{
	pkill -f "$CAFFEINE_COMMAND" 2>&1 >/dev/null
	return $?
}

# Returns whether caffeine mode is enabled.
#
# *Takes no arguments*
caffeine_enabled()
{
	pgrep -f "$CAFFEINE_COMMAND" 2>&1 >/dev/null
	if [[ $? == 0 ]]; then
		echo 1
		return $?
	else
		echo 0
		return $?
	fi
}
