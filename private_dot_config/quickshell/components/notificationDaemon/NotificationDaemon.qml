pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Notifications
import qs.widgets
import qs.widgets.popout.shapes
import qs.config
import qs.utils
import qs.services

PanelWindow {
	id: root
	color: "transparent"

	exclusiveZone: 0
	anchors {
		right: true
		top: true
		bottom: true
	}
	implicitWidth: Config.notifications.width + 3 * spacing
	visible: layout.children.length > 0 || shape.height > 0

	mask: Region {
		item: shape
	}

	readonly property real spacing: Appearance.rounding.popout

	Component {
		id: notifSrc
		NotificationMeta {}
	}

	Component {
		id: notifWidgetSrc
		NotificationWidget {
			spacing: root.spacing
		}
	}

	PersistentProperties {
		id: persist
	}

	NotificationServer {
		id: server

		keepOnReload: false
		imageSupported: true
		actionsSupported: true
		inlineReplySupported: true
		bodyHyperlinksSupported: true
		persistenceSupported: true
        actionIconsSupported: true
        bodyMarkupSupported: true

		property list<NotificationMeta> notifications: []
        onNotification: function(notification) {
			notification.tracked = true
			let notif = notifSrc.createObject(null, {
				data: notification,
				creationTime: Time.unix
			})
			notifications.push(notif)
			notifWidgetSrc.createObject(layout, {
				notif: notif
			})
        }
    }

	Shape {
		id: shape
		clip: true

		anchors {
			left: parent.left
			right: parent.right
			top: parent.top
			topMargin: -1
			rightMargin: -1
		}

		property bool isOpen: false
		height:
			isOpen ? Math.min(layout.height + 2 * root.spacing,
			Config.notifications.maxWrapperHeight) : 0

		antialiasing: true
		layer.enabled: true
		layer.samples: Appearance.misc.layerSampling
		layer.effect: StyledShadow {}

		ScrollView {
			id: scroll
			anchors {
				fill: parent
				topMargin: root.spacing / 2
				leftMargin: 2 * root.spacing
				rightMargin: root.spacing
				bottomMargin: 2 * root.spacing
			}

			implicitWidth: layout.width
			implicitHeight: Utils.clamp(layout.height, 0,
				Config.notifications.maxWrapperHeight)

			contentChildren: [ColumnLayout {
				id: layout
				spacing: 0
				onHeightChanged: shape.isOpen = height > 0
			}]
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
