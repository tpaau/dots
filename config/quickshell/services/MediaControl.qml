pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
	id: root

	property alias player: persist.player

	PersistentProperties {
		id: persist
		property MprisPlayer player: null
	}

	Timer {
		running: !root.player
		interval: 1000
		repeat: true
		onTriggered: {
			if (Mpris.players.values.length > 0) {
				root.player = Mpris.players.values[0]
			}
		}
	}

	FrameAnimation {
		running: root.player?.playbackState == MprisPlaybackState.Playing
		onTriggered: root.player?.positionChanged()
	}

	function getArtUrl(): string {
		if (root.player) {
			return root.player.trackArtUrl
		}
		return ""
	}

	IpcHandler {
		target: "mediaControl"

		function isAttached(): bool {
			return root.player
		}
		function getPlaybackState(): string {
			if (root.player) {
				switch (root.player.playbackState) {
					case MprisPlaybackState.Playing:
						return "playing"
					case MprisPlaybackState.Paused:
						return "paused"
					default:
						return "stopped"
				}
			}
			return "player not attached"
		}
		function togglePlaying(): string {
			if (root.player) {
				if (root.player.canTogglePlaying) {
					root.player.togglePlaying()
					return "OK"
				}
				else {
					return "feature not supported"
				}
			}
			else {
				return "player not attached"
			}
		}
		function play(): string {
			if (root.player) {
				if (root.player.canPlay) {
					root.player.play()
					return "OK"
				}
				else {
					return "feature not supported"
				}
			}
			else {
				return "player not attached"
			}
		}
		function pause(): string {
			if (root.player) {
				if (root.player.canPause) {
					root.player.pause()
					return "OK"
				}
				else {
					return "feature not supported"
				}
			}
			else {
				return "player not attached"
			}
		}
		function previous(): string {
			if (root.player) {
				if (root.player.canGoPrevious) {
					root.player.previous()
					return "OK"
				}
				else {
					return "feature not supported"
				}
			}
			else {
				return "player not attached"
			}
		}
		function next(): string {
			if (root.player) {
				if (root.player.canGoNext) {
					root.player.next()
					return "OK"
				}
				else {
					return "feature not supported"
				}
			}
			else {
				return "player not attached"
			}
		}
	}
}
