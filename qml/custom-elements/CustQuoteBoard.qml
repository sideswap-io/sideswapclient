import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

Rectangle {
    property alias sourceIcon: sIcon.source
    property alias destIcon: dIcon.source
    property alias price: priceHandler.text
    property alias deliver: deliverHandler.text
    property alias receive: receiveHandler.text


    Layout.preferredHeight: 180
    Layout.preferredWidth: 400
    radius: 5
    border.width: 1
    border.color: Style.stat.validationTrueAddress
    color: Qt.tint(border.color, Style.stat.inputElementShader)
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 5
        
        Item { Layout.fillHeight: true }
        
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Image {
                id: sIcon
                Layout.preferredWidth: 30
                height: 30
                sourceSize.width:  width
                sourceSize.height: height
                Layout.alignment: Qt.AlignCenter
            }
            
            Image {
                Layout.preferredWidth: 20
                height: 20
                sourceSize.width:  width
                sourceSize.height: height
                Layout.alignment: Qt.AlignCenter
                source: "qrc:/assets/data_exchange_arrows.png"
            }
            
            Image {
                id: dIcon
                Layout.preferredWidth: 30
                height: 30
                sourceSize.width:  width
                sourceSize.height: height
                Layout.alignment: Qt.AlignCenter
            }
        }
        
        CustLabel {
            id: priceHandler
            Layout.fillWidth: true
            font.pixelSize: 30
            horizontalAlignment: Qt.AlignHCenter
        }

        CustLabel {
            id: deliverHandler
            Layout.fillWidth: true
            font.pixelSize: 18
            horizontalAlignment: Qt.AlignHCenter
            font.bold: false
        }
        
        CustLabel {
            id: receiveHandler
            Layout.fillWidth: true
            font.pixelSize: 18
            horizontalAlignment: Qt.AlignHCenter
            font.bold: false
        }

        Item { Layout.fillHeight: true }
    }
}
