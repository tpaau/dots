pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root

	property int usage

	Process {
		id: memProc
		command: [Qt.resolvedUrl("../scripts/mem-usage.py")]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.usage = data
			}
		}
	}
}
