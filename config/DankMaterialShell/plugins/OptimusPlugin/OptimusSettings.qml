import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "optimusPlugin"

    // Header section
    StyledText {
        width: parent.width
        text: "Optimus GPU Mode Settings"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "Monitor and switch GPU modes on your ASUS laptop with MUX switch support."
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
        topPadding: Theme.spacingMedium
    }

    Column {
        width: parent.width
        spacing: Theme.spacingXS
        leftPadding: Theme.spacingMedium

        StyledText {
            text: "🔋 Green - Integrated (best battery life)"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
        }

        StyledText {
            text: "⚡ Blue - Hybrid (balanced)"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
        }

        StyledText {
            text: "🎮 Red - MUX/dGPU Direct (best performance)"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
        }
    }

    StyledText {
        width: parent.width
        text: "💡 Tip: Click the widget in your bar to open the mode selector. Changing modes requires a reboot to take effect."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
        topPadding: Theme.spacingMedium
    }
}
