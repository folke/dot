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
    property bool initialModeLoaded: false
    readonly property string currentMode: configFile.text().trim()
    readonly property string gpuStatus: gpuStatusFile.text().trim()

    function statusColor() {
        if (currentMode === "integrated")
            return Theme.success;
        else if (currentMode === "ultimate")
            return Theme.error;
        else if (currentMode === "hybrid" && gpuStatus !== "suspended")
            return Theme.warning;
        else
            return Theme.primary;
    }

    FileView {
        id: configFile
        path: "/etc/optimus.conf"
        watchChanges: true
        blockLoading: true
        onFileChanged: this.reload()
    }

    FileView {
        id: gpuStatusFile
        path: "/sys/class/drm/card0/device/power/runtime_status"
        blockLoading: true
    }

    Timer {
        interval: 3000 // 3 seconds
        running: true
        repeat: true
        onTriggered: gpuStatusFile.reload()
    }

    // onGpuStatusChanged: {
    //     ToastService.showInfo("dGPU status: " + gpuStatus);
    // }

    onCurrentModeChanged: {
        if (!initialModeLoaded) {
            initialModeLoaded = true;
            return;
        }
        const modeLabel = currentMode.toUpperCase().charAt(0) + currentMode.slice(1);
        ToastService.showInfo("GPU mode set to " + modeLabel + "\nReboot required to apply");
    }

    function setMode(mode) {
        Quickshell.execDetached(["sh", "-c", "optimus " + mode]);
    }

    horizontalBarPill: Component {
        DankIcon {
            name: root.iconName
            size: Theme.barIconSize(barThickness)
            color: statusColor()
            anchors.centerIn: parent
            filled: true
        }
    }

    verticalBarPill: horizontalBarPill

    popoutContent: Component {
        PopoutComponent {
            id: popout

            headerText: "Optimus Mode"
            showCloseButton: true

            Column {
                width: parent.width
                spacing: Theme.spacingMedium
                padding: Theme.spacingMedium

                DankButtonGroup {
                    property var modeModel: ["integrated", "hybrid", "ultimate"]

                    model: ["Integrated", "Hybrid", "Ultimate"]
                    currentIndex: modeModel.indexOf(root.currentMode)
                    selectionMode: "single"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onSelectionChanged: (index, selected) => {
                        if (!selected)
                            return;
                        root.setMode(modeModel[index]);
                        popout.closePopout();
                    }
                }
            }
        }
    }

    popoutWidth: 400
    popoutHeight: 100
}
