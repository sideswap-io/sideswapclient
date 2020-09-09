import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

Rectangle {
    id: root
    radius: 10
    property color baseColor: Style.dyn.baseGrey

    property alias currency: currency.text
    property alias icon: currIcon.source
    property alias subHeader: subHeader.text
    property alias amount: amount.text

    signal clicked();

    color: if (rootMouseArea.containsPress)
               return Qt.tint(baseColor, Style.stat.fullToneShader)
           else if (rootMouseArea.containsMouse)
               return Qt.tint(baseColor, Style.stat.halfToneShader)
           else
               return baseColor
    
    GridLayout {
        anchors {
            fill: parent
            topMargin: 30
            bottomMargin: anchors.topMargin
            leftMargin: 15 + 15 * mainWindow.dynWidthMult
            rightMargin: anchors.leftMargin
        }
        
        rows: 2
        columns: 2
        
        CustLabel {
            id: currency
            Layout.fillHeight: true
            Layout.fillWidth: true
            font.pixelSize: 40
        }
        
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            
            Image {
                id: currIcon
                
                anchors {
                    top: parent.top
                    right: parent.right
                }

                width: 34
                height: 34
                sourceSize.width:  width
                sourceSize.height: height
            }
        }

        CustLabel {
            id: subHeader
            Layout.fillHeight: true
            Layout.fillWidth: true
            font.pixelSize: 18
        }
        
        CustLabel {
            id: amount
            Layout.fillHeight: true
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignRight
            font.pixelSize: 16
        }
    }


    MouseArea {
        id: rootMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
            
