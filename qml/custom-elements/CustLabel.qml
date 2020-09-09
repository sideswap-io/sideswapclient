import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

Label {
    font.pixelSize: 15
    font.bold: true
    color: Style.dyn.fontColor
    horizontalAlignment: Qt.AlignLeft
    verticalAlignment: Qt.AlignVCenter
    onLinkActivated: Qt.openUrlExternally(link)
}
