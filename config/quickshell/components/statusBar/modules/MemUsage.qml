import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.components.statusBar.services

RowLayout {
	spacing: 0

	StyledIcon {
		text: ""
	}
	StyledText {
		text: Memory.usage + "%"
	}
}
