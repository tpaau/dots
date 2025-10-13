pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	readonly property string scriptsDir: Qt.resolvedUrl("../scripts/")
	readonly property string configFile: Qt.resolvedUrl("../config.json")

	property int notificationDragDismissThreshold: 100

	property Wallpaper wallpaper: Wallpaper {}

	property Notifications notifications: Notifications {}

	component Wallpaper: QtObject {
		readonly property string source: Qt.resolvedUrl("../assets/wallpapers/overlord-wallpaper2.png")
	}

	component Notifications: QtObject {
		readonly property int maxVisible: 5
		readonly property int width: 400
		readonly property string fallbackAppName: "Unknown App"
		readonly property string fallbackSummary: "Notification"
		readonly property string fallbackBody: "No information provided."
	}

	Component.onCompleted: {
		fileView.adapter.myStringProperty = "Hello!"
	}

	FileView {
		id: fileView
		path: root.configFile
		watchChanges: true
		onFileChanged: reload()
		onAdapterUpdated: writeAdapter()

		JsonAdapter {
			property string myStringProperty: "default value"
			property list<string> stringList: [ "default", "value" ]
			property JsonObject subObject: JsonObject {
				property string subObjectProperty: "default value"
			}
			property var inlineJson: { "a": "b" }
		}
	}
}
