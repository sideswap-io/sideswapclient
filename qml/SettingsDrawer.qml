import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.12
import "./custom-elements"
import "./style"
import "./dialogs"

Item {
    id: root
    property bool collapsed: true

    Rectangle {
        id: drawer
        color: Style.getShade("41")
        anchors.fill: parent

        Item {
            anchors.fill: parent
            anchors.topMargin: 16

            CustIconButton {
                id: connectionImage

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                width: 50
                height: 50
                offset: 10
                radius: width / 2
                baseColor: Style.getShade("28")
                visible: root.collapsed

                source: if (settingsList.model.length === 0)
                            "qrc:/assets/wallet.png"
                        else if (connected)
                            "qrc:/assets/elements_active.png"
                        else
                            "qrc:/assets/elements_not_connected.png"

                onClicked: root.collapsed = false

                property bool connected: false
                Connections {
                    target: netManager
                    onShowNotificaton: {
                        let newState = JSON.parse(data);
                        connectionImage.connected = newState.conn_state.rpc_last_call_success
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: if (settingsList.model.length === 0)
                               walletWizard.open()
                           else
                               root.collapsed = false
                cursorShape: Qt.PointingHandCursor
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 12
            clip: true
            visible: !root.collapsed

            spacing: 10

            Image {
                id: image
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                width: sourceSize.width
                height: sourceSize.height
                sourceSize.width:  180
                sourceSize.height: 50
                antialiasing: true
                source: "qrc:/assets/side_swap.png"
            }

            ListView {
                id: settingsList
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 5
                topMargin: 10
                spacing: 20
                clip: true

                model: []

                Connections {
                    target: netManager
                    onUpdateWalletsList: settingsList.model = JSON.parse(data).configs
                }

                delegate: Item {
                    id: delegateRoot
                    width: parent.width - 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 120

                    Rectangle {
                        border.color: modelData.is_active ? Style.dyn.baseActive : Style.dyn.baseGrey
                        border.width: modelData.is_active ? 2 : 0
                        radius: 5

                        color: modelData.is_active ? Qt.tint( border.color, "#b0000000") : Style.getShade("2a")
                        anchors.fill: parent

                        MouseArea {
                            anchors.fill: modelData.is_active ? undefined : parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                ensureDialog.index = model.index;
                                ensureDialog.activateAction = true;
                                ensureDialog.title = action.walletName;
                                ensureDialog.msg = qsTr("Do you want to connect to this wallet?");
                                ensureDialog.open();
                            }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10

                            Item { Layout.fillHeight: true }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.leftMargin: 10
                                spacing: 10
                                Image {
                                    width: 16
                                    height: 16
                                    sourceSize.width:  width
                                    sourceSize.height: height
                                    Layout.alignment: Qt.AlignRight

                                    source: if (connectionImage.connected && modelData.is_active)
                                                "qrc:/assets/elements_active.png"
                                            else
                                                "qrc:/assets/elements_not_connected.png"
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    CustLabel { text: qsTr("Wallet:"); Layout.alignment: Qt.AlignLeft;  font.pixelSize: 16 }
                                    CustLabel { text: modelData.wallet_type; Layout.alignment: Qt.AlignLeft; font.bold: false; font.pixelSize: 16 }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.leftMargin: 36
                                CustLabel { text: qsTr("Host:"); Layout.alignment: Qt.AlignLeft;  font.pixelSize: 16 }
                                CustLabel { text: modelData.host; Layout.alignment: Qt.AlignLeft; font.bold: false; font.pixelSize: 16 }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.leftMargin: 36
                                CustLabel { text: qsTr("Port:"); Layout.alignment: Qt.AlignLeft;  font.pixelSize: 16 }
                                CustLabel { text: modelData.port; Layout.alignment: Qt.AlignLeft; font.bold: false; font.pixelSize: 16 }
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    CustShadow {
                        x: delegateRoot.width - width * 3 / 4
                        y: - height / 4
                        z: 5
                        visible: !root.collapsed
                        width: 30
                        height: 30

                        controlItem: CustIconButton {
                            id: action
                            property string walletName: qsTr("%1 (%2:%3)")
                                           .arg(modelData.wallet_type)
                                           .arg(modelData.host)
                                           .arg(modelData.port);

                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            offset: 5
                            radius: 15
                            visible: !root.collapsed

                            baseColor: Style.dyn.baseGrey
                            source: "qrc:/assets/remove.png"
                            onClicked: {
                                ensureDialog.index = model.index;
                                ensureDialog.activateAction = false;
                                ensureDialog.title = action.walletName;
                                ensureDialog.msg = "Do you want to delete this wallet config?";
                                ensureDialog.open();
                            }
                        }
                    }
                }
            }

            CustShadow {

                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.margins: 20

                controlItem: CustButton {
                    id: addSwapBackend
                    text: qsTr("Add your liquid wallet")
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    implicitHeight: parent.height
                    implicitWidth: parent.width
                    onClicked: walletWizard.open()
                }
            }
        }
    }

    CustShadow {
        anchors.verticalCenter: parent.verticalCenter
        x: root.width - width / 2
        z: 1
        visible: !root.collapsed
        width: 40
        height: 40

        controlItem: CustIconButton {
            id: closeBtn

            Layout.fillHeight: true
            Layout.fillWidth: true
            offset: 8
            radius: 30
            visible: !root.collapsed

            baseColor: Style.dyn.baseGrey
            source: "qrc:/assets/arrow_left.png"
            onClicked: root.collapsed = true
        }
    }

    DialogBubble {
        id: ensureDialog

        property int index: -1
        property bool activateAction: true
        property string title: ""
        property string msg: ""

        bubbleMode: false
        parent: contentLyt
        content: {
            "msg_type": "Question",
            "title" : ensureDialog.title,
            "msg" : ensureDialog.msg
        }

        onCanceled: close()
        onAccepted: {
            close()
            if (activateAction) {
                netManager.applyConfig(index)
            } else {
                netManager.removeConfig(index)
            }
        }
    }
}


