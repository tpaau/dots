//@ pragma Env QS_NO_RELOAD_POPUP=1

import QtQuick
import Quickshell
import qs.components.statusBar
import qs.components.volumeOsd
import qs.components.backlightOsd
import qs.components.screenOverlay
import qs.components.notificationDaemon
import qs.components.quickSettings
import qs.components.sessionManagement

ShellRoot {
	id: root

	readonly property QuickSettings settings: QuickSettings {}

	StatusBar {
		quickSettings: root.settings
	}
	ScreenOverlay {}
	VolumeOsd {}
	BacklightOsd {}
	// Launcher {}
    NotificationDaemon {}
	SessionManagement {}
}
