pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config

MouseArea {
	id: root

	required property list<DropDownMenuEntry> entries

	property bool closeOnMouseExit: true
	property int hideInterval: 300

	property int largerRadius: Appearance.rounding.normal
	property int smallerRadius: Appearance.rounding.smaller
	property int entryWidth: 220
	property int entryHeight: 60

	property color disabledColor: Theme.pallete.bg.c5
	property color regularColor: Theme.pallete.bg.c4
	property color hoveredColor: Theme.pallete.bg.c6
	property color pressedColor: Theme.pallete.bg.c8

	property real scalingFactor: 0.8
	property int animDur: Appearance.anims.durations.shorter

	signal opened()

	implicitWidth: entryWidth
	implicitHeight: entryHeight * entries.length + 1 + smallerRadius * (entries.length - 1)

	hoverEnabled: true
	enabled: loader.active

	property int pickedIndex: 0
	signal picked(index: int)
	function pick(index: int) {
		pickedIndex = index
		picked(index)
		close()
	}

	function open() {
		if (entries.length < 1) {
			console.warn("Trying to open a context menu with no entries!")
		}
		else if (loader.active) {
			close()
		}
		openOnClosed = true
	}

	function close() {
		loader.close()
	}

	function toggleOpen() {
		if (loader.active) {
			close()
		}
		else {
			open()
		}
	}

	property bool openOnClosed: false
	onOpenOnClosedChanged: if (!loader.active) {
		loader.open()
	}

	Timer {
		id: closeTimer
		interval: root.hideInterval
		running: root.closeOnMouseExit && !root.containsMouse
			&& root.visible && loader.active
		repeat: true
		onTriggered: root.close()
	}

	Loader {
		id: loader
		anchors.fill: parent
		asynchronous: true
		sourceComponent: contextMenu
		active: false

		property bool closing: false
		onActiveChanged: {
			if (root.openOnClosed && !active) {
				open()
				root.openOnClosed = false
				root.opened()
			}
		}

		function open() {
			active = true
			closing = false
			root.openOnClosed = false
			root.opened()
		}

		function close() {
			closing = true
		}

		Timer {
			id: closerTimer
			interval: root.animDur
			running: loader.closing
			onTriggered: loader.active = false
		}
	}

	Component {
		id: contextMenu

		Item {
			id: wrapper

			anchors {
				bottom: parent.bottom
				right: parent.right
			}

			opacity: 0
			width: root.width * root.scalingFactor
			height: root.height * root.scalingFactor
			Component.onCompleted: {
				width = Qt.binding(() =>
					loader.closing ? root.width * root.scalingFactor : root.width)
				height = Qt.binding(() =>
					loader.closing ? root.height * root.scalingFactor : root.height)
				opacity = Qt.binding(() => loader.closing ? 0 : 1)
			}

			Behavior on opacity {
				NumberAnimation {
					duration: root.animDur
				}
			}

			Behavior on width {
				NumberAnimation {
					duration: root.animDur
				}
			}

			Behavior on height {
				NumberAnimation {
					duration: root.animDur
				}
			}

			ColumnLayout {
				anchors.fill: parent
				spacing: 0

				Repeater {
					model: root.entries

					StyledButton {
						id: button

						required property int index
						implicitWidth: wrapper.width
						implicitHeight: root.entryHeight * wrapper.height / root.height

						property bool contactBottom: index < root.entries.length - 1
						property bool contactTop: index != 0

						disabledColor: root.disabledColor
						regularColor: root.regularColor
						hoveredColor: root.hoveredColor
						pressedColor: root.pressedColor

						rect.topLeftRadius: contactTop ?
							root.smallerRadius : root.largerRadius
						rect.topRightRadius: rect.topLeftRadius

						rect.bottomLeftRadius: contactBottom ?
							root.smallerRadius : root.largerRadius
						rect.bottomRightRadius: rect.bottomLeftRadius

						onClicked: {
							root.pick(index)
						}

						RowLayout {
							spacing: root.largerRadius

							anchors {
								fill: parent
								leftMargin: root.largerRadius
								rightMargin: root.largerRadius
							}

							StyledIcon {
								text: root.entries[button.index].icon
							}

							StyledText {
								text: root.entries[button.index].name
								Layout.fillWidth: true
								elide: Text.ElideRight
							}
						}
					}
				}
			}
		}
	}
}
