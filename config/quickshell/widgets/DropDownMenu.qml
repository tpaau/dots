pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.config

StyledButton {
	id: root

	implicitWidth: 150
	implicitHeight: 30

	property bool expanded: false
	onClicked: expanded = !expanded

	property string fallbackIcon
	property bool textIcons: true
	property bool duplicateEntries: false

	property int largerRadius: Appearance.rounding.small
	property int smallerRadius: Appearance.rounding.smaller / 2
	property int animDur: Appearance.anims.durations.shortish

	property DropDownMenuEntry selected: {
		if (root.entries.length > 0) {
			root.entries[0]
		}
		else {
			defaultEntry.createObject()
		}
	}
	required property list<DropDownMenuEntry> entries

	rect.bottomLeftRadius: expanded ? smallerRadius : largerRadius 
	rect.bottomRightRadius: expanded ? smallerRadius : largerRadius 

	enabled: entries.length > 1

	Behavior on rect.bottomLeftRadius {
		NumberAnimation {
			duration: root.animDur
		}
	}

	Behavior on rect.bottomRightRadius {
		NumberAnimation {
			duration: root.animDur
		}
	}

	Component {
		id: defaultEntry
		DropDownMenuEntry {
			name: "No entries"
		}
	}

	RowLayout {
		id: mainLayout
		spacing: root.smallerRadius * 2
		anchors.fill: parent

		anchors {
			fill: parent
			rightMargin: root.largerRadius / 2
			leftMargin: root.largerRadius / 2
		}

		IconImage {
			id: entryIconImg
			source: !root.textIcons ? root.selected.icon : ""
			visible: !root.textIcons && source && source != ""
			implicitSize: visible ? 20 : 0
			mipmap: true
			asynchronous: true
		}

		StyledIcon {
			id: entryIconTxt
			font.pixelSize: Appearance.icons.size.small
			text: !root.selected.icon || root.selected.icon == "" ?
				root.fallbackIcon : ""
			visible: (root.textIcons || (root.fallbackIcon && root.fallbackIcon != ""))
				&& text && text != ""
		}

		StyledText {
			id: entryText
			font.pixelSize: Appearance.font.size.small
			text: root.selected.name
			Layout.preferredWidth: parent.width
				- entryIconImg.width
				- entryIconTxt.width
				- arrowIcon.width
				- 2 * mainLayout.spacing
			elide: Text.ElideRight
			verticalAlignment: Qt.AlignLeft
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
		}

		StyledIcon {
			id: arrowIcon
			visible: root.enabled
			font.pixelSize: Appearance.icons.size.small
			text: root.expanded ?  "" : ""
			Layout.alignment: Qt.AlignRight
		}
	}

	MouseArea {
		id: dropDownWrapperWrapper
		implicitWidth: root.implicitWidth
		implicitHeight: layout.implicitHeight + root.height + layout.spacing
		hoverEnabled: true
		onHoveredChanged: if (!containsMouse) {
			root.expanded = false
		}

		propagateComposedEvents: true
		onClicked: (mouse) => {
			mouse.accepted = false
		}

		Item {
			id: dropDownWrapper
			implicitWidth: root.implicitWidth
			implicitHeight: root.expanded ?
				layout.implicitHeight + root.height + layout.spacing : 0
			clip: true

			Behavior on implicitHeight {
				NumberAnimation {
					duration: root.animDur
				}
			}

			ColumnLayout {
				id: layout
				spacing: root.smallerRadius
				y: root.height + spacing

				Repeater {
					id: repeater
					model: root.entries

					StyledButton {
						id: button

						required property int index
						readonly property DropDownMenuEntry model: root.entries[index] ? 
						root.entries[index] : null
						visible: model != root.selected || root.duplicateEntries

						property bool contactBottom: {
							if (index < root.entries.length - 2) {
								return true
							}
							else if (index != root.entries.length - 1) {
								if (root.entries[index + 1] == root.selected) {
									return false
								}
								return true
							}
							else {
								return false
							}
						}

						rect.topLeftRadius: root.smallerRadius
						rect.topRightRadius: root.smallerRadius
						rect.bottomLeftRadius: contactBottom ?
							root.smallerRadius : root.largerRadius
						rect.bottomRightRadius: contactBottom ?
							root.smallerRadius : root.largerRadius

						onClicked: {
							root.expanded = false
							root.selected = model
						}

						RowLayout {
							id: entryLayout
							spacing: root.smallerRadius * 2
							anchors.fill: parent

							anchors {
								fill: parent
								rightMargin: root.largerRadius / 2
								leftMargin: root.largerRadius / 2
							}

							IconImage {
								id: entryIcon2Img
								source: !root.textIcons ?
									button.model ? button.model.icon : "" : ""
								visible: source && source != ""
								implicitSize: visible ? 20 : 0
								mipmap: true
								asynchronous: true
							}

							StyledIcon {
								id: entryIcon2Txt
								font.pixelSize: Appearance.icons.size.small
								text: !button.model?.icon || button.model.icon == "" ?
									root.fallbackIcon : ""
								visible: (root.textIcons || (root.fallbackIcon && root.fallbackIcon != "")) && text && text != ""
							}

							StyledText {
								font.pixelSize: Appearance.font.size.small
								text: button.model ? button.model.name : "None"
								Layout.preferredWidth: parent.width
									- entryIcon2Img.width
									- entryIcon2Txt.width
									- arrowIcon.width
									- 2 * entryLayout.spacing
								elide: Text.ElideRight
								verticalAlignment: Qt.AlignLeft
								Layout.alignment: Qt.AlignLeft
								Layout.fillWidth: true
							}
						}

						implicitWidth: root.width
						implicitHeight: root.height
					}
				}
			}
		}
	}
}
