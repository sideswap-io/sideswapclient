import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../custom-elements"
import "../style"

BusyIndicator {
    id: root

    running: false
    visible: running

    onRunningChanged: {
        if (running) {
            timer.step = 0
            timer.start()
        }
        else {
            timer.stop()
        }
    }

    contentItem: Item {
        implicitWidth: 64
        implicitHeight: 64

        Item {
             id: item
             x: parent.width / 2 - 32
             y: parent.height / 2 - 32
             width: 64
             height: 64
             opacity: root.running ? 1 : 0

             Repeater {
                id: repeater
                model: 8

                Rectangle {
                    id: delegateItem
                    x: item.height / 2 * Math.cos((360 * index / repeater.count - 90) * Math.PI / 180)
                    y: item.height / 2 * Math.sin((360 * index / repeater.count - 90) * Math.PI / 180)
                    implicitWidth: 12
                    implicitHeight: 12
                    radius: implicitWidth / 2
                    border.width: 1
                    border.color: Style.dyn.helpColor
                    color: Style.dyn.baseGrey
                    Connections {
                        target: timer
                        onStepChanged: {
                            if (timer.step === 0) {
                                delegateItem.color = Style.dyn.baseGrey;
                                return;
                            }

                            if (timer.step % repeater.count !== index)
                                return;

                            if (Style.dyn.baseGrey === delegateItem.color)
                                delegateItem.color = Style.dyn.helpColor;
                            else
                                delegateItem.color = Style.dyn.baseGrey;
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: timer

        property int step: 0

        repeat: true
        interval: 125
        running: false
        onTriggered: {
            ++step;
        }

    }
}
