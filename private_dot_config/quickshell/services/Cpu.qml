pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root

	property string temp
	property real usage

	Process {
		id: cpuTempProc
		command: [Qt.resolvedUrl("../scripts/cpu-temp.py")]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.temp = data
			}
		}
	}

	Process {
		id: cpuPercentProc
		command: [Qt.resolvedUrl("../scripts/cpu-usage.py")]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.usage = data
			}
		}
	}
}
