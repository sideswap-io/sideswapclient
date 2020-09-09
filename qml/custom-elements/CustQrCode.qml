import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../style"

Rectangle {
    id: root

    radius: 10

    Canvas {
        id: qrCode

        anchors.fill: parent
        anchors.margins: 10

        property var gridSize
        property var binaryData: []

        onPaint: {
            let ctx = qrCode.getContext('2d');
            ctx.clearRect(0, 0, qrCode.width, qrCode.height)

            let dX = qrCode.width / gridSize;
            let dY = qrCode.height / gridSize;

            for (let i = 0; i < gridSize; ++i) {
                for (let j = 0; j < gridSize; ++j) {
                    ctx.fillStyle = binaryData[i * gridSize + j] === '1'
                            ? Qt.rgba(0, 0, 0, 255)
                            : Qt.rgba(255, 255, 255, 255);
                    ctx.fillRect(i * dX, j * dY, dX, dY);
                }
            }
        }
    }

    function processData(gSize, gData) {
        qrCode.gridSize = gSize
        qrCode.binaryData = gData
        qrCode.requestPaint();
    }

    onWidthChanged: qrCode.requestPaint();
    onHeightChanged: qrCode.requestPaint();

}
