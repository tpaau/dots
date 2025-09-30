import QtQuick
import qs.config
import qs.widgets

StyledButton {
	property alias text: text

	text.text: "bar button"
	mouseArea.cursorShape: Qt.PointingHandCursor
	marginVertical: 2
	regularColor: Appearance.pallete.bg
	hoverColor: Appearance.pallete.b2bg
	activeColor: Appearance.pallete.b3bg
	
	implicitWidth: text.width + marginHorizontal * 2
	implicitHeight: text.height + marginVertical * 2
	
	StyledText {
		id: text
		anchors.centerIn: parent
	}
}
