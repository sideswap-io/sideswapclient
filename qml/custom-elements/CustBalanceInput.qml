import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"


CustTextInput {
    id: root

    property alias lowerBound: validator.bottom
    property alias upperBound: validator.top
    property alias decimals: validator.decimals
    property bool showUpperBound: true

    font.strikeout: !root.acceptableInput

    background: Rectangle {
        id: bckgrnd
        border.width: 1
        border.color:  if (root.text.length === 0 || Number(root.text) === .0) {
                            Style.stat.validationAwait
                       } else if (!root.acceptableInput) {
                            Style.stat.validationFalse
                       } else {
                            Style.stat.validationTrueAddress
                       }

        radius: 5
        color: "transparent"
    }


    leftPadding: 20
    font.pixelSize: root.accepted ? 17 : 15
    color: Style.dyn.fontColor
    validator: DoubleValidator {
        id: validator
        bottom: 0
        notation: DoubleValidator.StandardNotation
        decimals: 8
    }
}
