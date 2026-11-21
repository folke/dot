import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "optimusPlugin"

    StyledText {
        width: parent.width
        text: "Cardwire GPU Mode Settings"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "Switch Integrated, Hybrid, and Smart modes immediately through Cardwire. Firmware stays in Hybrid mode."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "This plugin displays a color-coded indicator in your bar showing the current GPU mode:"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
        topPadding: Theme.spacingM
    }

    Column {
        width: parent.width
        spacing: Theme.spacingXS
        leftPadding: Theme.spacingM

        StyledText {
            text: "Green — Integrated, dGPU asleep"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
        }

        StyledText {
            text: "Theme color — Hybrid/Smart, dGPU asleep"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
        }

        StyledText {
            text: "Orange — dGPU awake (any mode)"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
        }
    }

    StyledText {
        width: parent.width
        text: "Gray means status is unknown. No reboot is required; already-running GPU apps may need restarting. Cardwire automatically selects Integrated on battery and Hybrid on AC."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
        topPadding: Theme.spacingM
    }
}
