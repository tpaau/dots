import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config

QSButton {
	id: root

	enabled: true
	property bool toggled: true

	property alias icon: styledIcon.text
	property alias primaryText: textPrimary.text
	property alias secondaryText: textSecondary.text

	disabledColor: Appearance.pallete.b1bg
	regularColor: toggled ? Appearance.pallete.fg : Appearance.pallete.b3bg
	hoveredColor: toggled ? Appearance.pallete.b2fg : Appearance.pallete.b5bg
	pressedColor: toggled ? Appearance.pallete.b4fg : Appearance.pallete.b7bg

	readonly property color contentColor: {
		if (enabled) {
			if (toggled) {
				return Appearance.pallete.b2bg
			}
			return Appearance.pallete.fg
		}
		return Appearance.pallete.d3fg
	}

	StyledIcon {
		id: styledIcon
		color: root.contentColor
		text: ""
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
			visible: text && text != ""
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			font.pixelSize: Appearance.font.size.smaller
			color: root.contentColor
			text: "Secondary text"
		}
	}
}
