import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    // Load persisted mode or default to "notso"
    property string currentMode: SettingsData.getPluginSetting("karamel-power", "currentMode", "notso")

    ccWidgetIcon: currentMode === "chill" ? "eco" : (currentMode === "furious" ? "bolt" : "balance")
    ccWidgetPrimaryText: "Karamel Power"
    ccWidgetSecondaryText: currentMode === "chill" ? "Chill (40-60%)" : (currentMode === "furious" ? "Furious (0-100%)" : "Notso (60-80%)")
    ccWidgetIsActive: currentMode !== "notso"

    onCcWidgetToggled: {
        var newMode
        if (currentMode === "notso") {
            newMode = "chill"
        } else if (currentMode === "chill") {
            newMode = "furious"
        } else {
            newMode = "notso"
        }
        setMode(newMode)
    }

    function setMode(mode) {
        // Execute command
        Quickshell.execDetached(["fish", "-c", "kpower " + mode])

        // Update local state
        currentMode = mode

        // Persist to settings
        SettingsData.setPluginSetting("karamel-power", "currentMode", mode)

        // Notify other instances
        PluginService.pluginDataChanged("karamel-power")

        ToastService.showInfo("Karamel Power", getModeLabel(mode))
    }

    function getModeLabel(mode) {
        switch (mode) {
            case "chill": return "Chill (40-60%, low-power)"
            case "notso": return "Notso (60-80%, balanced)"
            case "furious": return "Furious (0-100%, performance)"
            default: return mode
        }
    }

    // Listen for changes from other instances
    Connections {
        target: PluginService
        function onPluginDataChanged(pluginId) {
            if (pluginId === "karamel-power") {
                root.currentMode = SettingsData.getPluginSetting("karamel-power", "currentMode", "notso")
            }
        }
    }

    ccDetailContent: Component {
        Rectangle {
            id: detailRoot
            implicitHeight: detailColumn.implicitHeight + Theme.spacingM * 2
            radius: Theme.cornerRadius
            color: Theme.surfaceContainerHigh

            // Read persisted mode
            property string selectedMode: SettingsData.getPluginSetting("karamel-power", "currentMode", "notso")

            // Update when data changes
            Connections {
                target: PluginService
                function onPluginDataChanged(pluginId) {
                    if (pluginId === "karamel-power") {
                        detailRoot.selectedMode = SettingsData.getPluginSetting("karamel-power", "currentMode", "notso")
                    }
                }
            }

            Column {
                id: detailColumn
                anchors.fill: parent
                anchors.margins: Theme.spacingM
                spacing: Theme.spacingM

                Row {
                    spacing: Theme.spacingM

                    DankIcon {
                        name: detailRoot.selectedMode === "chill" ? "eco" : (detailRoot.selectedMode === "furious" ? "bolt" : "balance")
                        size: 32
                        color: Theme.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Column {
                        spacing: 2
                        anchors.verticalCenter: parent.verticalCenter

                        StyledText {
                            text: "Karamel Power"
                            font.pixelSize: Theme.fontSizeLarge
                            color: Theme.surfaceText
                            font.weight: Font.Bold
                        }

                        StyledText {
                            text: "Framework 16"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing: Theme.spacingS

                    Repeater {
                        model: [
                            {id: "chill", label: "Chill", icon: "eco"},
                            {id: "notso", label: "Notso", icon: "balance"},
                            {id: "furious", label: "Furious", icon: "bolt"}
                        ]

                        Rectangle {
                            width: (detailColumn.width - Theme.spacingS * 2) / 3
                            height: 64
                            radius: Theme.cornerRadius
                            color: detailRoot.selectedMode === modelData.id ? Theme.primaryContainer : (modeMouseArea.containsMouse ? Theme.surfaceContainerHighest : Theme.surfaceContainer)
                            border.color: detailRoot.selectedMode === modelData.id ? Theme.primary : "transparent"
                            border.width: detailRoot.selectedMode === modelData.id ? 2 : 0

                            MouseArea {
                                id: modeMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.setMode(modelData.id)
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 4

                                DankIcon {
                                    name: modelData.icon
                                    size: Theme.iconSize
                                    color: detailRoot.selectedMode === modelData.id ? Theme.primary : Theme.surfaceVariantText
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                StyledText {
                                    text: modelData.label
                                    font.pixelSize: Theme.fontSizeSmall
                                    font.weight: detailRoot.selectedMode === modelData.id ? Font.Bold : Font.Medium
                                    color: detailRoot.selectedMode === modelData.id ? Theme.primary : Theme.surfaceText
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.surfaceContainerHighest
                }

                Row {
                    width: parent.width
                    spacing: Theme.spacingM

                    Column {
                        width: (parent.width - Theme.spacingM) / 2
                        spacing: 2

                        StyledText {
                            text: "Sustainer"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }

                        StyledText {
                            text: detailRoot.selectedMode === "chill" ? "40-60%" : (detailRoot.selectedMode === "furious" ? "0-100%" : "60-80%")
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Bold
                            color: Theme.surfaceText
                        }
                    }

                    Column {
                        width: (parent.width - Theme.spacingM) / 2
                        spacing: 2

                        StyledText {
                            text: "Profil CPU"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }

                        StyledText {
                            text: detailRoot.selectedMode === "chill" ? "low-power" : (detailRoot.selectedMode === "furious" ? "performance" : "balanced")
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Bold
                            color: Theme.surfaceText
                        }
                    }
                }
            }
        }
    }
}
