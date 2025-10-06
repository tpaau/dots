pragma Singleton

import QtQuick
import Quickshell

Singleton {

	readonly property Wallpaper wallpaper: Wallpaper {}

	component Wallpaper: QtObject {
		property string source: Qt.resolvedUrl("../assets/overlord-wallpaper2.png")
	}
}
