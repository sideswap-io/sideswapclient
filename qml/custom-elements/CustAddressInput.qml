import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

CustTextInput {
    id: root

    property string address : ""
    property bool liquidCheck: false

    onLiquidCheckChanged: checkAddr();
    onTextChanged: checkAddr();

    leftPadding: 34
    font.pixelSize: text === "" ? 20 : 13

    color: Style.dyn.fontColor

    background: Rectangle {
        border.width: 1
        border.color:   if (readOnly)
                            Style.stat.validationAwait
                        else if (address.length !== 0)
                          Style.stat.validationTrueAddress
                        else if (root.text.length !== 0)
                          Style.stat.validationFalse
                        else
                          Style.stat.validationAwait
        radius: 5
        color: "transparent"
    }

    function checkAddr() {
        if (readOnly)
            return;

        address = "";
        if (root.liquidCheck) {
            if (netManager.checkBitcoinAddress(root.text.trim())) {
                address = root.text.trim();
            }
        } else {
            if (netManager.checkElementsAddress(root.text.trim())) {
                address = root.text.trim();
            }
        }
    }

    function setInput(newInput) {
        root.text = newInput
        checkAddr()
    }

    function clearInput() {
        root.clear()
        checkAddr()
    }

    function inputEmpty() {
        return root.text.length === 0;
    }
}
