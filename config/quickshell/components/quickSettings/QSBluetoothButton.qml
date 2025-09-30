import QtQuick
import Quickshell.Bluetooth
import qs.components.quickSettings

QSToggleOptionsButton {
	id: btButton
	readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter

	enabled: adapter.state != BluetoothAdapterState.Enabling
		&& adapter.state != BluetoothAdapterState.Disabling
	toggled: adapter.enabled

	primaryText: "Bluetooth"
	secondaryText: btConns.secondaryText
	innerToggle.onClicked: adapter.enabled = !adapter.enabled

	Connections {
		id: btConns
		target: btButton.adapter

		property string icon: ""
		property string secondaryText: ""

		Component.onCompleted: reloadStuff()
		function onStateChanged() {
			reloadStuff()
		}

		readonly property int connected: {
			let conn = 0
			for (let i = 0; i < btButton.adapter.devices.values.length; i++) {
				if (btButton.adapter.devices.values[i].connected) {
					conn++
				}
			}
			Qt.callLater(reloadStuff)
			return conn
		}

		function reloadStuff() {
			switch (btButton.adapter.state) {
				case BluetoothAdapterState.Disabled:
					icon = ""
					secondaryText = "Disabled"
					return
				case BluetoothAdapterState.Blocked:
					icon = ""
					secondaryText = "Blocked"
					return
				case BluetoothAdapterState.Enabled:
					if (connected > 0) {
						icon = ""
						if (connected == 1) {
							secondaryText = connected + " device connected"
						}
						else {
							secondaryText = connected + " devices connected"
						}
					}
					else {
						icon = ""
						secondaryText = "Enabled"
					}
					return
				case BluetoothAdapterState.Enabling:
					secondaryText = "Enabling"
					return
				case BluetoothAdapterState.Disabling:
					secondaryText = "Disabling"
					return
			}
		}
	}

	icon: btConns.icon
}

