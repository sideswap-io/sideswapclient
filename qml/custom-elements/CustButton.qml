import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

Button {
    id: root

    property color disableColor: Style.dyn.baseGrey
    property color baseColor: Style.dyn.baseGrey
    property int borderOffset: 0
    property alias fontColor: descr.color

    property alias radius: bckgrnd.radius

    font.bold: true
    background: Rectangle {
        id: bckgrnd

        radius: 5

        border.color: inner.color
        border.width: root.borderOffset > 0 ? 2 : 0
        color: Style.getShade("2e")

        Rectangle {
            id: inner
            radius: parent.radius

            anchors.centerIn: parent
            width: parent.width - 2 * borderOffset
            height: parent.height - 2 * borderOffset

            color: if (!root.enabled)
                       return disableColor
                   else if (pressed)
                       return Qt.tint(baseColor, Style.stat.fullToneShader)
                   else if (hovered)
                       return Qt.tint(baseColor, Style.stat.halfToneShader)
                   else
                       return baseColor
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.NoButton
        }
    }

    contentItem: Text {
        id: descr
        text: root.text
        font: root.font
        opacity: enabled ? 1.0 : 0.3
        color: Style.dyn.fontColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
