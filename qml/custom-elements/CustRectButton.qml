import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

Rectangle {
    id: root

    property int iconSize: 80
    property alias source: icon.source
    property alias text: label.text

    signal clicked();

    radius: 10

    property color baseColor: Style.dyn.baseGrey

    color: if (actionArea.containsPress)
               return Qt.tint(baseColor, Style.stat.fullToneShader)
           else if (actionArea.containsMouse)
               return Qt.tint(baseColor, Style.stat.halfToneShader)
           else
               return baseColor
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        
        CustIconButton {
            id: icon
            
            Layout.preferredHeight: root.iconSize
            Layout.preferredWidth: root.iconSize
            radius: root.iconSize / 2
            offset: root.iconSize / 4
            baseColor: Style.getShade("3d")
            Layout.alignment: Qt.AlignCenter
        }
        
        CustLabel {
            id: label
            Layout.alignment: Qt.AlignCenter
            font.pixelSize: 18
        }
    }

    MouseArea {
        id: actionArea
        anchors.fill: parent
        onClicked: root.clicked()
        cursorShape: Qt.PointingHandCursor
    }
}
