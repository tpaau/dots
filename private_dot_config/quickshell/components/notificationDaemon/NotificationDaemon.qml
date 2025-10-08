import QtQuick
import Quickshell.Services.Notifications

NotificationWrapper {
	id: root

	readonly property string notificationSource: "NotificationWidget.qml"

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

        onNotification: function(notification) {
            root.spawnNotification(notification)
        }
    }

    function spawnNotification(notification: Notification) {
        let comp = Qt.createComponent(root.notificationSource)
        if (comp.status === Component.Error) {
            console.error("Load error: ", comp.errorString())
        }
        else if (comp.status === Component.Ready) {
            addObject(comp, notification)
        }
        else {
            comp.statusChanged.connect(function(newStatus) {
                if (newStatus === Component.Ready) {
                    addObject(comp, notification)
                }
                else if (newStatus === Component.Error) {
                    console.error("Load error: ", comp.errorString())
                }
                else {
                    console.error("Failed loading component: Unknown error")
                }
            })
        }
    }

    function addObject(comp, notification: Notification) {
		notification.tracked = true
		let obj = comp.createObject(root.container, {
			wrapper: root,
			notification: notification
		})
	}
}
