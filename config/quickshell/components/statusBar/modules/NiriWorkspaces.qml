pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

RowLayout {
	id: root

	property int widthActive: 48
	property int heightActive: 10
	property int widthInactive: 10
	property int heightInactive: 10

	Repeater {
		model: Niri.workspaces.length

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

		color: workspace.isFocused ? Theme.pallete.fg.c6 : Theme.pallete.bg.c8

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
