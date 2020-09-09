import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.12
import "../style"

Item {
    id: root
    property alias controlItem: controlContainer.data

    RowLayout {
        id: controlContainer
        anchors.fill: parent
    }

    DropShadow {
        anchors.fill: controlContainer
        radius: 15.0
        samples: 31
        color: Style.stat.shadowShader
        source: controlContainer
    }
}

