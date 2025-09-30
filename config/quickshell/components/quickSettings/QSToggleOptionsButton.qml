import QtQuick
import QtQuick.Layouts
import qs.components.quickSettings
import qs.widgets
import qs.config

QSButton {
	id: root

	enabled: true
	property bool toggled: true

	property alias icon: styledIcon.text
	property alias primaryText: textPrimary.text
	property alias secondaryText: textSecondary.text
	property alias innerToggle: innerToggle

	disabledColor: Appearance.pallete.b1bg
	regularColor: Appearance.pallete.b3bg
	hoveredColor: Appearance.pallete.b5bg
	pressedColor: Appearance.pallete.b7bg

	function determineColor(): color {
		if (root.changeColors) {
			if (containsPress) {
				return root.pressedColor
			}
			else if (containsMouse && !innerToggle.containsMouse) {
				return root.hoveredColor
			}
			return root.regularColor
		}
		return null
	}

	readonly property color contentColor: {
		if (enabled) {
			return Appearance.pallete.fg
		}
		return Appearance.pallete.d3fg
	}

	StyledButton {
		id: innerToggle

		Layout.fillHeight: true
		implicitWidth: height

		disabledColor: Appearance.pallete.b1bg
		regularColor: root.toggled ? Appearance.pallete.fg : Appearance.pallete.b2bg
		hoveredColor: root.toggled ? Appearance.pallete.b2fg : Appearance.pallete.b4bg
		pressedColor: root.toggled ? Appearance.pallete.b4fg : Appearance.pallete.b6bg

		readonly property color contentColor: {
			if (enabled) {
				if (root.toggled) {
					return Appearance.pallete.b2bg
				}
				return Appearance.pallete.fg
			}
			return Appearance.pallete.d3fg
		}

		StyledIcon {
			id: styledIcon
			anchors.centerIn: parent
			color: innerToggle.contentColor
			text: ""
		}
	}

	ColumnLayout {
		spacing: 0

		StyledText {
			id: textPrimary
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			font.pixelSize: Appearance.font.size.small
			color: root.contentColor
			text: "Primary text"
		}

		StyledText {
			id: textSecondary
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			visible: text && text != ""
			font.pixelSize: Appearance.font.size.smaller
			color: root.contentColor
			text: "Secondary text"
		}
	}

	StyledIcon {
		color: root.contentColor
		font.pixelSize: Appearance.icons.size.smaller
		text: ""
	}
}
