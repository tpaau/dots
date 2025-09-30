pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import qs.config
import qs.widgets

Item {
	id: root

	readonly property color background: Appearance.pallete.bg
	property color dimColor: Qt.alpha(
		background, 0.7)

	readonly property int spacing: Appearance.spacing.larger
	readonly property int buttonSize: 128

	IpcHandler {
		id: ipc
		target: "sessionManagement"

		function open() {
			console.debug("Opening session management")
			loader.loading = true
		}
	}

	LazyLoader {
		id: loader

		PanelWindow {
			id: win
			exclusionMode: ExclusionMode.Ignore
			WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

			property bool opened: false
			Component.onCompleted: opened = true

			function close() {
				opened = false
				closeTimer.running = true
				mainRect.fadeOffset = -64
			}

			readonly property int fadeEasing: Appearance.anims.easings.fadeIn
			readonly property int fadeInterval: Appearance.anims.durations.shorter

			anchors {
				top: true
				left: true
				bottom: true
				right: true
			}

			color: "transparent"

			Timer {
				id: closeTimer
				interval: win.fadeInterval
				onTriggered: loader.active = false
			}

			Item {
				id: contentItem
				focus: true

				property Button activeButton: topLeft
				function activateButton(button: Button) {
					if (button != null) {
						activeButton.focused = false
						activeButton = button
						activeButton.focused = true
					}
				}

				Keys.onPressed: event => {
					if (event.key == Qt.Key_Escape) win.close();
					else if (event.key == Qt.Key_Right) {
						activateButton(activeButton.goRight)
					}
					else if (event.key == Qt.Key_Left) {
						activateButton(activeButton.goLeft)
					}
					else if (event.key == Qt.Key_Up) {
						activateButton(activeButton.goUp)
					}
					else if (event.key == Qt.Key_Down) {
						activateButton(activeButton.goDown)
					}
					else if (event.key == Qt.Key_Return) {
						activeButton.exec()
					}
				}
			}

			Rectangle {
				id: dialogRect

				color: root.dimColor
				anchors.fill: parent

				MouseArea {
					anchors.fill: parent
					onClicked: win.close()
				}

				opacity: win.opened? 1 : 0

				Behavior on opacity {
					NumberAnimation {
						easing.type: win.fadeEasing
						duration: win.fadeInterval
					}
				}

				Rectangle {
					id: mainRect

					anchors.centerIn: parent
					property int fadeOffset: 64
					anchors.verticalCenterOffset: fadeOffset
					Behavior on anchors.verticalCenterOffset {
						NumberAnimation {
							easing.type: win.fadeEasing
							duration: win.fadeInterval
						}
					}

					Component.onCompleted: fadeOffset = 0

					color: Appearance.pallete.bg
					radius: Appearance.rounding.large
					layer.enabled: true
					layer.samples: Appearance.misc.layerSampling
					layer.effect: StyledShadow { }
					
					MarginWrapperManager {
						margin: root.spacing
					}

					GridLayout {
						rowSpacing: root.spacing
						columnSpacing: root.spacing
						columns: 2

						Button {
							id: topLeft
							goRight: topRight
							goDown: bottomLeft
							command: "systemctl poweroff"
							icon: ""

							focused: true
						}
						Button {
							id: topRight
							goLeft: topLeft
							goDown: bottomRight
							command: "systemctl reboot"
							icon: ""
						}
						Button {
							id: bottomLeft
							goRight: bottomRight
							goUp: topLeft
							command: "~/.local/bin/lock-screen.sh"
							icon: ""
						}
						Button {
							id: bottomRight
							goLeft: bottomLeft
							goUp: topRight
							command: "swaymsg exit"
							icon: ""
						}
					}

					component Button: StyledButton {
						id: button

						property Button goLeft: null
						property Button goRight: null
						property Button goUp: null
						property Button goDown: null

						property alias icon: styledIcon.text

						required property string command
						property bool focused: false

						implicitWidth: root.buttonSize
						implicitHeight: root.buttonSize
						rect.radius: root.buttonSize / 2

						regularColor: focused ?
							hoveredColor : Appearance.pallete.b2bg
						hoveredColor: Appearance.pallete.b4bg
						pressedColor: Appearance.pallete.b6bg

						onEntered: contentItem.activateButton(this)
						onClicked: exec()

						readonly property Process process: Process {
							command: ["sh", "-c", button.command]
						}

						function exec() {
							process.startDetached();
							win.close();
						}

						StyledIcon {
							anchors.centerIn: parent
							font.pixelSize: Appearance.icons.size.larger
							id: styledIcon
						}
					}

					component ButtonIcon: StyledText {
						font.pixelSize: root.buttonSize / 4
						anchors.centerIn: parent
					}
				}
			}
		}
	}
}
