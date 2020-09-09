import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "./custom-elements"
import "./style"
import "./dialogs"

Item {
    id: root
    height: 0

    property var lastState: {
        "title" : "",
        "msg" : "",
        "msg_type": "",
        "conn_state": {
            server_connected: false,
            rpc_last_call_success: false
        }
    }

    property var postponed: []

    Connections {
        target: netManager

        onShowNotificaton: {
            let newState = JSON.parse(data);
            lastState.conn_state = newState.conn_state
            let hasMessage = (newState.msg.length !== 0);
            if (hasMessage) {
                if (!bubble.visible) {
                    lastState = newState;
                    bubble.open();
                } else {
                    if (lastState.title === newState.tittle
                        || lastState.msg === newState.msg) {
                        return;
                    }

                    let alreadyInQueue = false;
                    for (let i in postponed) {
                        if (postponed[i].tittle === newState.tittle
                                && postponed[i].msg === newState.msg) {
                            alreadyInQueue = true;
                            break;
                        }
                    }

                    if (!alreadyInQueue) {
                        postponed.push(newState)
                    }
                }
            }
        }
    }

    DialogBubble {
        id: bubble

        content: root.lastState
        parent: contentLyt

        onClosed: {
            if (root.postponed.length !== 0) {
                root.lastState = root.postponed[0];
                root.postponed.pop();
                bubble.open();
            }
        }
    }

    function showMessage(_message, _color) {
        // Here we should receive notification from UI if needed
    }
}
