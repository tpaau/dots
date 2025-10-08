pragma Singleton

import QtQuick
import Quickshell

Singleton {
	id: root

	readonly property Wallpaper wallpaper: Wallpaper {}

	component Wallpaper: QtObject {
		property string source: Qt.resolvedUrl("../assets/wallpapers/overlord-wallpaper2.png")
	}
}
