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
		command: [Quickshell.env("HOME") + "/.config/quickshell/scripts/cpu-temp.py"]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.temp = data
			}
		}
	}

	Process {
		id: cpuPercentProc
		command: [Quickshell.env("HOME") + "/.config/quickshell/scripts/cpu-usage.py"]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.usage = data
			}
		}
	}
}
