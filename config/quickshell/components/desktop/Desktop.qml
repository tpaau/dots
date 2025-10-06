import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.widgets
import qs.config

PanelWindow {
	id: root

	color: Theme.pallete.bg

	WlrLayershell.layer: WlrLayer.Background

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}

	Image {
		anchors.centerIn: parent
		source: Settings.wallpaper.source
		fillMode: Image.PreserveAspectFit
	}

	MouseArea {
		id: desktopArea
		anchors.fill: parent
		acceptedButtons: Qt.AllButtons
		propagateComposedEvents: true
		onClicked: (mouse) => {
			if (!contextMenu.containsMouse) {
				contextMenu.close()
				mouse.accepted = false
				if (mouse.button == Qt.RightButton) {
					contextMenu.targetX = mouseX - contextMenu.width + 10
					contextMenu.targetY = mouseY - contextMenu.height + 10
					contextMenu.open()
				}
			}
		}
	}

	ContextMenu {
		id: contextMenu

		property real targetX: 0
		property real targetY: 0

		onOpened: {
			x = targetX
			y = targetY
		}

		Component {
			id: entry
			DropDownMenuEntry {}
		}

		disabledColor: Theme.pallete.bg.c1
		regularColor: Theme.pallete.bg.c2
		hoveredColor: Theme.pallete.bg.c3
		pressedColor: Theme.pallete.bg.c4

		entries: {
			let entries = []
			entries.push(entry.createObject(null, {
				index: 0,
				name: "Settings",
				icon: ""
			}))
			entries.push(entry.createObject(null, {
				index: 0,
				name: "Wallpaper",
				icon: ""
			}))
			return entries
		}
	}
}
