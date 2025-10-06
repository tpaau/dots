pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var protoWorkspaces: ({})
	property list<NiriWorkspace> workspaces: {
		let len = Object.getOwnPropertyNames(protoWorkspaces[1]).length + 3
		let wsl = []
		for (let i = 1; i < len; i++) {
			let ws = protoWorkspaces[i]
			wsl.push(workComp.createObject(null, {
				aid: ws.id,
				idx: ws.idx,
				name: ws.name,
				output: ws.output,
				isUrgent: ws.is_urgent,
				isActive: ws.is_active,
				isFocused: ws.is_focused,
			}))
		}
		return wsl
	}

	Component {
		id: workComp
		NiriWorkspace {
		}
	}

    property var kbLayouts: []
    property int currentKbLayout: 0

    property var windows: ({})

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
                const event = JSON.parse(line);

                if (event.WorkspacesChanged) {
                    const e = event.WorkspacesChanged;
                    const workspaces = {};

                    for (const ws of e.workspaces) {
                        workspaces[ws.id] = ws;
                    }

                    root.protoWorkspaces = workspaces;
                } else if (event.WorkspaceActivated) {
                    const e = event.WorkspaceActivated;
                    const ws = root.protoWorkspaces[e.id];
                    const output = ws.output;

                    for (const id in root.protoWorkspaces) {
                        const ws = root.protoWorkspaces[id];
                        const got_activated = ws.id === e.id;

                        if (ws.output === output) {
                            ws.is_active = got_activated;
                        }

                        if (e.focused) {
                            ws.is_focused = got_activated;
                        }
                    }

                    root.protoWorkspacesChanged();
                } else if (event.KeyboardLayoutsChanged) {
                    const e = event.KeyboardLayoutsChanged.keyboard_layouts;
                    root.kbLayouts = e.names;
                    root.currentKbLayout = e.current_idx;
                } else if (event.KeyboardLayoutSwitched) {
                    const e = event.KeyboardLayoutSwitched;
                    root.currentKbLayout = e.idx;
                } else if (event.WindowsChanged) {
                    const e = event.WindowsChanged;
                    const windows = {};

                    for (const win of e.windows) {
                        windows[win.id] = win;
                    }

                    root.windows = windows;
                } else if (event.WindowOpenedOrChanged) {
                    const e = event.WindowOpenedOrChanged;
                    const win = e.window;
                    root.windows[win.id] = win;

                    if (win.is_focused) {
                        for (const id in root.windows) {
                            const win = root.windows[id];
                            win.is_focused = win.id === e.window.id;
                        }
                    }

                    root.windowsChanged();
                } else if (event.WindowClosed) {
                    const e = event.WindowClosed;
                    delete root.windows[e.id];
                    root.windowsChanged();
                } else if (event.WindowLayoutsChanged) {
                    const e = event.WindowLayoutsChanged;

                    for (const change of e.changes) {
                        root.windows[change[0]].layout = change[1];
                    }

                    root.windowsChanged();
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
