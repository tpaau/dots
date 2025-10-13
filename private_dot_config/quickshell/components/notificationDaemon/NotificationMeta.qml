import QtQuick
import Quickshell.Services.Notifications

QtObject {
	required property Notification data
	required property int creationTime
	property bool expanded: false
}
