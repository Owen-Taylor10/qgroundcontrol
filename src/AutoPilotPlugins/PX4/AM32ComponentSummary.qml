/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls

import QGroundControl
import QGroundControl.FactControls
import QGroundControl.Controls

Item {
    anchors.fill:   parent

    property var vehicle: globals.activeVehicle
    property string _naString: qsTr("N/A")

    Column {
        anchors.fill:       parent

        VehicleSummaryRow {
            labelText: qsTr("ESCs Detected")
            valueText: vehicle && vehicle.escs ? vehicle.escs.count : _naString
        }

        VehicleSummaryRow {
            labelText: qsTr("AM32 Support")
            valueText: {
                if (vehicle && vehicle.escs && vehicle.escs.count > 0) {
                    var firstEsc = vehicle.escs.get(0)
                    if (firstEsc && firstEsc.am32Eeprom) {
                        return qsTr("Available")
                    }
                }
                return _naString
            }
        }

        VehicleSummaryRow {
            labelText: qsTr("Status")
            valueText: vehicle && vehicle.escs && vehicle.escs.count > 0 ? qsTr("Ready") : qsTr("Not Connected")
        }
    }
}