pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root

	property int usage

	Process {
		id: memProc
		command: [Quickshell.env("HOME") + "/.config/quickshell/scripts/mem-usage.py"]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.usage = data
			}
		}
	}
}
