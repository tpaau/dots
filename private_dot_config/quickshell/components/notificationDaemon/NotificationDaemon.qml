import QtQuick
import Quickshell.Services.Notifications

NotificationWrapper {
	id: root

	Component {
		id: notificationSource
		NotificationWidget { }
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

        onNotification: function(notification) {
            root.spawnNotification(notification)
        }
    }

    function spawnNotification(notification: Notification) {
		notification.tracked = true
		notificationSource.createObject(root.container, {
			wrapper: root,
			notification: notification
		})
    }
}
