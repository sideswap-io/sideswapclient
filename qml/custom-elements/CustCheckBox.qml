import QtQuick 2.11
import QtQuick.Controls 2.11
import "../style"

CheckBox {
    id: root

    property int diameter: 20
    property color baseColor: Style.dyn.helpColor
    property color baseBorderColor: Style.getShade("7b")

    background: Item {
        height: diameter
        width: diameter
    }

    indicator: Rectangle {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 5
        }
        implicitWidth: root.diameter
        implicitHeight: root.diameter
        radius: 15
        border.color: root.down
                      ? Qt.tint(baseBorderColor, Style.stat.fullToneShader)
                      : baseBorderColor
        border.width: 2
        color: "transparent"

        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 8
            height: parent.height - 8
            radius: 15
            color: root.down
                   ? Qt.tint(baseColor, Style.stat.fullToneShader)
                   : baseColor
            visible: root.checked
        }
    }
}

