import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../custom-elements"
import "../style"

Popup {
    id: root

    property var content
    property bool bubbleMode: true

    signal canceled()
    signal accepted()

    modal: true
    visible: false
    
    anchors.centerIn: parent
    closePolicy: bubbleMode ? Popup.CloseOnPressOutside : Popup.NoAutoClose
    
    width: 450
    height: 300
    
    background: Rectangle {
        id: bckgrnd
        anchors.fill: parent
        border.width: 2
        border.color: if (content.msg_type === "Info" || content.msg_type === "Question") {
                          return Style.stat.info
                      } else if (content.msg_type === "Error") {
                          return Style.stat.critical
                      } else {
                          return Style.stat.general
                      }
        color: Style.getShade("23")
        radius: 5
    }
    
    contentItem: Item {
        
        MouseArea {
            anchors.fill: root.bubbleMode ? parent : undefined
            onClicked: root.close();
        }
        
        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            
            CustIconButton {
                source: "qrc:/assets/close_cross.png"
                width: 20
                height: 20
                offset: 0
                showBckgrnd: false
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                
                onClicked: root.close();
            }
            
            Image {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                width: 120
                height: 120
                sourceSize.width:  width
                sourceSize.height: height
                
                source: if (content.msg_type === "Info") {
                            return "qrc:/assets/info.png"
                        } else if (content.msg_type === "Error") {
                            return "qrc:/assets/warning.png"
                        } else if (content.msg_type === "Question") {
                            return "qrc:/assets/question.png"
                        } else {
                            ""
                        }
            }
            
            CustLabel {
                id: title
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.fillWidth: true
                Layout.topMargin: 20
                font.pixelSize: 30
                text: content.title
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }
            
            CustLabel {
                id: message
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.topMargin: 0
                font.pixelSize: 20
                text: content.msg
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                wrapMode: Text.WordWrap
                font.bold: false
                elide: Text.ElideRight
            }
            Item {
                Layout.fillHeight: true
            }

            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true

                visible: !root.bubbleMode

                spacing: 20

                Item { Layout.fillWidth: true }

                CustButton {
                    id: cancelPass
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40

                    font.pixelSize: 16
                    text: qsTr("CANCEL")
                    baseColor: Style.dyn.baseGrey

                    onClicked: root.canceled()
                }

                CustButton {
                    id: acceptPass
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40

                    font.pixelSize: 16
                    text: qsTr("ACCEPT")
                    baseColor: Style.dyn.baseActive


                    onClicked: root.accepted()
                }

                Item { Layout.fillWidth: true }
            }
        }
    }
    
    onAboutToShow: {
        if (root.bubbleMode)
            timeout.start()
    }
    onAboutToHide: if (timeout.running) timeout.stop();
        
    Timer {
        id: timeout
        repeat: false
        interval: 5000
        onTriggered: root.close();
    }
    
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }
    
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }
}
