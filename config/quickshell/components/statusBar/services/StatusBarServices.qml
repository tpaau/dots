pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root

	function openBtop() {
		btopOpener.running = true
		console.log("Opening btop")
	}

	function toggleMediaPlayer() {
		mediaPlayerToggler.running = true
		console.log("Toggling media-control")
	}

	function toggleStatusMenu() {
		statusMenuToggler.running = true
		console.log("Toggling status-menu")
	}

	Process {
		id: btopOpener
		command: ["kitty", "--start-as=fullscreen", "btop"]
		running: false
	}

	Process {
		id: mediaPlayerToggler
		command: [Quickshell.env("HOME") + "/.config/tpaau-17DB/scripts/toggle-widget.sh", "media-control"]
		running: false
	}

	Process {
		id: statusMenuToggler
		command: [Quickshell.env("HOME") + "/.config/tpaau-17DB/scripts/toggle-widget.sh", "status-menu"]
		running: false
	}
}
