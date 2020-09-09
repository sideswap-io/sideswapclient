import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

TabBar {
    id: root
    property int tabWidth: 120
    property int tabHeight: 40
    property alias model: rep.model

    background: Item {

        anchors.fill: parent
        Rectangle {
            anchors.bottom: parent.bottom

            width: parent.width
            height: 2

            color: Style.dyn.disabledFontColor
        }
    }

    Repeater {
        id: rep
        delegate: TabButton {
            visible: !modelData.debugOnly || debug
            text: modelData.name
            width: root.tabWidth
            implicitHeight: root.tabHeight

            background: Item {
                anchors.fill: parent
                Rectangle {
                    id: highlight
                    radius: 3
                    width: 6
                    height: 6
                    color: Style.dyn.helpColor
                    visible: false
                    anchors{
                        verticalCenter: parent.verticalCenter
                        verticalCenterOffset: -4
                        left: parent.left
                    }
                    Connections {
                        target: root
                        onRequiredToCheck: {
                            if (index === model.index) {
                                highlight.visible = enable
                            }
                        }
                    }
                }

                Rectangle {
                    visible: root.currentIndex === model.index
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 2
                    color: Style.dyn.helpColor
                }
            }

            contentItem: Text {
                text: modelData.name
                font.bold: true
                font.capitalization: Font.AllUppercase
                opacity: enabled ? 1.0 : 0.3
                color: root.currentIndex === model.index
                       ? Style.dyn.fontColor
                       : Style.dyn.disabledFontColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                elide: Text.ElideRight
            }
        }
    }

    signal requiredToCheck(int index, bool enable);
    function setRequireToCheck(index, enable) {
        requiredToCheck(index, enable);
    }
}
