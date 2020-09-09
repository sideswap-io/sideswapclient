import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

ProgressBar {
    id: root

    property color primaryColor: Style.dyn.baseGrey
    property color secondaryColor: Style.dyn.helpColor
    property color textColor: Style.dyn.fontColor

    padding: 2
    background: Item {
        id: bckgrnd
        implicitHeight: 160
        implicitWidth: 160
    }

    onValueChanged: {
        canvas.requestPaint()
        secondsLeft.text = String("%1 sec(s)").arg(Math.round((to - value) / 1000))
    }
    contentItem: Canvas {
        id: canvas
        anchors.fill: parent
        anchors.margins: 12
        antialiasing: true

        property real centerWidth: width / 2
        property real centerHeight: height / 2
        property real radius: (Math.min(canvas.width, canvas.height) / 2) - anchors.margins

        property real angle: (root.value - root.from) / (root.to - root.from) * 2 * Math.PI
        property real angleOffset: - Math.PI / 2

        property string text: "Text"

        onPaint: {
            var ctx = getContext("2d");
            ctx.save();

            ctx.clearRect(0, 0, canvas.width, canvas.height);

            ctx.beginPath();
            ctx.lineWidth = anchors.margins;
            ctx.strokeStyle = root.primaryColor;
            ctx.arc(canvas.centerWidth,
                    canvas.centerHeight,
                    canvas.radius,
                    canvas.angleOffset + canvas.angle,
                    canvas.angleOffset + 2 * Math.PI);
            ctx.stroke();

            ctx.beginPath();
            ctx.lineWidth = anchors.margins;
            ctx.strokeStyle = root.secondaryColor;
            ctx.lineCap = "round"
            ctx.arc(canvas.centerWidth,
                    canvas.centerHeight,
                    canvas.radius,
                    canvas.angleOffset,
                    canvas.angleOffset + canvas.angle);
            ctx.stroke();

            ctx.restore();
        }

        Text {
            id: secondsLeft
            anchors.centerIn: parent
            font.pixelSize: 20
            font.bold: true
            color: root.textColor
        }
    }
}



