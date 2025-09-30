pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.widgets
import qs.widgets.mediaControl
import qs.animations
import qs.widgets.popout
import qs.widgets.popout.shapes
import qs.config

PanelWindow {
	id: root
	anchors.top: true
	exclusionMode: ExclusionMode.Ignore
	color: "transparent"

	property int radius: Appearance.rounding.popout

	property bool opened: false
	function open() {
		opened = true
	}

	function close() {
		opened = false
	}

	readonly property real openedHeight: container.height
		+ Appearance.misc.statusBarHeight
		+ Appearance.shadows.blur
		+ 2 * container.spacing

	implicitWidth: container.implicitWidth + 4 * radius
	implicitHeight: shape.height > 0 ? openedHeight : 0
	visible: shape.height > 0

	StyledPopoutShape {
		id: shape

		anchors {
			left: parent.left
			right: parent.right
			top: parent.top
			topMargin: Appearance.misc.statusBarHeight
		}

		height: root.opened ?
			container.height + 2 * container.spacing : 0
		onHeightChanged: if (height <= 0) root.close()

		Behavior on height {
			PopoutAnimation {}
		}

		layer.enabled: true
		layer.samples: Appearance.misc.layerSampling
		layer.effect: StyledShadow {
			autoPaddingEnabled: false
			paddingRect: Qt.rect(
				0,
				0,
				parent.width,
				parent.height)
		}

		TopPopoutShape {
			width: shape.width
			height: shape.height 
			radius: Appearance.rounding.popout
		}

		RowLayout {
			id: container
			spacing: root.radius

			anchors {
				left: parent.left
				right: parent.right
				bottom: parent.bottom
				leftMargin: 2 * root.radius
				rightMargin: 2 * root.radius
				bottomMargin: root.radius
			}

			MediaControl {}

			GridLayout {
				columns: 2
				rows: 1
				rowSpacing: root.radius
				columnSpacing: rowSpacing
				Layout.alignment: Qt.AlignTop

				QSBluetoothButton {}
				CaffeineButton {}
			}
		}
	}

	HoverHandler {
		onHoveredChanged: if (!hovered) {
			root.opened = false
		}
	}
}
