pragma Singleton

import Quickshell

Singleton {
	readonly property string cacheDir: Quickshell.shellDir + "/cache"
}
