import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../custom-elements"
import "../style"

RadioButton {
    id: root

    property int diameter: 20
    property color baseColor: Style.dyn.helpColor
    property color baseBorderColor: Style.getShade("7b")
    property alias source: icon.source
    
    font.pixelSize: 18
    spacing: 10
    leftPadding: 5

    background: Item {
        height: root.diameter
        width: root.diameter
    }
    
    indicator: Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: root.leftPadding
        implicitWidth: root.diameter
        implicitHeight: root.diameter
        radius: 15
        border.color: root.down
                      ? Qt.tint(root.baseBorderColor, Style.stat.fullToneShader)
                      : root.baseBorderColor
        border.width: 2
        color: "transparent"
        
        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 8
            height: parent.height - 8
            radius: 15
            color: root.down
                   ? Qt.tint(root.baseColor, Style.stat.fullToneShader)
                   : root.baseColor
            visible: root.checked
        }
    }
    
    contentItem: RowLayout {
        anchors.left: parent.left
        anchors.leftMargin: root.indicator.width + root.spacing + root.spacing

        Image {
            id: icon
            width: source !== undefined ? 20 : 0
            height: 20
            sourceSize.width:  width
            sourceSize.height: height
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }

        Text {
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


}
