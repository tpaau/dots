import QtQuick
import QtQuick.Controls
import qs.animations
import qs.config

Slider {
	id: root

	property color textColor: Theme.pallete.bg.c3
	property color backgroundColor: Theme.pallete.bg.c3
	property color fillColorIdle: Theme.pallete.fg.c4
	property color fillColorPressed: Theme.pallete.fg.c7

	background: Rectangle {
		color: root.backgroundColor
		radius: Math.min(width, height)

		Rectangle {
			anchors.bottom: parent.bottom

			width:  {
				if (root.orientation == Qt.Horizontal) {
					(1 - root.visualPosition) * parent.width + root.visualPosition * handle.width
				}
				else {
					parent.width
				}
			}
			height: {
				if (root.orientation == Qt.Vertical) {
					(1 - root.visualPosition) * parent.height + root.visualPosition * handle.height
				}
				else {
					parent.height
				}
			}
			color: root.pressed ? root.fillColorPressed : root.fillColorIdle
			radius: parent.radius

			Behavior on color {
				ColorTransition {}
			}
		}
	}

	handle: Rectangle {
		id: handle

		anchors {
			left: root.orientation === Qt.Vertical ? parent.left : undefined
			right: root.orientation === Qt.Vertical ? parent.right : undefined
			top: root.orientation === Qt.Horizontal ? parent.top : undefined
			bottom: root.orientation === Qt.Horizontal ? parent.bottom : undefined
		}

		y: {
			if (root.orientation == Qt.Vertical) {
				root.topPadding + root.visualPosition * (root.availableHeight - height)
			}
			else 0
		}
		x: {
			if (root.orientation == Qt.Horizontal) {
				root.bottomPadding + root.visualPosition * (root.availableWidth - width)
			}
			else 0
		}

		implicitWidth: root.width
		implicitHeight: root.width
		radius: Math.min(width, height)

		color: root.pressed ? root.fillColorPressed : root.fillColorIdle
		Behavior on color {
			ColorTransition {}
		}
	}
}
