pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

RowLayout {
	id: root

	readonly property int widthActive: 48
	readonly property int heightActive: 10
	readonly property int widthInactive: 10
	readonly property int heightInactive: 10

	readonly property color colorFocused: Theme.pallete.fg.c6
	readonly property color colorUnfocused: Theme.pallete.bg.c8
	readonly property color colorInactive: Theme.pallete.bg.c4

	Repeater {
		model: Math.max(0, Niri.workspaces.length - 1)

		Workspace {
			Layout.alignment: Qt.AlignCenter
		}
	}

	component Workspace: Rectangle {
		required property int index
		readonly property NiriWorkspace workspace: Niri.workspaces[index]

		radius: Math.min(width, height) / 2

		implicitWidth: workspace.isFocused ? root.widthActive : root.widthInactive
		implicitHeight: workspace.isFocused ? root.heightActive : root.heightInactive

		color: workspace.isFocused ? root.colorFocused : root.colorUnfocused

		Behavior on implicitWidth {
			NumberAnimation {
				duration: Appearance.anims.durations.workspace
				easing.type: Appearance.anims.easings.workspace
			}
		}

		Behavior on color {
			ColorAnimation {
				duration: Appearance.anims.durations.workspace
				easing.type: Appearance.anims.easings.workspace
			}
		}
	}
}
