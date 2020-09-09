import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

Rectangle {
    id: root

    signal clicked();
    property alias source: image.source
    property int offset: 3
    property bool showBckgrnd: true

    property color baseColor: !showBckgrnd ? Style.getShade("50") : Style.dyn.baseActive

    radius: showBckgrnd ? 2 : (width / 2)
    width: 30
    height: 30

    color: if (actionArea.containsPress)
               return Qt.tint(baseColor, Style.stat.fullToneShader)
           else if (actionArea.containsMouse)
               return Qt.tint(baseColor, Style.stat.halfToneShader)
           else if (!showBckgrnd)
               return "transparent"
           else
               return baseColor
    
    Image {
        id: image
        anchors.centerIn: parent
        width: sourceSize.width
        height: sourceSize.height
        sourceSize.width:  root.width - 2 * root.offset
        sourceSize.height: root.height - 2 * root.offset
    }
    
    MouseArea {
        id: actionArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
