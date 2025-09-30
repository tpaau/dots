import QtQuick
import QtQuick.Controls
import qs.animations
import qs.config

Slider {
	id: root

	property color backgroundColor: Appearance.pallete.b4bg
	property color fillColorIdle: Appearance.pallete.fg
	property color fillColorPressed: Appearance.pallete.b3fg

	property real gap: height

	background: Rectangle {
		color: root.backgroundColor

		topRightRadius: Math.abs(height / 2)
		bottomRightRadius: topRightRadius
		topLeftRadius: Math.abs(height / 4)
		bottomLeftRadius: topLeftRadius

		anchors {
			right: parent.right
			top: parent.top
			bottom: parent.bottom
		}

		width: parent.width - root.visualPosition * root.width - root.gap * 2/3
	}

	Rectangle {
		id: fill
		color: root.pressed ? root.fillColorPressed : root.fillColorIdle

		topLeftRadius: Math.abs(height / 2)
		bottomLeftRadius: topLeftRadius
		topRightRadius: Math.abs(height / 4)
		bottomRightRadius: topRightRadius

		anchors {
			left: parent.left
			top: parent.top
			bottom: parent.bottom
		}

		width: root.visualPosition * root.width - root.gap  / 3

		Behavior on color {
			ColorTransition {}
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
