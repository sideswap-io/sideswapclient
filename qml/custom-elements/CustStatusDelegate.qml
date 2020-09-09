import QtQuick 2.12
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import Qt.labs.qmlmodels 1.0
import "../style"

Item {
    id: statusDelegate

    property alias text: cont.text

    Item {
        id: wrapper
        height: cont.height + 2
        width: cont.width + 10
        anchors.centerIn: parent

        CustTextDelegate {
            id: cont
            anchors.centerIn: parent
            color: if (text === "Insufficient amount" || text === "Failed")
                       return Style.stat.statusInsufficientAmount
                   else if (text === "Processing" || text.startsWith("Broadcast") || text.indexOf("/2") !== -1)
                       return Style.stat.statusProcessing
                   else if (text === "Done" || text == "Settled")
                       return Style.stat.statusDone
                   else
                       return Style.stat.statusDetected
        }
    }
}


