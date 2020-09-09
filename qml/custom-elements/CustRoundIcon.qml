import QtQuick 2.12
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import Qt.labs.qmlmodels 1.0
import "../style"

Rectangle {
    id: root

    property alias outerColor: root.color
    property alias innerColor: innerRect.color
    property alias source: image.source

    color: Style.dyn.baseGrey
    radius: 5

    Rectangle {
        id: innerRect
        anchors.centerIn: parent

        color: Style.getShade("3d")
        width: 3 / 4 * Math.min(root.width, root.height)
        height: width
        radius: width / 2
        
        Image {
            id: image
            anchors.centerIn: parent
            width: sourceSize.width
            height: sourceSize.height
            sourceSize.width:  2 / 3 * innerRect.width
            sourceSize.height: 2 / 3 * innerRect.height
        }
    }
}
