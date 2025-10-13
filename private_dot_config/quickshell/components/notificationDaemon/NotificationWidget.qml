import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.services

Item {
	id: root

	required property NotificationMeta notif
	required property int spacing

	readonly property real contentFadeMult: 1.5
	readonly property int transitionDur: Appearance.anims.durations.shorter

	property bool open: false
	Component.onCompleted: {
		open = true
	}

	function dismiss() {
		if (x >= 0) x = width + spacing
		else x = -width
	}

	onXChanged: {
		if (!mouseArea.containsPress
		&& (x >= width + spacing || x <= -width)) {
			open = false
		}
	}

	readonly property int desiredHeight:
		notif.expanded ?
		headLayout.height + rootLayout.spacing + bodyLayout.height + spacing
		: headLayout.height + spacing

	onNotifChanged: if (!notif) dismiss()

	implicitWidth: Config.notifications.width
	implicitHeight: open ? desiredHeight + spacing : 0
	onImplicitHeightChanged: if (!open && implicitHeight <= 0) {
		root.destroy()
		notif.data?.dismiss()
	}

	Behavior on implicitHeight {
		NumberAnimation {
			id: heightAnim
			duration: root.transitionDur
			easing.bezierCurve: Appearance.anims.easings.popout
		}
	}

	Behavior on x {
		NumberAnimation {
			id: xRestoreAnim
			duration: root.transitionDur
			easing.type: Appearance.anims.easings.fadeOut
		}
	}

	MouseArea {
		id: mouseArea
		visible: root.open

		anchors {
			fill: parent
			topMargin: root.spacing / 2
			bottomMargin: root.spacing / 2
		}

		property real initialX
		property real prevX
		readonly property real dragDelta: Math.abs(prevX - root.x)
		onDragDeltaChanged: overlayRect.opacity = dragDelta / width * root.contentFadeMult

		Component.onCompleted: {
			prevX = x
			initialX = x
		}

		onClicked: root.notif.expanded = !root.notif.expanded
		function determineColor(): color {
			if (containsPress) {
				return Theme.pallete.bg.c6
			}
			return Theme.pallete.bg.c4
		}

		drag {
			target: xRestoreAnim.running ? null : root
			axis: Drag.XAxis
			smoothed: true

			onActiveChanged: {
				if (drag.active) {
					prevX = root.x
				}
				else {
					if (dragDelta > Config.notificationDragDismissThreshold) {
						root.dismiss()
					}
					else {
						root.x = 0
					}
				}
			}
		}

		Rectangle {
			id: overlayRect
			anchors.fill: wrapper
			color: Theme.pallete.bg.c3
			radius: Appearance.rounding.small
			opacity: 0
			z: 1
		}

		ClippingRectangle {
			id: wrapper
			anchors {
				fill: parent
				leftMargin:
					Math.max(mouseArea.prevX - root.x, 0)
			}
			clip: true
			color: Theme.pallete.bg.c3
			radius: Appearance.rounding.small

			Rectangle {
				color: Theme.pallete.bg.c3
				implicitWidth: root.width
				implicitHeight: rootLayout.height + root.spacing

				ColumnLayout {
					id: rootLayout
					anchors {
						fill: parent
						margins: root.spacing / 2
					}
					spacing: root.spacing / 2

					RowLayout {
						id: headLayout
						spacing: root.spacing / 2
						Layout.alignment: Qt.AlignTop

						Rectangle {
							id: notifIcon
							implicitWidth: 45
							implicitHeight: 45
							radius: Math.min(width, height) / 2
							color: Theme.pallete.bg.c5

							StyledIcon {
								anchors.centerIn: parent
								text: root.notif.data &&
									root.notif.data.urgency
									== NotificationUrgency.Critical ?
									"" : ""
								font.pixelSize: Appearance.icons.size.larger
							}
						}

						Item {
							id: notifTextHeadWrapper
							Layout.fillWidth: true
							implicitHeight: notifIcon.height

							ColumnLayout {
								width: parent.width
								height: parent.height
								Item {
									id: topTextObj
									implicitWidth: parent.width
									Layout.fillHeight: true
									opacity: 0.4
								}
								Item {
									id: bottomTextObj
									implicitWidth: parent.width
									Layout.fillHeight: true
									opacity: 0.4
								}
							}

							StyledText {
								id: summaryText
								width: root.notif.expanded ?
									parent.width
									: parent.width - elapsedTimer.width
								elide: Text.ElideRight
								text: root.notif.data
									&& root.notif.data.summary != "" ?
									root.notif.data.summary
									: Config.notifications.fallbackSummary
								font.weight: Appearance.font.weight.heavy
								y: root.notif.expanded ?
									bottomTextObj.y : topTextObj.y

								Behavior on y {
									NumberAnimation {
										duration: root.transitionDur
										easing.type:
											Appearance.anims.easings.popout
									}
								}

								Behavior on width {
									NumberAnimation {
										duration: root.transitionDur
										easing.type:
											Appearance.anims.easings.popout
									}
								}
							}

							StyledText {
								id: appNameText

								text: root.notif.data
									&& root.notif.data.appName != "" ?
									root.notif.data.appName
									: Config.notifications.fallbackAppName
								opacity: root.notif.expanded ? 1 : 0
								y: topTextObj.y

								Behavior on opacity {
									NumberAnimation {
										duration: root.transitionDur
										easing.type:
											Appearance.anims.easings.fade
									}
								}
							}

							Item {
								id: elapsedTimer
								y: topTextObj.y
								x: root.notif.expanded ?
									appNameText.contentWidth
									: summaryText.contentWidth
								implicitWidth: layout.width + root.spacing / 2

								Behavior on x {
									NumberAnimation {
										duration: root.transitionDur
										easing.type:
											Appearance.anims.easings.popout
									}
								}

								RowLayout {
									id: layout
									anchors {
										fill: parent
										leftMargin: root.spacing / 2
									}
									implicitWidth: elapsedTimerSep.contentWidth
										+ spacing
										+ elapsedTimerText.contentWidth

									StyledIcon {
										id: elapsedTimerSep
										text: "●"
										font.pixelSize:
											Appearance.icons.size.smaller
									}
									StyledText {
										id: elapsedTimerText
										font.pixelSize:
											Appearance.font.size.small
										text: Time.formatTimeElapsed(
											Math.floor((Time.unix
											- root.notif.creationTime) / 60))
									}
								}
							}

							StyledText {
								width: parent.width
								elide: Text.ElideRight
								font.pixelSize: Appearance.font.size.small
								text: root.notif.data
									&& root.notif.data.body != "" ?
									root.notif.data.body
									: Config.notifications.fallbackBody
								opacity: root.notif.expanded ? 0 : 1
								y: bottomTextObj.y

								Behavior on opacity {
									NumberAnimation {
										duration: root.transitionDur
										easing.type:
											Appearance.anims.easings.fade
									}
								}
							}
						}

						Rectangle {
							radius: Appearance.rounding.normal
							implicitWidth: radius * 2
							implicitHeight: radius * 2
							color: mouseArea.determineColor()
							Layout.alignment: Qt.AlignTop

							StyledIcon {
								anchors.centerIn: parent
								text: root.notif.expanded ?  "" : ""
							}
						}
					}

					ColumnLayout {
						id: bodyLayout
						spacing: root.spacing / 2
						opacity: root.notif.expanded ? 1 : 0
						Layout.preferredWidth: parent.width

						Behavior on opacity {
							NumberAnimation {
								duration: root.transitionDur
								easing.type:
									Appearance.anims.easings.fade
							}
						}

						StyledText {
							wrapMode: Text.WordWrap
							Layout.preferredWidth: parent.width
							text: root.notif.data
								&& root.notif.data.body != "" ?
								root.notif.data.body
								: Config.notifications.fallbackBody
						}
					}
				}
			}
		}
	}
}
