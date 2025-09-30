pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.widgets.popout
import qs.widgets.popout.shapes // The linter is lying

Item {
	id: root

	required property int alignment

	default property alias content: container.data

	property bool exclusiveFocus: false

	property int radius: Appearance.rounding.popout
	property int animEasing: Appearance.anims.easings.popout
	property int animDur: Appearance.anims.durations.popout

	property bool opened: false
	property bool visibleOnScreen: popoutWindow.visible

	readonly property bool horizontalMovement:
		alignment == PopoutAlignment.left || alignment == PopoutAlignment.right
	property real desiredWidth: horizontalMovement ? 0 : width
	property real desiredHeight: !horizontalMovement ? 0 : height

	Behavior on desiredWidth {
		NumberAnimation {
			duration: root.animDur
			easing.type: root.animEasing
		}
	}

	Behavior on desiredHeight {
		NumberAnimation {
			duration: root.animDur
			easing.type: root.animEasing
		}
	}

	function open() {
		if (horizontalMovement) {
			desiredWidth = width
		}
		else {
			desiredHeight = height
		}
		popoutWindow.shouldClose = false
		opened = true
	}

	function close() {
		if (horizontalMovement) {
			desiredWidth = 0
		}
		else {
			desiredHeight = 0
		}
		popoutWindow.shouldClose = true
		opened = false
	}

	function toggleOpen() {
		if (opened) {
			close()
		}
		else {
			open()
		}
	}

	PanelWindow {
		id: popoutWindow

		property alias container: container

		visible: !(shouldClose && canClose)
		property bool shouldClose: true
		property bool canClose: {
			if (root.horizontalMovement) {
				return root.desiredWidth == 0 && shouldClose
			}
			else {
				return root.desiredHeight == 0 && shouldClose
			}
		}

		Component.onCompleted: {
			if (root.exclusiveFocus) {
				WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive
			}
		}

		implicitWidth: root.horizontalMovement ?
			root.width + 4
			: root.width

		implicitHeight: !root.horizontalMovement ?
			root.height + 4
			: root.height

		color: "transparent"

		exclusiveZone: 0
		anchors {
			left: root.alignment == PopoutAlignment.left
			top: root.alignment == PopoutAlignment.top
			right: root.alignment == PopoutAlignment.right
			bottom: root.alignment == PopoutAlignment.bottom
		}

		StyledPopoutShape {
			id: shape

			anchors {
				left: if (root.alignment == PopoutAlignment.left) {
					parent.left
				}
				right: if (root.alignment == PopoutAlignment.right) {
					parent.right
				}
				top: if (root.alignment == PopoutAlignment.top) {
					parent.top
				}
				bottom: if (root.alignment == PopoutAlignment.bottom) {
					parent.bottom
				}
				leftMargin: root.alignment == PopoutAlignment.left ? -1 : 0
				rightMargin: root.alignment == PopoutAlignment.right ? -1 : 0
				topMargin: root.alignment == PopoutAlignment.top ? -1 : 0
				bottomMargin: root.alignment == PopoutAlignment.bottom ? -1 : 0
			}

			Component.onCompleted: createPickShape()

			function pickShape(): string {
				let prepend = "shapes/"
				switch (root.alignment) {
					case PopoutAlignment.right:
						return prepend + "RightPopoutShape.qml"
						break;
					case PopoutAlignment.left:
						return prepend + "LeftPopoutShape.qml"
						break;
					case PopoutAlignment.top:
						return prepend + "TopPopoutShape.qml"
						break;
					case PopoutAlignment.bottom:
						return prepend + "BottomPopoutShape.qml"
						break;
					default:
						console.error("Shape for this alignment ID is not defined: " + root.alignment)
						break;
				}
			}

			function createPickShape() {
				let src = pickShape()
				let comp = Qt.createComponent(pickShape(), shape)
				if (comp.status === Component.Error) {
					console.error("Load error: ", comp.errorString())
				}
				else if (comp.status === Component.Ready) {
					addPath(comp)
				}
				else {
					comp.statusChanged.connect(function(newStatus) {
						if (newStatus === Component.Ready) {
							addPath(comp)
						}
						else if (newStatus === Component.Error) {
							console.error("Load error: ", comp.errorString())
						}
						else {
							console.error("Failed loading component: Unknown error")
						}
					})
				}
			}

			function addPath(comp) {
				let pathObj = comp.createObject(shape, {
					width: Qt.binding(() => root.desiredWidth),
					height: Qt.binding(() => root.desiredHeight),
					radius: root.radius,
				})
				if (!pathObj) {
					console.error("Failed to create object: ", comp.errorString())
					return
				}
				data.push(pathObj)
			}

			Item {
				id: container

				anchors {
					fill: parent
					topMargin: root.alignment != PopoutAlignment.top ? root.radius : 0
					bottomMargin: root.alignment != PopoutAlignment.bottom ? root.radius : 0
				}
			}
		}
	}
}
