import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs.config

RowLayout {
	id: root
	readonly property list<PwNode> screenshare: Pipewire.linkGroups.values.filter(pwlg => pwlg.source.type === PwNodeType.VideoSource).map(pwlg => pwlg.target)
	onScreenshareChanged: {
		for (let item of screenshare) {
			console.warn(item)
		}
	}
	readonly property list<PwNode> audioIn: Pipewire.linkGroups.values.filter(pwlg => pwlg.source.type === PwNodeType.AudioSource && pwlg.target.type === PwNodeType.AudioInStream).map(pwlg => pwlg.target)
	readonly property list<PwNode> audioOut: Pipewire.linkGroups.values.filter(pwlg => pwlg.source.type === PwNodeType.AudioOutStream && pwlg.target.type === PwNodeType.AudioSink).map(pwlg => pwlg.source)

	visible: screenshareNode.visible

	PrivacyNode {
		id: screenshareNode
		nodes: root.screenshare
		visible: nodes.length > 0
	}

	component PrivacyNode: Rectangle {
		required property list<PwNode> nodes
		color: Theme.pallete.fg.c4
		radius: Math.min(width, height) / 2
		implicitWidth: 50
		implicitHeight: 50
	}
}
