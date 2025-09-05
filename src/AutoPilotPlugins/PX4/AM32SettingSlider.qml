import QtQuick
import QtQuick.Controls
import QGroundControl
import QGroundControl.Controls

Column {
    property var setting: null
    property var fact: setting ? setting.fact : null
    property real value: fact ? fact.rawValue : 0

    property string label: ""
    property var labelColor: qgcPal.text
    property real from: 0
    property real to: 100
    property real stepSize: 1
    property int decimalPlaces: 0
    property var onValueChange: null
    property bool enabled: true

    spacing: ScreenTools.defaultFontPixelHeight / 4

    QGCLabel {
        text: label
        color: labelColor
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Slider {
        id: slider
        width: ScreenTools.defaultFontPixelWidth * 28
        from: parent.from
        to: parent.to
        value: parent.value
        stepSize: parent.stepSize
        snapMode: Slider.SnapAlways
        enabled: parent.enabled

        onValueChanged: {
            // TODO: this shouldn't be necessary -- we need updates to reflect on the sliders (when we receive fresh eeprom data)
            // if (!pressed) return  // Only update when user is dragging
            if (setting) setting.setPendingValue(value)
        }

        // Visual handle
        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: ScreenTools.defaultFontPixelHeight
            implicitHeight: implicitWidth
            radius: width / 2
            color: slider.pressed ? qgcPal.buttonHighlight : qgcPal.button
            border.color: qgcPal.text
        }

        // Value display
        ToolTip {
            parent: slider.handle
            visible: slider.pressed
            text: slider.value.toFixed(decimalPlaces)
        }

        // Slider fill direction (left to right)
        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: slider.availableWidth
            height: implicitHeight
            radius: 2
            color: qgcPal.window
            border.color: qgcPal.text
            border.width: 1

            // Progress fill from left to right
            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                color: qgcPal.text
                radius: parent.radius
            }
        }
    }

    // Value label
    QGCLabel {
        text: value.toFixed(decimalPlaces)
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: ScreenTools.smallFontPointSize
    }
}
