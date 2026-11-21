import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property string iconName: "bolt"
    property var gpu: ({ "ok": false, "state": "unknown" })
    property string statusOutput: ""
    property string switchError: ""
    property string requestedMode: ""
    readonly property string currentMode: gpu.ok ? gpu.mode : "unknown"
    readonly property var modeModel: gpu.ok ? gpu.modes : []
    readonly property var modeLabels: modeModel.map(mode => mode.charAt(0).toUpperCase() + mode.slice(1))
    readonly property string helperPath: decodeURIComponent(Qt.resolvedUrl("cardwire-status.py").toString().replace(/^file:\/\//, ""))

    function statusColor() {
        if (!gpu.ok || gpu.state === "unknown")
            return Theme.surfaceVariantText;
        if (gpu.state === "awake")
            return Theme.warning;
        if (currentMode === "integrated")
            return Theme.success;
        return Theme.primary;
    }

    function refresh() {
        if (!statusProcess.running) {
            statusOutput = "";
            statusProcess.running = true;
        }
    }

    function setMode(mode) {
        if (switchProcess.running || mode === currentMode || modeModel.indexOf(mode) < 0)
            return;
        requestedMode = mode;
        switchError = "";
        switchProcess.command = ["cardwire", "set", mode];
        switchProcess.running = true;
    }

    Process {
        id: statusProcess
        command: ["/usr/bin/python", root.helperPath]
        stdout: StdioCollector {
            onStreamFinished: root.statusOutput = this.text
        }
        onExited: (exitCode, exitStatus) => {
            try {
                if (exitCode !== 0)
                    throw new Error("Status helper failed");
                root.gpu = JSON.parse(root.statusOutput);
            } catch (error) {
                root.gpu = { "ok": false, "state": "unknown", "error": error.message };
            }
        }
    }

    Process {
        id: switchProcess
        stderr: StdioCollector {
            onStreamFinished: root.switchError = this.text.trim()
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0)
                ToastService.showInfo("Cardwire", "Switched to " + root.requestedMode);
            else
                ToastService.showError("Cardwire", root.switchError || "Mode switch failed");
            root.refresh();
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()

    horizontalBarPill: Component {
        DankIcon {
            name: root.iconName
            size: Theme.barIconSize(barThickness)
            color: root.statusColor()
            anchors.centerIn: parent
            filled: true
        }
    }

    verticalBarPill: horizontalBarPill

    popoutContent: Component {
        PopoutComponent {
            id: popout

            headerText: "Cardwire GPU Mode"
            showCloseButton: true

            Column {
                width: parent.width
                spacing: Theme.spacingM
                padding: Theme.spacingM

                StyledText {
                    width: parent.width - 2 * Theme.spacingM
                    text: root.gpu.ok
                        ? root.gpu.gpu + "\n" + root.gpu.power + " · " + (root.gpu.blocked ? "Blocked" : "Available")
                        : "Cardwire unavailable: " + (root.gpu.error || "Waiting for status")
                    color: Theme.surfaceVariantText
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.WordWrap
                }

                DankButtonGroup {
                    model: root.modeLabels
                    currentIndex: root.modeModel.indexOf(root.currentMode)
                    selectionMode: "single"
                    enabled: root.gpu.ok && !switchProcess.running
                    anchors.horizontalCenter: parent.horizontalCenter
                    onSelectionChanged: (index, selected) => {
                        if (!selected)
                            return;
                        root.setMode(root.modeModel[index]);
                    }
                }
            }
        }
    }

    popoutWidth: 400
    popoutHeight: 170
}
