pragma Singleton
import QtQuick 2.11

Item {
    id: root

    property alias stat: static
    property alias dyn: dynamic

    // Enums for windows size property
    readonly property int smallSize: 0
    readonly property int middleSize: 1
    readonly property int fullSize: 2


    // Color scheme independent
    Item {
        id: static

        // coin colors
        readonly property color btcColor: "#FE9B28"
        readonly property color l_btcColor: "#14726B"

        // validation colors
        readonly property color validationTrueAddress: dynamic.baseActive
        readonly property color validationTrueAmount: "#03d482"
        readonly property color validationFalse: "#de6549"
        readonly property color validationAwait: "#999999"

        // message box
        readonly property color info: "#3498db"
        readonly property color critical: "#fe3427"
        readonly property color general: "#222222"

        // status colors
        readonly property color statusInsufficientAmount: "#de6549"
        readonly property color statusDetected: "#eec670"
        readonly property color statusProcessing: "#627fe1"
        readonly property color statusDone: "#03d482"
        readonly property color statusPending: "#e87a1a"

        // shaders
        readonly property color halfToneShader: "#10000000"
        readonly property color fullToneShader: "#20000000"
        readonly property color shadowShader:   "#80000000"
        readonly property color inputElementShader: "#c0222222"
    }

    // When scheme changed
    Item {
        id: dynamic

        property color fontColor: "white"
        property color disabledFontColor: "grey"

        // base colors
        readonly property color helpColor: "#f8d672"
        readonly property color baseGrey: "#4b4952"
        readonly property color baseActive: "#7392eb"

        readonly property color baseBackground: "black"

    }

    function getShade(hexLevel) {
        return Qt.tint(dynamic.baseBackground, String("#%1ffffff").arg(hexLevel));
    }
}
