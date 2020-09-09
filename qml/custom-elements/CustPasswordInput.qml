import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

CustTextInput {
    id: root
    echoMode: TextInput.Password
    background: Rectangle {
        border.width: 1
        border.color: Style.getShade("55")
        radius: 5
        color: Style.getShade("3d")
    }
}

