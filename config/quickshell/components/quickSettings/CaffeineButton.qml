import Quickshell.Io
import qs.components.quickSettings

QSToggleButton {
	id: caffeineButton
	icon: ""
	primaryText: "Caffeine"
	secondaryText: if (caffeineProcess.running) {
		if (caffeineProcess.runIndefinitely) {
			return "On"
		}
		else {
			return "On, x left"
		}
	}
	else {
		return "Off"
	}

	toggled: caffeineProcess.running
	onClicked: caffeineProcess.running = !caffeineProcess.running

	Process {
		id: caffeineProcess

		property bool runIndefinitely: true
		property int lockTime: runIndefinitely ? 2147483647 : 1800

		command: ["systemd-inhibit", "sleep", lockTime.toString()]
	}
}
