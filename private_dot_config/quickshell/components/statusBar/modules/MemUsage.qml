import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.services
import qs.config

RowLayout {
	spacing: 2

	StyledIcon {
		text: ""
		font.pixelSize: Appearance.icons.size.small
	}

	CircularProgressIndicator {
		implicitHeight: parent.height - 4
		strokeWidth: 5
		implicitWidth: height
		progress: Memory.usage / 100
	}
}
