pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

	property alias workspaces: persist.workspaces
	property alias focusedWorkspace: persist.focusedWorkspace

	PersistentProperties {
		id: persist
		property list<NiriWorkspace> workspaces: []
		property NiriWorkspace focusedWorkspace: null
	}

	Component {
		id: workComp
		NiriWorkspace { }
	}

    readonly property string socketPath: Quickshell.env("NIRI_SOCKET")

    function activateWorkspace(id: int) {
        send({
            Action: {
                FocusWorkspace: {
                    reference: {
                        Id: id
                    }
                }
            }
        });
    }

    function send(request) {
        requestSocket.write(JSON.stringify(request) + "\n");
    }

    Socket {
        id: eventStreamSocket
        path: root.socketPath
        connected: true

        onConnectionStateChanged: {
            write('"EventStream"\n');
        }

		parser: SplitParser {
			onRead: line => {
				const event = JSON.parse(line)

				if (event.WorkspacesChanged) {
					let workspaces = []
					for (const workspace of event.WorkspacesChanged.workspaces) {
						const ws = workComp.createObject(null, {
							aid: workspace.id,
							idx: workspace.idx,
							name: workspace.name,
							output: workspace.output,
							isUrgent: workspace.is_urgent,
							isActive: workspace.is_active,
							isFocused: workspace.is_focused,
							activeWindowID: workspace.active_window_id
								? workspace.active_window_id : 0
						})
						if (ws.isFocused) {
							root.focusedWorkspace = ws
						}
						workspaces.push(ws)
					}
					workspaces = workspaces.sort((a, b) => a.aid - b.aid)
					root.workspaces = workspaces
				}
				else if (event.WorkspaceActivated) {
					const workspace = root.workspaces[event.WorkspaceActivated.id - 1]
					if (root.focusedWorkspace) {
						root.focusedWorkspace.isFocused = false
					}
					workspace.isFocused = true
					root.focusedWorkspace = workspace
				}
			}
		}
    }

    Socket {
        id: requestSocket
        path: root.socketPath
        connected: true
    }
}
