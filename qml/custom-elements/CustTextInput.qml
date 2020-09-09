import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

TextField {
    id: root

    property alias underscore: undersc.visible

    color: Style.dyn.fontColor
    verticalAlignment: Qt.AlignVCenter
    horizontalAlignment: Qt.AlignLeft
    font.pixelSize: 15
    placeholderTextColor: Style.getShade("85")
    leftPadding: 5

    clip: true

    selectByMouse: true

    background: Rectangle {
        border.width: 0
        color: "transparent"

        Rectangle {
            id: undersc
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            visible: false
            color: Style.dyn.baseGrey
        }
    }


    function changeTextReadonly(newText) {
        if (readOnly) {
            readOnly = false;
            text = newText;
            readOnly = true;
        }
        else {
            text = newText;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        propagateComposedEvents:true
        onClicked: {
            if (mouse.button === Qt.RightButton) {
                let selectStart = root.selectionStart
                let selectEnd = root.selectionEnd
                let curPos = root.cursorPosition
                contextMenu.popup()
                root.cursorPosition = curPos
                root.select(selectStart,selectEnd)
            }
        }
        onPressAndHold: {
            if (mouse.source === Qt.MouseEventNotSynthesized) {
                let selectStart = root.selectionStart
                let selectEnd = root.selectionEnd
                let curPos = root.cursorPosition
                contextMenu.popup()
                root.cursorPosition = curPos
                root.select(selectStart,selectEnd)
            }
        }
        Menu {
            id: contextMenu
            MenuItem {
                text: qsTr("Select all")
                enabled: root.text !== ""
                onTriggered: {
                    root.selectAll();
                }
            }

            MenuSeparator { }

            MenuItem {
                text: qsTr("Cut")
                enabled: root.selectedText !== ""
                onTriggered: {
                    root.cut()
                }
            }
            MenuItem {
                text: qsTr("Copy")
                enabled: root.selectedText !== ""
                onTriggered: {
                    root.copy()
                }
            }
            MenuItem {
                text: qsTr("Paste")
                enabled: !clipboardHelper.empty()
                onTriggered: {
                    root.text = clipboardHelper.get()
                }
            }
        }
    }
}
