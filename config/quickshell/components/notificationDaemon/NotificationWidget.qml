pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.widgets
import qs.config
import qs.utils
import qs.services

Rectangle {
	id: root

	readonly property int textSize: Appearance.font.size.small

	readonly property int expandContractEasing: Appearance.anims.easings.popout
	readonly property int expandContractDur: Appearance.anims.durations.notificationExpand
	readonly property int xRestoreEasing: Appearance.anims.easings.popout
	readonly property int xRestoreDur: Appearance.anims.durations.longish
	readonly property int spawnDur: Appearance.anims.durations.normal

	readonly property int colorShiftDur: Appearance.anims.durations.shorter
	readonly property int colorShiftEasing: Appearance.anims.easings.fade

	readonly property int dragDismissThreshold: 200

	readonly property color regularColor: Appearance.pallete.b3bg
	readonly property color activeColor: Appearance.pallete.b5bg

	required property NotificationWrapper wrapper
	required property Notification notification

	onNotificationChanged: if (!notification) dismiss()

	property real desiredHeight:
		expanded ? mainLayout.height + radius : titleLayout.height + radius
	onDesiredHeightChanged: {
		wrapper.calculateHeight()
	}

	property bool expanded: false
	onExpandedChanged: {
		wrapper.startNotificationResize(notification.id)
		stopResizeTimer.start()
	}

	implicitWidth: 0

	implicitHeight: desiredHeight
	clip: true

	radius: Appearance.rounding.popout
	color: Appearance.pallete.b2bg

	property int timeSinceCreated
	Component.onCompleted: {
		timeSinceCreated = Time.unix
		implicitWidth = Notifications.width
	}

	property string formatedTime:
		Time.formatTimeElapsed(Math.floor((Time.unix - timeSinceCreated) / 60))

	Timer {
		id: stopResizeTimer
		interval: root.expandContractDur
		onTriggered: root.wrapper.stopNotificationResize(root.notification.id)
	}

	function dismiss() {
		destroy()
		wrapper.notificationClosed(this)
		notification?.dismiss()
	}

	Layout.alignment: Qt.AlignRight
	Behavior on implicitHeight {
		NumberAnimation {
			duration: root.expandContractDur
			easing.type: root.expandContractEasing
		}
	}

	Behavior on implicitWidth {
		NumberAnimation {
			duration: root.spawnDur
			easing.type: root.expandContractEasing
		}
	}

	Behavior on x {
		NumberAnimation {
			id: xRestoreAnimation
			duration: root.xRestoreDur
			easing.type: root.xRestoreEasing
		}
	}

	MouseArea {
		anchors.fill: parent

		property real initialX
		property real prevX
		Component.onCompleted: {
			prevX = root.x
			initialX = root.x
		}

		hoverEnabled: true
		onClicked: root.expanded = !root.expanded
		function determineColor(): color {
			if (containsPress) {
				return root.activeColor
			}
			return root.regularColor
		}

		Rectangle {
			id: expandButton

			implicitWidth: root.radius
			implicitHeight: root.radius
			radius: Math.min(width, height)
			color: parent.determineColor()

			anchors {
				top: parent.top
				right: parent.right
				topMargin: root.radius / 2
				rightMargin: root.radius / 2
			}

			Behavior on color {
				ColorAnimation {
					duration: Appearance.anims.durations.button
					easing.type: Appearance.anims.easings.button
				}
			}

			StyledIcon {
				anchors.centerIn: parent
				font.pixelSize: Appearance.icons.size.small
				text: root.expanded ? "" : ""
			}
		}

		drag {
			target: xRestoreAnimation.running ? null : root
			axis: Drag.XAxis
			smoothed: true

			onActiveChanged: {
				if (drag.active) {
					prevX = root.x
				}
				else {
					if (Math.abs(prevX - root.x) > root.dragDismissThreshold) {
						root.dismiss()
					}
					else {
						root.x = 0
					}
				}
			}
		}
	}

	ColumnLayout {
		id: mainLayout

		anchors {
			top: parent.top
			left: parent.left
			right: parent.right
			margins: root.radius / 2
		}

		spacing: root.radius / 2

		RowLayout {
			id: titleLayout

			spacing: root.radius / 2

			Rectangle {
				id: notificationIconBG

				color: Appearance.pallete.b4bg
				implicitWidth: root.radius * 2
				implicitHeight: root.radius * 2
				radius: Math.min(width, height)

				StyledIcon {
					anchors.centerIn: parent
					font.pixelSize: Appearance.icons.size.large
					text: root.notification
						&& root.notification.urgency == NotificationUrgency.Critical ?
						"" : ""
				}
			}

			Rectangle {
				id: headerContainer

				implicitHeight: root.expanded ?
					headerContainer.height : notificationIconBG.height - root.radius / 2
				implicitWidth: root.width - notificationIconBG.width - 2 * root.radius - expandButton.width
				color: root.color

				Behavior on implicitHeight {
					NumberAnimation {
						duration: root.colorShiftDur
						easing.type: root.colorShiftEasing
					}
				}

				StyledText {
					id: shortSummary

					anchors.left: parent.left
					y: root.expanded ? headerContainer.height / 2 : 0
					font.weight: Appearance.font.weight.heavy

					Behavior on y {
						NumberAnimation {
							duration: root.expandContractDur
							easing.type: root.expandContractEasing
						}
					}

					text: root.notification && root.notification.summary != "" ?
						root.notification.summary
						: Notifications.defaultSummary

					Layout.preferredWidth: Math.min(headerContainer.width - (timeLayout.width + root.radius / 2), contentWidth)
					elide: Text.ElideRight
				}

				StyledText {
					id: appName

					anchors {
						left: parent.left
						top: parent.top
					}

					color: root.expanded ? Appearance.pallete.fg : "transparent"

					Behavior on color {
						ColorAnimation {
							duration: root.colorShiftDur
							easing.type: root.colorShiftEasing
						}
					}

					text: root.notification && root.notification.appName != "" ?
						root.notification.appName
						: Notifications.defaultAppName

					Layout.preferredWidth: Math.min(headerContainer.width - (timeLayout.width + root.radius / 2), contentWidth)
					elide: Text.ElideRight
				}

				RowLayout {
					id: timeLayout

					anchors.top: parent.top
					x: {
						if (root.expanded) {
							return appName.width + root.radius / 2
						}
						else {
							return shortSummary.width + root.radius / 2
						}
					}

					Behavior on x {
						NumberAnimation {
							duration: root.expandContractDur
							easing.type: root.expandContractEasing
						}
					}

					StyledText {
						id: separator

						text: "●"
						font.pixelSize: Appearance.font.size.small
						Layout.bottomMargin: 2
					}

					StyledText {
						id: notificationTime

						text: root.formatedTime
					}
				}

				StyledText {
					id: bodySummary

					visible: color != "transparent"
					font.pixelSize: Appearance.font.size.small
					color: root.expanded ? "transparent" : Appearance.pallete.fg

					anchors {
						bottom: parent.bottom
						left: parent.left
					}
					
					Behavior on color {
						ColorAnimation {
							duration: root.colorShiftDur
							easing.type: root.colorShiftEasing
						}
					}

					width: headerContainer.width
					elide: Text.ElideRight
					textFormat: Text.MarkdownText
					text: {
						const maxLength = 32
						let originalText = root.notification
							&& root.notification.body != "" ?
							root.notification.body
							: Notifications.defaultBody

						let text = originalText.substring(0, maxLength)
						if (originalText.length > maxLength) {
							text += "…"
						}

						return text
					}
				}
			}
		}

		ColumnLayout {
			id: bodyLayout

			spacing: root.radius / 2

			StyledText {
				id: fullSummary

				font.pixelSize: root.textSize

				color: root.expanded ? Appearance.pallete.fg : "transparent"

				Behavior on color {
					ColorAnimation {
						duration: root.colorShiftDur
						easing.type: root.colorShiftEasing
					}
				}

				Layout.preferredWidth: mainLayout.width
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
				textFormat: Text.MarkdownText
				text: root.notification && root.notification.body != "" ?
					root.notification.body
					: Notifications.defaultBody
            }

            RowLayout {
                spacing: root.radius / 2

				Layout.alignment: Layout.Center

				Repeater {
					model: root.notification?.actions

					StyledButton {
						required property int index
						readonly property var action: root.notification?.actions[index]

						implicitHeight: root.radius
						implicitWidth: buttonText.contentWidth + root.radius
						rect.radius: Math.min(width, height)

						onClicked: {
							root.destroy()
							action.invoke()
						}

						StyledText {
							id: buttonText
							anchors.centerIn: parent

							font.pixelSize: root.textSize
							Component.onCompleted: text = parent.action.text
						}
					}
				}
			}
		}
	}
}
