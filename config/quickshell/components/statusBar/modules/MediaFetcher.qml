import QtQuick
import qs.components.statusBar.services

BarButton {
	id: root

	text.text: MediaFetcherServices.text
	mouseArea.onClicked: {
		StatusBarServices.toggleMediaPlayer()
	}
}
