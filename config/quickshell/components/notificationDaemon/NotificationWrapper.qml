import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Effects
import Quickshell
import qs.config
import qs.widgets
import qs.widgets.popout.shapes

PanelWindow {
	id: root

	default property alias content: container.data
	readonly property ColumnLayout container: container

	readonly property real spacing: Appearance.rounding.popout
	readonly property color backgroundColor: Appearance.pallete.bg

	color: "transparent"

	exclusiveZone: 0
	anchors {
		right: true
		top: true
	}

	implicitWidth: Notifications.width + 3 * root.spacing
	visible: implicitHeight != 0 && shape.height > 0

	function calculateHeight(ignoreResize = false) {
		if (resizingNotifications.length != 0 && ignoreResize) {
			return
		}

		if (shape.height == 0) {
			implicitHeight = 0
			return
		}

		let h = 0
		for (let i = 0; i < container.data.length; i++) {
			if (container.data[i].height) {
				h += container.data[i].desiredHeight
			}
		}

		h = h || 0
		implicitHeight = Math.max(h + (container.data.length + 1) * spacing, shape.height)
	}

	property list<int> resizingNotifications

	function startNotificationResize(id: int) {
		if (!resizingNotifications.includes(id)) {
			resizingNotifications.push(id)
		}
	}

	function stopNotificationResize(id: int) {
		if (resizingNotifications.includes(id)) {
			let index = resizingNotifications.indexOf(id)
			resizingNotifications.splice(index, 1)
		}
		else {
			console.warn("Animation already stopped!")
		}
	}

	function notificationClosed(notification: NotificationWidget) {
		if (notification && notification.notification) {
			let id = notification.notification.id
			if (resizingNotifications.includes(id)) {
				stopNotificationResize(id)
			}
		}
	}

	Shape {
		id: shape

		anchors {
			top: parent.top
			left: parent.left
			right: parent.right
			topMargin: -1
			rightMargin: -1
		}

		property real desiredHeight: container.children.length == 0
			? 0 : container.implicitHeight + 3 * root.spacing
		height: desiredHeight

		Behavior on height {
			NumberAnimation {
				easing.type: Easing.Linear
				duration: root.resizingNotifications.length == 0 ? 200 : 0
			}
		}

		onHeightChanged: if (height == desiredHeight) {
			root.calculateHeight(true)
		}

		antialiasing: true
		layer.enabled: true
		layer.samples: Appearance.misc.layerSampling
		layer.effect: StyledShadow {}

		ColumnLayout {
			id: container
			clip: true
			spacing: root.spacing

			anchors {
				right: parent.right
				top: parent.top
				rightMargin: root.spacing
				topMargin: root.spacing
			}
		}

		BasePopoutShape {
			PathArc {
				x: root.spacing
				y: Math.min(root.spacing, shape.height / 3)
				radiusX: root.spacing
				radiusY: Math.min(root.spacing, shape.height / 3)
			}
			PathLine {
				x: root.spacing
				y: Math.max(shape.height - 2 * root.spacing, shape.height / 3)
			}
			PathArc {
				x: 2 * root.spacing
				y: Math.max(shape.height - root.spacing, 2 * shape.height / 3)
				radiusX: root.spacing
				radiusY: Math.min(root.spacing, shape.height / 3)
				direction: PathArc.Counterclockwise
			}
			PathLine {
				x: shape.width - root.spacing
				y: Math.max(shape.height - root.spacing, 2 * shape.height / 3)
			}
			PathArc {
				x: shape.width
				y: shape.height
				radiusX: root.spacing
				radiusY: Math.min(root.spacing, shape.height / 3)
			}
			PathLine {
				x: shape.width
			}
		}
	}
}
