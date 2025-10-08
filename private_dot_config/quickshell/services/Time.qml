pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property string time
	property int unix

	function formatTimeElapsed(minutes: int): string {
		if (minutes == 0) {
			return "now"
		}
		else {
			let m = minutes
			let result = ""

			let d = Math.floor(m / 1440)
			if (d != 0) result += d + "d "
			m -= d * 1440

			let h = Math.floor(m / 60)
			if (h != 0 || d != 0) result += h + "h "
			m -= h * 60

			result += m + "m"

			return result
		}
	}

	Process {
		id: dateProc
		command: ["date", "+%H:%M:%S"]
		running: true

		stdout: StdioCollector {
			onStreamFinished: root.time = text.trim()
		}
	}

	Process {
		id: unixTimeProc
		command: ["date", "+%s"]
		running: true

		stdout: StdioCollector {
			onStreamFinished: root.unix = text.trim()
		}
	}

	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: {
			dateProc.running = true
			unixTimeProc.running = true
		}
	}
}
