import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

ProgressBar {
    id: root

    property color primaryColor: Style.dyn.baseGrey
    property color secondaryColor: Style.dyn.helpColor
    property color textColor: Style.dyn.fontColor

    padding: 2
    background: Item {
        id: bckgrnd
        implicitHeight: 20
        implicitWidth: parent.width
    }

    onValueChanged: {
        secondsLeft.text = String("%1 second(s) remaining").arg(Math.round((to - value) / 1000))
    }
    contentItem: ColumnLayout {
        width: parent.width

        Rectangle {
            Layout.fillWidth: true
            height: 4
            radius: 2
            color: root.primaryColor
            border.width: 0

            Rectangle {
                id: indicator
                anchors.left: parent.left
                width: (1 - root.visualPosition) * parent.width
                height: parent.height
                radius: parent.radius
                color: root.secondaryColor
                border.width: 0
            }
        }

        Text {
            id: secondsLeft
            Layout.fillWidth: true
            font.pixelSize: 18
            font.bold: false
            color: root.textColor
            horizontalAlignment: Text.AlignHCenter
        }
    }
}



