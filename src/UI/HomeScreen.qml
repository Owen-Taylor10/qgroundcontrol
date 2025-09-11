import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

// Home screen inspired by DJI's layout: icons aligned in a single row
Item {
    id: home
    anchors.fill: parent

    QGCPalette { id: qgcPal }

    signal flyClicked()
    signal planClicked()
    signal analyzeClicked()
    signal settingsClicked()

    // Row with all home screen options
    RowLayout {
        id: optionRow
        anchors.centerIn: parent
        spacing: ScreenTools.defaultFontPixelWidth * 8

        // Fly
        Button {
            background: Rectangle { color: "transparent" }
            onClicked: home.flyClicked()
            contentItem: Column {
                anchors.centerIn: parent
                spacing: ScreenTools.defaultFontPixelHeight / 2
                QGCColoredImage {
                    width: ScreenTools.defaultFontPixelHeight * 5
                    height: width
                    source: "/qmlimages/PaperPlane.svg"
                    fillMode: Image.PreserveAspectFit
                    color: qgcPal.buttonText
                }
                QGCLabel {
                    text: qsTr("Fly")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // Plan
        Button {
            background: Rectangle { color: "transparent" }
            onClicked: home.planClicked()
            contentItem: Column {
                anchors.centerIn: parent
                spacing: ScreenTools.defaultFontPixelHeight / 2
                QGCColoredImage {
                    width: ScreenTools.defaultFontPixelHeight * 5
                    height: width
                    source: "/qmlimages/Plan.svg"
                    fillMode: Image.PreserveAspectFit
                    color: qgcPal.buttonText
                }
                QGCLabel {
                    text: qsTr("Plan")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // Analyze (advanced UI only)
        Button {
            visible: QGroundControl.corePlugin.showAdvancedUI
            background: Rectangle { color: "transparent" }
            onClicked: home.analyzeClicked()
            contentItem: Column {
                anchors.centerIn: parent
                spacing: ScreenTools.defaultFontPixelHeight / 2
                QGCColoredImage {
                    width: ScreenTools.defaultFontPixelHeight * 5
                    height: width
                    source: "/qmlimages/Analyze.svg"
                    fillMode: Image.PreserveAspectFit
                    color: qgcPal.buttonText
                }
                QGCLabel {
                    text: qsTr("Analyze")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // Settings
        Button {
            background: Rectangle { color: "transparent" }
            onClicked: home.settingsClicked()
            contentItem: Column {
                anchors.centerIn: parent
                spacing: ScreenTools.defaultFontPixelHeight / 2
                QGCColoredImage {
                    width: ScreenTools.defaultFontPixelHeight * 5
                    height: width
                    source: "/qmlimages/Gears.svg"
                    fillMode: Image.PreserveAspectFit
                    color: qgcPal.buttonText
                }
                QGCLabel {
                    text: qsTr("Settings")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
