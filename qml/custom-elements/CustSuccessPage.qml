import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

ColumnLayout {
    id: root
    spacing: 20

    property alias header: headerItem.text

    signal backClicked();

    CustLabel {
        id: headerItem
        Layout.preferredWidth: 500
        Layout.preferredHeight: 60
        Layout.alignment: Qt.AlignCenter
        horizontalAlignment: Qt.AlignCenter
        font.pixelSize: 30
        wrapMode: Text.WordWrap
    }

    Image {
        id: currIcon

        Layout.alignment: Qt.AlignCenter

        Layout.preferredWidth: 180
        Layout.preferredHeight: 180
        sourceSize.width:  Layout.preferredWidth
        sourceSize.height: Layout.preferredHeight

        source: "qrc:/assets/ok.png"
    }

    RowLayout {
        Layout.minimumWidth: 440
        Layout.maximumWidth: Layout.minimumWidth
        Layout.minimumHeight: 160
        Layout.maximumHeight: Layout.minimumHeight
        Layout.alignment: Qt.AlignCenter

        spacing: 20

        CustRectButton {
            Layout.fillHeight: true
            Layout.fillWidth: true

            source: "qrc:/assets/history_action.png"
            text: qsTr("History")

            onClicked: contentItemRoot.goToHistory()
        }

        CustRectButton {
            Layout.fillHeight: true
            Layout.fillWidth: true

            source: "qrc:/assets/back_action.png"
            text: qsTr("Back")

            onClicked: root.backClicked()
        }
    }
}
