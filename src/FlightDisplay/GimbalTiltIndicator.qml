import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 40
    height: parent ? parent.height * 0.6 : 200   // default if not anchored
    property var activeGimbal   // assigned from OnScreenGimbalController
    property real realPitch: 0
    // Map pitch to vertical position
    readonly property real targetY: height / 2 - (pitch / 90) * (height / 2)

    // Helper to map pitch (-90..+90) into vertical pixel range
    function pitchToY(pitch) {
        // 0° pitch = center, -90° = bottom, +90° = top
        return (height / 2 - (pitch / 90) * (height / 2))
    }

    // Background track
    Rectangle {
        id: track
        anchors.fill: parent
        radius: 6
        color: "#222222"
        opacity: 0.6
    }

    // Moving indicator
    Rectangle {
        id: marker
        width: parent.width
        height: 10
        radius: width / 2
        color: "#00FF00"


        y: pitchToY(realPitch)

        Behavior on y {
            NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
        }
    }

    // Text label showing current pitch angle
    Text {
        id: pitchLabel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        color: "white"
        font.pixelSize: 12
        //text: activeGimbal ? Math.round(activeGimbal.absolutePitch.rawValue) + "°" : "--"
    }


}
