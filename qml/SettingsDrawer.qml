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

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 10
            spacing: 10

            CustIconButton {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                width: 40
                height: 40
                offset: 0
                showBckgrnd: false
                visible: root.collapsed

                source: "qrc:/assets/burger_menu.png"
                onClicked: root.collapsed = false
            }

            Image {
                id: connectionImage
                width: 30
                height: 30
                sourceSize.width:  width
                sourceSize.height: height
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                visible: root.collapsed && settingsList.model.length > 0

                source: connected
                        ? "qrc:/assets/elements_active.png"
                        : "qrc:/assets/elements_not_connected.png"

                property bool connected: false

                Connections {
                    target: netManager
                    onShowNotificaton: {
                        let newState = JSON.parse(data);
                        connectionImage.connected = newState.conn_state.rpc_last_call_success
                    }
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.collapsed = false
                }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 10
            clip: true
            visible: !root.collapsed

            spacing: 0

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
                Layout.margins: 10
                spacing: 5
                clip: true

                model: []

                Connections {
                    target: netManager
                    onUpdateWalletsList: settingsList.model = JSON.parse(data).configs
                }

                delegate: Rectangle {
                    border.color: modelData.is_active ? Style.dyn.baseActive : Style.dyn.baseGrey
                    border.width: 2
                    radius: 5

                    width: parent.width
                    height: 120

                    color: "transparent"

                    MouseArea {
                        anchors.fill: modelData.is_active ? undefined : parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            ensureDialog.index = model.index;
                            ensureDialog.activateAction = true;
                            ensureDialog.title = actions.walletName;
                            ensureDialog.msg = qsTr("Do you want to connect to this wallet?");
                            ensureDialog.open();
                        }
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        RowLayout {
                            Layout.fillWidth: true
                            CustLabel { text: qsTr("Wallet : %1").arg(modelData.wallet_type); Layout.alignment: Qt.AlignLeft }
                            Image {
                                width: 15
                                height: 15
                                sourceSize.width:  width
                                sourceSize.height: height
                                Layout.alignment: Qt.AlignRight

                                source: "qrc:/assets/elements_active.png"
                            }
                        }

                        CustLabel { text: qsTr("Host : %1").arg(modelData.host); Layout.alignment: Qt.AlignLeft }
                        CustLabel { text: qsTr("Port : %1").arg(modelData.port); Layout.alignment: Qt.AlignLeft }

                        RowLayout {
                            id: actions

                            property string walletName: qsTr("%1(%2:%3)")
                                            .arg(modelData.wallet_type)
                                            .arg(modelData.host)
                                            .arg(modelData.port);

                            spacing: 10
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            Item { Layout.fillWidth: true }

                            CustIconButton {
                                Layout.alignment: Qt.AlignVCenter

                                Layout.preferredWidth: 30
                                Layout.preferredHeight: 30
                                offset: 0
                                showBckgrnd: false

                                source: "qrc:/assets/remove.png"
                                onClicked: {
                                    ensureDialog.index = model.index;
                                    ensureDialog.activateAction = false;
                                    ensureDialog.title = actions.walletName;
                                    ensureDialog.msg = "Do you want to delete this wallet config?";
                                    ensureDialog.open();
                                }
                            }
                        }
                    }
                }
            }

            CustButton {
                id: addSwapBackend
                text: qsTr("+ Add your liquid wallet")

                Layout.fillWidth: true
                Layout.preferredHeight: 40
                Layout.margins: 20

                implicitHeight: parent.height
                implicitWidth: parent.width
                onClicked: walletWizard.open()
            }
        }
    }

    WizardAddWallet {
        id: walletWizard
        parent: mainWindowLyt
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


