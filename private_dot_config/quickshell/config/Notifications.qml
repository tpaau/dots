pragma Singleton

import Quickshell
import QtQuick
import qs.config

Singleton {
	id: root

	readonly property int maxVisible: 5
	readonly property int width: 400
	readonly property int heightContracted: Appearance.rounding.popout * 2
	readonly property string defaultAppName: "Unknown App"
	readonly property string defaultSummary: "Notification"
	readonly property string defaultBody: "*No information provided.*"
}
