import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"


ComboBox {
    id: root

    property color baseColor: Style.dyn.baseGrey

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 50
        radius: 5

        color: if (root.pressed)
                   return Qt.tint(baseColor, Style.stat.fullToneShader)
               else if (root.hovered)
                   return Qt.tint(baseColor, Style.stat.halfToneShader)
               else
                   return baseColor
    }


    indicator: CustIconButton {
        id: indicator
        width: 16
        height: 16
        offset: 0
        showBckgrnd: false
        anchors {
            right: parent.right
            rightMargin: 16
            verticalCenter: parent.verticalCenter
        }

        source: popup.visible
                    ? "qrc:/assets/collapse_arrow.png"
                    : "qrc:/assets/expand_arrow.png"
        onClicked: popup.visible = !popup.visible
    }

    contentItem: RowLayout {
        anchors {
            fill: parent
            leftMargin: 16
            rightMargin: 40
        }
        spacing: 10

        Image {
            Layout.preferredWidth: 20
            height: 20
            sourceSize.width:  width
            sourceSize.height: height
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            source: if (root.model !== undefined && root.count !== 0 && root.currentIndex !== -1)
                        "data:image/png;base64," + root.model[root.currentIndex].icon
                    else ""
        }

        Text {
            leftPadding: 0
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.fillWidth: true

            text: root.displayText
            font.bold: true
            font.pixelSize: 20
            color: Style.dyn.fontColor
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    delegate: ItemDelegate {
        id: deleg

        width: root.width
        contentItem: RowLayout {
            anchors {
                fill: parent
                leftMargin: 16
            }
            spacing: 10

            Image {
                Layout.preferredWidth: 20
                height: 20
                sourceSize.width:  width
                sourceSize.height: height
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                source: if (root.model !== undefined)
                            "data:image/png;base64," + modelData.icon
                        else ""
            }

            Text {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                Layout.preferredWidth: 100

                text: modelData.name
                font.bold: true
                font.pixelSize: 14
                color: Style.dyn.fontColor
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }


            Text {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                Layout.rightMargin: 20
                Layout.fillWidth: true

                text: modelData.ticker
                font.bold: true
                font.pixelSize: 16
                color: Style.dyn.disabledFontColor
                verticalAlignment: Text.AlignVCenter
            }

            Item { Layout.fillWidth: true }
        }

        highlighted: root.highlightedIndex === index

        background: ColumnLayout {
            anchors.fill: parent
            spacing: 0

            CustHorDelimeter {}
            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: if (deleg.highlighted) {
                           return Qt.tint(root.baseColor, Style.stat.fullToneShader)
                       } else if (index === root.currentIndex) {
                           return Qt.tint(root.baseColor, Style.stat.halfToneShader)
                       } else {
                           return root.baseColor
                       }
            }
        }
    }

    popup: Popup {
        y: root.height - 1
        width: root.width
        implicitHeight: contentItem.implicitHeight
        padding: 0

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.popup.visible ? root.delegateModel : null
            currentIndex: root.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: root.baseColor
            radius: 5
        }
    }
}

