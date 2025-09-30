import QtQuick
import qs.animations
import qs.config

MouseArea {
	id: root

	property alias rect: rect

	property color disabledColor: Appearance.pallete.b4bg
	property color regularColor: Appearance.pallete.b3bg
	property color hoveredColor: Appearance.pallete.b5bg
	property color pressedColor: Appearance.pallete.b7bg

	property int margin: Appearance.spacing.small
	property int marginHorizontal: 0
	property int marginVertical: 0

	property bool changeColors: true
	property int radius: Appearance.rounding.normal

	hoverEnabled: true
	function determineColor(): color {
		if (root.changeColors) {
			if (containsPress) {
				return root.pressedColor
			}
			else if (containsMouse) {
				return root.hoveredColor
			}
			return root.regularColor
		}
		return null
	}

	Rectangle {
		id: rect
		anchors.fill: parent
		color: root.enabled ? root.determineColor() : root.disabledColor
		radius: root.radius

		Behavior on color {
			ColorTransition {
				id: anim
			}
		}

		Behavior on radius {
			NumberAnimation {
				duration: anim.duration
				easing.type: anim.easing.type
			}
		}
	}
}
