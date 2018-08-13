/****************************************************************************
**
** Copyright (C) 2018 Andre Lintelmann
** Contact: andre@codefruit.de
**
** Quick Prominent TopAppBar
** Qt Quick Controls 2 Material Design Prominent Top App Bar Example
** with Background Image and Parallax Scrolling Effect
**
**
** This program is free software: you can redistribute it and/or modify it
** under the terms of the GNU General Public License as published by the Free
** Software Foundation, either version 3 of the License, or (at your option)
** any later version.
**
** This program is distributed in the hope that it will be useful, but WITHOUT
** ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
** more details.
**
** You should have received a copy of the GNU General Public License along with
** this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QtQuick.Controls.Material 2.4

ApplicationWindow {
    visible: true
    width: 380
    height: 640
    title: qsTr("Quick-Prominent-TopAppBar")

    Material.theme: Material.Light
    Material.accent: Material.Red

    header: ToolBar {
        id: topAppBar

        Material.foreground: "white"
        Material.background: Material.accent

        // Main vars to enable or disable prominent top app bar
        property bool prominent: true

        property bool prominentHighlighted: true
        property int prominentHeight: 200
        property string prominentImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Laptop-coffee-flat-design-by-david-mendoza.png/800px-Laptop-coffee-flat-design-by-david-mendoza.png"
        property bool prominentCollapsed: topAppBar.height > topAppBar.backgroundHeight

        property int backgroundHeight: (prominentHeight + topAppBar.height) - flickable.contentY

        Component.onCompleted: {
            // If not prominent reset vars
            if (!topAppBar.prominent) {
                topAppBar.prominentHighlighted = false
                topAppBar.prominentHeight = 0
                topAppBar.prominentCollapsed = true
            }
        }

        Connections {
            target: flickable
            enabled: topAppBar.prominent
            property int contentYStart: 0

            onContentYChanged: {
                // drag down
                if (contentYStart > flickable.contentY &&
                        topAppBar.prominentHighlighted === false &&
                        flickable.contentY <= topAppBar.height) {
                    topAppBar.prominentHighlighted = true
                }
                // drag up
                if (contentYStart < flickable.contentY &&
                        topAppBar.prominentHighlighted === true &&
                        flickable.contentY >= topAppBar.prominentHeight) {
                    topAppBar.prominentHighlighted = false
                }
                contentYStart = flickable.contentY
            }
        }

        // Background Pane with shadow for prominent top app bar
        Pane {
            id: barImageHelper
            visible: topAppBar.prominent
            width: parent.width * 1.2
            height: Math.max(topAppBar.height, topAppBar.backgroundHeight)
            anchors.horizontalCenter: parent.horizontalCenter
            Material.elevation: topAppBar.prominentCollapsed ? 0 : 4
        }

        // Background Image
        Image {
            id: barImage
            visible: topAppBar.prominent
            width: parent.width
            height: topAppBar.backgroundHeight
            fillMode: Image.PreserveAspectCrop
            source: topAppBar.prominentImage
            opacity: topAppBar.prominentHighlighted
            Behavior on opacity { PropertyAnimation { } }
        }

        //
        // ########################
        // YOUR TOP APP BAR CONTENT
        // ########################

        RowLayout {
            anchors.fill: parent            
            ToolButton { text: qsTr("‹"); font.pixelSize: 32 }
            // Don't use Label Element here, if you want to animate it...
            Item { Layout.fillWidth: true }
            ToolButton { text: qsTr("⋮"); font.pixelSize: 32 }
        }

        // Animated Label
        Label {
            text: "Title"
            x: 50
            padding: 8
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignBottom
            // Calculate height and pixelSize for animation
            font.pixelSize: topAppBar.prominent ? 22 * Math.max(1, Math.min(2.5,topAppBar.backgroundHeight * 0.011)) : 22
            height: topAppBar.prominent ? Math.max(topAppBar.height, topAppBar.backgroundHeight) : topAppBar.height
        }
    }

    Page {
        id: page
        anchors.fill: parent

        Flickable {
            id: flickable
            anchors.fill: parent
            contentHeight: pane.contentHeight
            flickableDirection: Flickable.AutoFlickIfNeeded

            Item {
                // Flickable top Spacer with Prominent Top App Bar height
                id: flickableSpacer1
                height: topAppBar.prominentHeight
            }

            Pane {
                id: pane
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                y: flickableSpacer1.height

                GridLayout {
                    id: pageLayout
                    anchors.fill: parent
                    columns: 2

                    Text {
                        text: "18 Rectangles";
                        padding: 10
                        Layout.columnSpan: 2
                    }

                    //
                    // DUMMY CONTENT
                    Rectangle { color: "#d32f2f"; Layout.fillWidth: true; height: 80 }
                    Rectangle { color: "#388e3c"; Layout.fillWidth: true; height: 80 }
                    Rectangle { color: "#283593"; Layout.fillWidth: true; height: 50 }
                    Rectangle { color: "#d32f2f"; Layout.fillWidth: true; height: 50 }
                    Rectangle { color: "#388e3c"; Layout.fillWidth: true; height: 90 }
                    Rectangle { color: "#283593"; Layout.fillWidth: true; height: 90 }
                    Rectangle { color: "#d32f2f"; Layout.fillWidth: true; height: 50 }
                    Rectangle { color: "#388e3c"; Layout.fillWidth: true; height: 50 }
                    Rectangle { color: "#283593"; Layout.fillWidth: true; height: 70 }
                    Rectangle { color: "#d32f2f"; Layout.fillWidth: true; height: 70 }
                    Rectangle { color: "#388e3c"; Layout.fillWidth: true; height: 30 }
                    Rectangle { color: "#283593"; Layout.fillWidth: true; height: 30 }
                    Rectangle { color: "#d32f2f"; Layout.fillWidth: true; height: 80 }
                    Rectangle { color: "#388e3c"; Layout.fillWidth: true; height: 80 }
                    Rectangle { color: "#283593"; Layout.fillWidth: true; height: 50 }
                    Rectangle { color: "#d32f2f"; Layout.fillWidth: true; height: 50 }
                    Rectangle { color: "#388e3c"; Layout.fillWidth: true; height: 70 }
                    Rectangle { color: "#283593"; Layout.fillWidth: true; height: 70 }

                    Item {
                        //Flickable bottom spacer - For correct scrolling height
                        id: flickableSpacer2
                        height: topAppBar.prominentHeight + pane.padding
                    }
                }
            }

            ScrollIndicator.vertical: ScrollIndicator {
                visible: topAppBar.prominentCollapsed
            }
        }
    }
}
