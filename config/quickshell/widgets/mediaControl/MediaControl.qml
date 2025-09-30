import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.widgets
import qs.widgets.mediaControl
import qs.utils
import qs.services
import qs.config

Rectangle {
	id: root

	radius: Appearance.rounding.normal
	implicitWidth: mainLayout.implicitWidth + 2 * radius
	implicitHeight: mainLayout.implicitHeight + 2 * radius
	clip: true

	color: Appearance.pallete.b2bg

	ColumnLayout {
		id: mainLayout
		spacing: root.radius

		anchors {
			fill: parent
			margins: root.radius
		}

		ClippingRectangle {
			implicitWidth: root.width - 2 * root.radius
			implicitHeight: root.width - 2 * root.radius
			radius: root.radius
			color: Appearance.pallete.b3bg

			StyledIcon {
				anchors.centerIn: parent
				font.pixelSize: Appearance.icons.size.larger
				text: ""
			}

			Image {
				id: coverArt
				visible: source
				anchors.fill: parent
				fillMode: Image.PreserveAspectCrop
				Layout.alignment: Qt.AlignTop
				source: MediaControl.getArtUrl()
			}
		}

		ColumnLayout {
			id: controlLayout
			spacing: mainLayout.spacing
			Layout.alignment: Qt.AlignCenter

			Component {
				id: entry
				DropDownMenuEntry {
					name: "Unknown"
				}
			}

			DropDownMenu {
				id: playerPicker
				z: 2
				Layout.alignment: Qt.AlignCenter
				textIcons: false
				fallbackIcon: ""
				onSelectedChanged: if (Mpris.players.values.length > 0) {
					MediaControl.player = Mpris.players.values[selected.index]
				}

				entries: {
					let players = []
					for (let i = 0; i < Mpris.players.values.length; i++) {
						players.push(entry.createObject(null, {
							index: i,
							name: Mpris.players.values[i].identity,
							icon: Icons.getAppIcon(Mpris.players.values[i].identity)
						}))
					}
					return players
				}

				Connections {
					target: MediaControl
					function onPlayerChanged() {
						let index = Mpris.players.values.indexOf(MediaControl.player)
						if (playerPicker.entries[index]) {
							playerPicker.selected = playerPicker.entries[index]
						}
					}
				}
			}

			ColumnLayout {
				StyledText {
					text: MediaControl.player?.trackTitle || "Unknown"
					font.pixelSize: Appearance.font.size.large
					font.weight: Appearance.font.weight.heavy
					Layout.preferredWidth: mainLayout.width
					elide: Text.ElideRight
					Component.onCompleted: {
						Layout.preferredHeight = height
					}
				}
				StyledText {
					text: MediaControl.player?.trackArtist || "Unknown"
					font.weight: Appearance.font.weight.light
					font.pixelSize: Appearance.font.size.small
					Layout.preferredWidth: mainLayout.width
					elide: Text.ElideRight
					Component.onCompleted: {
						Layout.preferredHeight = height
					}
				}
			}

			StyledSlider {
				id: seekSlider
				Layout.preferredWidth: mainLayout.width
				Layout.preferredHeight: 13
				property real delta: 0

				Binding {
					id: playerBinding
					target: seekSlider
					property: "value"
					when: !seekSlider.pressed
					value: MediaControl.player ? MediaControl.player.position / MediaControl.player.length : 0
				}

				onPressedChanged: {
					if (!pressed) {
						if (MediaControl.player
							&& MediaControl.player.canSeek
							&& MediaControl.player.positionSupported
							&& MediaControl.player.lengthSupported) {
							MediaControl.player.position = value * MediaControl.player.length
						}
					}
				}
			}

			RowLayout {
				Layout.preferredWidth: parent.width

				StyledText {
					text: MediaControl.player ?
						Utils.formatHMS(MediaControl.player.position) : "--:--"
					font.pixelSize: Appearance.font.size.smaller
					Layout.alignment: Qt.AlignLeft
				}
				StyledText {
					text: MediaControl.player ?
						Utils.formatHMS(MediaControl.player.length) : "--:--"
					font.pixelSize: Appearance.font.size.smaller
					Layout.alignment: Qt.AlignRight
				}
			}

			RowLayout {
				id: buttonLayout
				spacing: root.radius
				Layout.alignment: Qt.AlignCenter

				readonly property int buttonSize: 40
				StyledButton {
					id: loopButton
					Layout.preferredWidth: 35
					Layout.preferredHeight: 35
					disabledColor: Appearance.pallete.b2bg
					regularColor: Appearance.pallete.b2bg
					hoveredColor: Appearance.pallete.b3bg
					pressedColor: Appearance.pallete.b4bg
					enabled: MediaControl.player && MediaControl.player.loopSupported

					onClicked: {
						let player = MediaControl.player
						if (player.loopState == MprisLoopState.None) {
							player.loopState = MprisLoopState.Track
						}
						else if (player.loopState == MprisLoopState.Track) {
							player.loopState = MprisLoopState.Playlist
						}
						else {
							player.loopState = MprisLoopState.None
						}
					}

					StyledIcon {
						color: loopButton.enabled ?
							(MediaControl.player.loopState != MprisLoopState.None ? 
								Appearance.pallete.b2fg
									: Appearance.pallete.d2fg) : Appearance.pallete.d2fg
						font.weight: MediaControl.player
							? MediaControl.player.loopState != MprisLoopState.None
							? Appearance.font.weight.heavy
							: Appearance.font.weight.light
							: Appearance.font.weight.light
						anchors.centerIn: parent
						text: MediaControl.player
							&& MediaControl.player.loopState != MprisLoopState.Track ?
							"" : ""
					}
				}
				StyledButton {
					id: previousButton
					Layout.preferredWidth: 40
					Layout.preferredHeight: 40
					enabled: MediaControl.player && MediaControl.player.canGoPrevious

					onClicked: {
						if (MediaControl.player && MediaControl.player.canGoPrevious) {
							MediaControl.player.previous()
						}
					}

					StyledIcon {
						color: previousButton.enabled ?
							Appearance.pallete.fg : Appearance.pallete.d2fg
						anchors.centerIn: parent
						text: ""
					}
				}
				StyledButton {
					id: playPauseButton
					Layout.preferredWidth: 50
					Layout.preferredHeight: 50
					enabled: MediaControl.player
						&& (MediaControl.player.canPlay || MediaControl.player.canPause)
					rect.radius:
						MediaControl.player &&
						MediaControl.player.playbackState == MprisPlaybackState.Playing ?
						Math.min(width, height) : Math.min(width, height) / 3
					regularColor: Appearance.pallete.b1fg
					hoveredColor: Appearance.pallete.d1fg
					pressedColor: Appearance.pallete.d3fg

					onClicked: {
						if (MediaControl.player && MediaControl.player.canPause) {
							MediaControl.player.togglePlaying()
						}
					}

					StyledIcon {
						anchors.centerIn: parent
						font.pixelSize: Appearance.icons.size.large
						color: playPauseButton.enabled ?
							Appearance.pallete.b2bg : Appearance.pallete.d2fg
						text: 
							switch (MediaControl.player?.playbackState) {
								case MprisPlaybackState.Playing:
									return ""
								case MprisPlaybackState.Paused:
									return ""
								default:
									return ""
							}
					}
				}
				StyledButton {
					id: nextButton
					Layout.preferredWidth: 40
					Layout.preferredHeight: 40
					enabled: MediaControl.player && MediaControl.player.canGoNext
					onClicked: MediaControl.player.next()

					StyledIcon {
						color: nextButton.enabled ?
							Appearance.pallete.fg : Appearance.pallete.d2fg
						anchors.centerIn: parent
						text: ""
					}
				}
				StyledButton {
					id: shuffleButton
					Layout.preferredWidth: 35
					Layout.preferredHeight: 35
					disabledColor: Appearance.pallete.b2bg
					regularColor: Appearance.pallete.b2bg
					hoveredColor: Appearance.pallete.b3bg
					pressedColor: Appearance.pallete.b4bg
					enabled: MediaControl.player && MediaControl.player.shuffleSupported

					onClicked: {
						MediaControl.player.shuffle = !MediaControl.player.shuffle
					}

					StyledIcon {
						color: shuffleButton ?
							(MediaControl.player?.shuffle ? Appearance.pallete.b2fg : Appearance.pallete.fg) : Appearance.pallete.d2fg
						font.weight: MediaControl.player
							? MediaControl.player.shuffle
							? Appearance.font.weight.regular :
							Appearance.font.weight.light : Appearance.font.weight.light
						anchors.centerIn: parent
						text: ""
					}
				}
			}
		}
	}
}
