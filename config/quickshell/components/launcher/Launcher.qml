pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.widgets
import qs.widgets.popout

Item {
	IpcHandler {
		id: handler
		target: "launcher"

		function toggleOpen(): void {
			loader.toggleOpen()
		}
	}

	LazyLoader {
		id: loader

		function toggleOpen() {
			if (active) {
				console.warn("Closing!")
				if (popout) {
					popout.close()
				}
			}
			else {
				console.warn("Opening!")
				active = true
			}
		}

		onPopoutChanged: if (popout) {
			popout.open()
		}

		property Popout popout

		Popout {
			id: popout
			alignment: PopoutAlignment.bottom
			animDur: Appearance.anims.durations.shortish
			exclusiveFocus: true

			implicitWidth: 800
			implicitHeight: 600

			Component.onCompleted: {
				loader.popout = this
			}

			onVisibleOnScreenChanged: {
				if (!visibleOnScreen) {
					Qt.callLater(function() { loader.popout = null })
					loader.active = false
				}
			}

			Rectangle {
				color: Appearance.pallete.b1bg

				anchors {
					right: parent.right
					top: parent.top
					left: parent.left
					topMargin: popout.radius
					rightMargin: popout.radius * 6
					leftMargin: popout.radius * 6
				}

				implicitHeight: 80
				radius: popout.radius

				StyledText {
					anchors.fill: parent
					anchors.margins: 16
					color: Appearance.pallete.d1fg
					font.pixelSize: Appearance.font.sizeLarge
					text: "Search..."
					verticalAlignment: Text.AlignVCenter
					visible: textInput.text == ""
				}

				StyledTextInput {
					id: textInput
					anchors.fill: parent
					anchors.margins: 16
					font.pixelSize: Appearance.font.sizeLarge
					focus: true
					verticalAlignment: TextInput.AlignVCenter
				}
			}
		}
	}
}

