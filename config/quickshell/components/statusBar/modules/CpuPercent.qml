import QtQuick
import qs.components.statusBar.services

BarButton {
	text.text: Cpu.usage
	mouseArea.onClicked: StatusBarServices.openBtop()
}
