import QtQuick 2.12
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import Qt.labs.qmlmodels 1.0
import "../style"

ColumnLayout {
    id: root
    property bool expandRow: false

    property alias header: hItem.text
    property alias content: cItem.text
    property alias showCopyAction: copyAction.visible
    property alias showRedirectAction: redirectAction.visible

    // [ { "header" : "", "content" : "" } ... ]
    property alias rowModel: rowInfoRepeater.model

    signal copyClicked();
    signal redirectClicked();

    spacing: 0
    
    CustHorDelimeter {
        id: del
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
    }

    ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.leftMargin: 30
        Layout.rightMargin: 20
        Layout.topMargin: 10
        Layout.bottomMargin: 20
        visible: !root.expandRow

        CustLabel {
            id: hItem

            Layout.fillWidth: true
            Layout.fillHeight: true

            color: Style.dyn.disabledFontColor
        }

        GridLayout {
            rowSpacing: 0
            rows: 1
            columns: 6

            Layout.fillWidth: true
            Layout.fillHeight: true

            CustLabel {
                id: cItem
                color: Style.dyn.fontColor
                font.bold: false
                font.pixelSize: 16
                Layout.fillWidth: true
                Layout.columnSpan: 5
            }

            RowLayout {
                id: rowLyt
                spacing: 5
                Layout.minimumWidth: 135
                Layout.alignment: Qt.AlignRight

                CustIconButton {
                    id: copyAction
                    source: "qrc:/assets/copy_action.png"
                    radius: 15
                    offset: 8
                    baseColor: Style.getShade("3d")
                    Layout.alignment: Qt.AlignRight

                    onClicked: root.copyClicked()
                }

                CustIconButton {
                    id: redirectAction
                    source: "qrc:/assets/redirect.png"
                    radius: 15
                    offset: 6
                    baseColor: Style.getShade("3d")
                    Layout.alignment: Qt.AlignLeft

                    onClicked: root.redirectClicked()
                }
            }
        }
    }

    RowLayout {
        spacing: 0
        Layout.fillHeight: true
        Layout.fillWidth: true
        visible: root.expandRow

        Repeater {
            id: rowInfoRepeater
            model : []
            delegate: Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                CustVerDelimeter { visible: index !== 0 }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    CustLabel {
                        color: Style.dyn.disabledFontColor
                        font.bold: false
                        text: modelData.header
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignBottom
                    }

                    CustLabel {
                        color: Style.dyn.fontColor
                        text: modelData.content
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignTop
                        font.pixelSize: 20
                    }
                }
            }
        }
    }
}
