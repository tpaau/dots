import QtQuick

QtObject {
	required property int workspaceId
	required property int idx
	required property string name
	required property string output
	required property bool isUrgent
	required property bool isActive
	required property bool isFocused
	required property int activeWindowID
	property bool containsWindow
}
