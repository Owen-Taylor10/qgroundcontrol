/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

import QtLocation
import QtPositioning
import QtQuick.Window
import QtQml.Models

import QGroundControl

import QGroundControl.Controls

import QGroundControl.FlightDisplay
import QGroundControl.FlightMap


import QGroundControl.UTMSP

import QGroundControl.Viewer3D

Item {
    id: _root

    // These should only be used by MainRootWindow
    property var planController:    _planController
    property var guidedController:  _guidedController

    // Properties of UTM adapter
    property bool utmspSendActTrigger: false

    PlanMasterController {
        id:                     _planController
        flyView:                true
        Component.onCompleted:  start()
    }

    property bool   _mainWindowIsMap:       mapControl.pipState.state === mapControl.pipState.fullState
    property bool   _isFullWindowItemDark:  _mainWindowIsMap ? mapControl.isSatelliteMap : true
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _missionController:     _planController.missionController
    property var    _geoFenceController:    _planController.geoFenceController
    property var    _rallyPointController:  _planController.rallyPointController
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property var    _guidedController:      guidedActionsController
    property var    _guidedValueSlider:     guidedValueSlider
    property var    _widgetLayer:           widgetLayer
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30
    property var    _mapControl:            mapControl

    property real   _fullItemZorder:    0
    property real   _pipItemZorder:     QGroundControl.zOrderWidgets

    // Simulated pitch value (in degrees)
    property real simulatedPitch: 0

    function _calcCenterViewPort() {
        var newToolInset = Qt.rect(0, 0, width, height)
        toolstrip.adjustToolInset(newToolInset)
    }

    function dropMainStatusIndicatorTool() {
        toolbar.dropMainStatusIndicatorTool();
    }

    QGCToolInsets {
        id:                     _toolInsets
        leftEdgeBottomInset:    _pipView.leftEdgeBottomInset
        bottomEdgeLeftInset:    _pipView.bottomEdgeLeftInset
    }

    FlyViewToolBar {
        id:         toolbar
        visible:    !QGroundControl.videoManager.fullScreen
    }

    Item {
        id:                 mapHolder
        anchors.top:        toolbar.bottom
        anchors.bottom:     parent.bottom
        anchors.left:       parent.left
        anchors.right:      parent.right

        FlyViewMap {
            id:                     mapControl
            planMasterController:   _planController
            rightPanelWidth:        ScreenTools.defaultFontPixelHeight * 9
            pipView:                _pipView
            pipMode:                !_mainWindowIsMap
            toolInsets:             customOverlay.totalToolInsets
            mapName:                "FlightDisplayView"
            enabled:                !viewer3DWindow.isOpen
        }

        FlyViewVideo {
            id:         videoControl
            pipView:    _pipView
        }

        ColumnLayout {
            id:                     leftHandButtons
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:           parent.left
            spacing:                ScreenTools.defaultFontPixelWidth / 2
            uniformCellSizes:    true

            QGCButton {
                id:                 button1
                text:               qsTr("Button 1")
            }
            QGCButton {
                id:                 button2
                text:               qsTr("Button 2")
            }
            QGCButton {
                id:                 button3
                text:               qsTr("Button 3")
            }
            QGCButton {
                id:                 button4
                text:               qsTr("Button 4")
            }
            QGCButton {
                id:                 button5
                text:               qsTr("Button 5")
            }
        }

        ColumnLayout {
            id:                     rightHandButtons
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:           parent.right
            //spacing:                ScreenTools.defaultFontPixelWidth / 2
            spacing:                Screen.height * 0.01
            property int buttonWidth: Screen.width * 0.1
            uniformCellSizes:    true


            QGCButton {
                id:                 button6
                text:               qsTr("Button 6")
                width: parent.buttonWidth
                onClicked: console.log("SOS")
            }
            QGCButton {
                id:                 button7
                text:               qsTr("Button 7")
                width:              parent.buttonWidth
            }
            QGCButton {
                id:                 button8
                text:               qsTr("Button 8")
                width:              parent.buttonWidth
            }
            QGCButton {
                id:                 button9
                text:               qsTr("Button 9")
                width:              parent.buttonWidth
            }
            QGCButton {
                id:                 button10
                text:               qsTr("Button 10")
                width:              parent.buttonWidth
            }
        }

        Text {
            id:                     debugText
            anchors.horizontalCenter:       parent.horizontalCenter
            anchors.top:            parent.top
            color:                  "red"
            font.pixelSize:         ScreenTools.defaultFontPixelWidth * 4
            font.bold:              true
            text:                   qsTr("DEBUG_MODE")
            opacity:                0.4
            visible:                true
        }





        PipView {
            id:                     _pipView
            anchors.left:           parent.left
            anchors.bottom:         parent.bottom
            anchors.margins:        _toolsMargin
            item1IsFullSettingsKey: "MainFlyWindowIsMap"
            item1:                  mapControl
            item2:                  QGroundControl.videoManager.hasVideo ? videoControl : null
            show:                   QGroundControl.videoManager.hasVideo && !QGroundControl.videoManager.fullScreen &&
                                        (videoControl.pipState.state === videoControl.pipState.pipState || mapControl.pipState.state === mapControl.pipState.pipState)
            z:                      QGroundControl.zOrderWidgets

            property real leftEdgeBottomInset: visible ? width + anchors.margins : 0
            property real bottomEdgeLeftInset: visible ? height + anchors.margins : 0
        }

        FlyViewWidgetLayer {
            id:                     widgetLayer
            anchors.top:            parent.top
            anchors.bottom:         parent.bottom
            anchors.left:           parent.left
            anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
            z:                      _fullItemZorder + 2 // we need to add one extra layer for map 3d viewer (normally was 1)
            parentToolInsets:       _toolInsets
            mapControl:             _mapControl
            visible:                !QGroundControl.videoManager.fullScreen
            utmspActTrigger:        utmspSendActTrigger
            isViewer3DOpen:         viewer3DWindow.isOpen
        }

        FlyViewCustomLayer {
            id:                 customOverlay
            anchors.fill:       widgetLayer
            z:                  _fullItemZorder + 2
            parentToolInsets:   widgetLayer.totalToolInsets
            mapControl:         _mapControl
            visible:            !QGroundControl.videoManager.fullScreen
        }

        // Development tool for visualizing the insets for a paticular layer, show if needed
        FlyViewInsetViewer {
            id:                     widgetLayerInsetViewer
            anchors.top:            parent.top
            anchors.bottom:         parent.bottom
            anchors.left:           parent.left
            anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
            z:                      widgetLayer.z + 1
            insetsToView:           widgetLayer.totalToolInsets
            visible:                false
        }

        GuidedActionsController {
            id:                 guidedActionsController
            missionController:  _missionController
            guidedValueSlider:     _guidedValueSlider
        }

        //-- Guided value slider (e.g. altitude)
        GuidedValueSlider {
            id:                 guidedValueSlider
            anchors.right:      parent.right
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            z:                  QGroundControl.zOrderTopMost
            visible:            false
        }

        Viewer3D {
            id: viewer3DWindow
            anchors.fill: parent
        }


        GimbalTiltIndicator{
            id: tiltIndicator
            // activeGimbal: rootItem.activeGimbal
            activeGimbal: null
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 100
            anchors.topMargin: 20

            //anchors.verticalCenter: parent.verticalCenter
        }

        // --- Testing slider (remove later when gimbal is connected) ---
        Slider {
            id: pitchSlider
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            anchors.leftMargin: 50
            anchors.rightMargin: 50
            from: -90
            to: 90
            value: 0

            onValueChanged: tiltIndicator.realPitch = value
            Text {
                id: pitchSliderText
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Helvetica"
                font.pointSize: 20
                color: "#00ffea"
                // text: "Pitch: " + parent.value.toFixed(2) + "°"
                text: "Pitch: " + tiltIndicator.realPitch.toFixed(2) + "°"
            }
        }


    }

    UTMSPActivationStatusBar {
        activationStartTimestamp:   UTMSPStateStorage.startTimeStamp
        activationApproval:         UTMSPStateStorage.showActivationTab && QGroundControl.utmspManager.utmspVehicle.vehicleActivation
        flightID:                   UTMSPStateStorage.flightID
        anchors.fill:               parent

        function onActivationTriggered(value) {
            _root.utmspSendActTrigger = value
        }
    }
}
