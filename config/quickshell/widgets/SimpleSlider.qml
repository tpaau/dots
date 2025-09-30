import QtQuick
import QtQuick.Controls
import qs.animations
import qs.config

Slider {
	id: root

	property color textColor: Appearance.pallete.b2bg
	property color backgroundColor: Appearance.pallete.b2bg
	property color fillColorIdle: Appearance.pallete.fg
	property color fillColorPressed: Appearance.pallete.b3fg

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
