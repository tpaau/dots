pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root

	property string text

	Process {
		id: mediaFetcherProc
		command: [Quickshell.env("HOME") + "/.config/quickshell/scripts/media-fetcher.py"]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.text = data
			}
		}
	}
}
