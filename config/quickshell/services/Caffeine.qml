pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {

	property alias running: proc.running
	property alias runIndefinitely: proc.runIndefinitely

	Process {
		id: proc

		property bool runIndefinitely: true
		property int lockTime: runIndefinitely ? 2147483647 : 1800

		command: ["systemd-inhibit", "sleep", lockTime.toString()]
	}
}
