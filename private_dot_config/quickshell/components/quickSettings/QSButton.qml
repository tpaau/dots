import QtQuick.Layouts
import qs.widgets

StyledButton {
	id: root
	implicitWidth: 250
	implicitHeight: 80
	radius: Math.min(width, height) / 3
	clip: true

	default property alias data: layout.data

	RowLayout {
		id: layout
		spacing: root.radius / 2

		anchors {
			fill: parent
			margins: root.radius / 2
		}
	}
}
