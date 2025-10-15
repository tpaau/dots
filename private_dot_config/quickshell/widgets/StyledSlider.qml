import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import qs.animations
import qs.config

Slider {
	id: root

	property color backgroundColor: Theme.pallete.bg.c5
	property color fillColorIdle: Theme.pallete.fg.c4
	property color fillColorPressed: Theme.pallete.fg.c7

	property real gap: height

	background: ClippingRectangle {
		id: background
		anchors {
			right: parent.right
			top: parent.top
			bottom: parent.bottom
		}

		color: "transparent"
		radius: height / 4

		width: Math.max(
			parent.width - root.visualPosition * root.width - root.gap * 2/3, 0)

		Rectangle {
			anchors {
				top: parent.top
				right: parent.right
				bottom: parent.bottom
			}
			topLeftRadius: height / 4
			bottomLeftRadius: topLeftRadius
			topRightRadius: height / 2
			bottomRightRadius: topRightRadius
			implicitWidth: Math.max(parent.width, topLeftRadius + topRightRadius)

			color: root.backgroundColor
			radius: height / 2
		}
	}

	ClippingRectangle {
		id: fill
		anchors {
			left: parent.left
			top: parent.top
			bottom: parent.bottom
		}

		color: "transparent"
		radius: height / 4

		width: Math.max(root.visualPosition * root.width - root.gap  / 3, 0)

		Rectangle {
			anchors {
				top: parent.top
				bottom: parent.bottom
				left: parent.left
			}
			topLeftRadius: height / 2
			bottomLeftRadius: topLeftRadius
			topRightRadius: height / 4
			bottomRightRadius: topRightRadius
			implicitWidth: Math.max(parent.width, topLeftRadius + topRightRadius)

			color: root.pressed ? root.fillColorPressed : root.fillColorIdle
			radius: height / 2

			Behavior on color {
				ColorTransition {}
			}
		}
	}

	handle: Rectangle {
        x: root.visualPosition * root.width
        y: root.topPadding + root.availableHeight / 2 - height / 2
		width: root.gap / 3
		height: root.height * 2
		radius: Math.min(width, height)
		color: root.pressed ? root.fillColorPressed : root.fillColorIdle

		Behavior on color {
			ColorTransition {}
		}
	}
}
