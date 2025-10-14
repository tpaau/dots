pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.components.statusBar.modules
import qs.components.quickSettings

PanelWindow {
	id: root

	required property QuickSettings quickSettings
	property real spacing: Appearance.spacing.large

	color: Theme.pallete.bg.c1

	anchors {
		top: true
		left: true
		right: true
	}

	implicitHeight: Appearance.misc.statusBarHeight

	MouseArea {
		anchors {
			top: parent.top
			left: parent.left
			right: parent.right
			leftMargin: (root.width - root.quickSettings.implicitWidth) / 2
			rightMargin: (root.width - root.quickSettings.implicitWidth) / 2
		}
		implicitHeight: 1

		hoverEnabled: true
		onEntered: root.quickSettings.open()
	}

	RowLayout {
		id: barModules
		anchors.fill: parent
		uniformCellSizes: true

		ModuleGroup {
			id: modulesLeft

			Layout.alignment: Qt.AlignLeft

			Clock {}
			Tray {
				itemSize: 18
			}
		}

		ModuleGroup {
			id: modulesCenter

			Layout.alignment: Qt.AlignCenter

			NiriWorkspaces {}
		}

		ModuleGroup {
			id: modulesRight
			Layout.alignment: Qt.AlignRight

			BluetoothIndicator {}
			CaffeineIndicator {}
			CpuUsage {}
			CpuTemp {}
			MemUsage {}
			// Privacy {}
			Power {
				implicitHeight: root.height * 0.75
			}
		}
	}

	component ModuleGroup: RowLayout {
		id: group

		spacing: root.spacing
		Layout.leftMargin: root.spacing
		Layout.rightMargin: root.spacing

		property int alignment: Layout.alignment
	}
}
