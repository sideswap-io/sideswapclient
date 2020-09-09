import QtQuick 2.12
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import Qt.labs.qmlmodels 1.0
import "../style"

ScrollBar {
    id: root
    property color baseColor: Style.dyn.baseGrey

    hoverEnabled: true
    active: true
    orientation: Qt.Horizontal
    policy: ScrollBar.AlwaysOn
    visible: size < 1

    contentItem: Rectangle {
        implicitWidth: 6
        implicitHeight: 100
        radius: width / 2
        color: root.pressed ? Style.dyn.helpColor : root.baseColor
    }
}
