import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../custom-elements"
import "../style"

Popup {
    id: root

    enabled: !spinner.running
    modal: true
    visible: false

    anchors.centerIn: parent
    closePolicy: Popup.NoAutoClose

    width: parent.width * 0.75
    height: parent.height * 0.75

    background: Rectangle {
        anchors.fill: parent
        color: Style.dyn.baseGrey
    }

    property bool accepted: false
    Connections {
        target: netManager
        onApplyWalletsResult : {
            spinner.running  = false;
            const answer = JSON.parse(data);
            switch(answer.result) {
            case "WalletExists":
                contentText.text = contentText.walletExists;
                break;
            case "HostNotFound":
                contentText.text = contentText.networkIssue;
                break;
            case "IncorrectCredential":
                contentText.text = contentText.accessIssue;
                break;
            case "UnknownError":
                contentText.text = contentText.unknownError;
                break;
            case "Applied":
                contentText.text = contentText.success;
                root.accepted = true;
                stackRoot.currentIndex = 2;
                return;
            }

            ++stackRoot.currentIndex;
        }
    }

    contentItem: ColumnLayout {
        anchors{
            fill: parent
            margins: 20
        }

        spacing: 20

        CustIconButton {
            source: "qrc:/assets/close_cross.png"
            width: 20
            height: 20
            offset: 0
            showBckgrnd: false
            Layout.alignment: Qt.AlignRight | Qt.AlignTop

            onClicked: root.close()
        }

        CustLabel {
            id: header
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            text: qsTr("Backend wallet setup")
            font.pixelSize: 30
        }

        Rectangle {
            id: contentBackend
            Layout.fillHeight: true
            Layout.fillWidth: true
            radius: 5

            color: Style.getShade("55")

            SwipeView {
                id: stackRoot
                currentIndex: 0

                anchors.fill: parent
                anchors.margins: 20

                interactive: false
                clip: true

                ColumnLayout {
                    id: chooseWallet
                    spacing: 10

                    ColumnLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                        CustLabel {
                            id: title
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                            text: qsTr("Select your wallet:")
                            font.pixelSize: 20
                        }


                        ColumnLayout {
                            Layout.leftMargin: 20

                            CustRadioButton {
                                id: nodeElementsLocal
                                text: qsTr("Elements core (Local)")
                                checked: true
                                source: "qrc:/assets/elements_active.png"
                            }

                            CustRadioButton {
                                id: nodeElementsRemote
                                text: qsTr("Elements core (Remote)")
                                source: "qrc:/assets/elements_active.png"
                            }
                        }

                        Item { Layout.fillHeight: true }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            radius: 5

                            color: Style.getShade("60")

                            CustLabel {
                                anchors.fill: parent
                                padding: 5
                                elide: Text.ElideRight
                                wrapMode: Text.WordWrap
                                font.pixelSize: 15
                                color: "white"

                                text: qsTr("To execute swaps, you need to run your own Elements node. " +
                                           "You can download the Elements node binaries from the <a href=\"https://github.com/ElementsProject/elements/releases\">GitHub repository</a>.")

                            }
                        }
                    }
                }

                ColumnLayout {
                    id: setupConfig
                    spacing: 10

                    ColumnLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                        CustLabel {
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                            text: qsTr("Fill RPC(Remote Procedure Call) data:")
                            font.pixelSize: 20
                        }

                        GridLayout {
                            id: settingsContent
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                            Layout.leftMargin: 20
                            Layout.rightMargin: 20

                            columnSpacing: 20
                            columns: 2

                            CustLabel { text: qsTr("Rpc Host"); Layout.alignment: Qt.AlignRight; font.pixelSize: 18 }
                            CustTextInput {
                                id : rpcHost
                                Layout.preferredWidth: 200
                                underscore: true
                                font.pixelSize: 18
                                readOnly: nodeElementsLocal.checked
                                color: !readOnly ? Style.dyn.fontColor : Style.dyn.disabledFontColor

                                onFocusChanged: {
                                    console.log("FOCUS CHANGED", focus, mainWindow.activeFocusControl)

                                }
                            }

                            CustLabel { text: qsTr("Rpc Port"); Layout.alignment: Qt.AlignRight; font.pixelSize: 18 }
                            CustTextInput { id : rpcPort; Layout.preferredWidth: 200; underscore: true; font.pixelSize: 18 }

                            CustLabel { text: qsTr("Rpc Login"); Layout.alignment: Qt.AlignRight; font.pixelSize: 18}
                            CustTextInput { id : rpcLogin; Layout.preferredWidth: 200; underscore: true; font.pixelSize: 18 }

                            CustLabel { text: qsTr("Rpc Password"); Layout.alignment: Qt.AlignRight; font.pixelSize: 18 }
                            CustTextInput { id : rpcPassword; Layout.preferredWidth: 200; echoMode: TextInput.Password; underscore: true; font.pixelSize: 18 }
                        }
                    }
                }

                ColumnLayout {
                    id: instruction

                    Item {
                        id: frame
                        clip: true
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.margins: 30

                        Text {
                            id: contentText
                            y: -vbar.position * height
                            width: parent.width
                            height: implicitHeight
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            font.pixelSize: 15
                            color: "white"


                            textFormat: Text.RichText

                            property string networkIssue: "<p style=\"font-size: 30px; text-align: center\">We cannot connect to specified node</p><br/>" +
                                   "<p style=\"font-size: 20px; text-align: left\">" +
                                   "We cannot establish connection with your Elements Node RPC with network parameter(host/port) you have specified in previous page.</p>" +
                                   "<p style=\"font-size: 20px; text-align: left\">Bellow you could find a few tips which will help you to setup your Elements Node connection :<br/>" +
                                   "<ul><li>Ensure node config file contains correct configuration, <a href=\"https://github.com/ElementsProject/elements/blob/master/share/examples/liquid.conf#L350\">RPC server options</a> </li>" +
                                   "<li>Ensure you could connect to your node with rpc via other utils, like curl or elements-cli <a href=\"https://elementsproject.org/en/doc/0.18.1.7/rpc/network/ping/\">Ping command</a></li></ul>" +
                                  "</p>"

                            property string accessIssue: "<p style=\"font-size: 30px; text-align: center\">The Elements Node return unauthorized status</p><br/>" +
                                   "<p style=\"font-size: 20px; text-align: left\">" +
                                   "We could reach your node machine, but authentication data(login/password) is not correct.</p>" +
                                   "<p style=\"font-size: 20px; text-align: left\">Bellow you could find a few tips which will help you to setup your Elements Node connection :<br/>" +
                                   "<ul><li>Ensure node config file contains correct rpcuser and rpcpassword data, <a href=\"https://github.com/ElementsProject/elements/blob/master/share/examples/liquid.conf#L350\">RPC server options</a> </li>" +
                                   "<li>Ensure you could connect to your node with rpc via other utils, like curl or elements-cli <a href=\"https://elementsproject.org/en/doc/0.18.1.7/rpc/network/ping/\">Ping command</a></li></ul>" +
                                  "</p>"

                            property string walletExists: "<p style=\"font-size: 30px; text-align: center\">The liquid wallet with current config already exists</p>"
                            property string unknownError: "<p style=\"font-size: 30px; text-align: center\">The Elements node return uknown error.</p>"
                            property string success: "<p style=\"font-size: 30px; text-align: center\">The Elements node wallet connected with success.</p>"

                            onLinkActivated: Qt.openUrlExternally(link)
                        }

                        CustHScrollBar {
                            id: vbar
                            baseColor: Style.getShade("3d")
                            orientation: Qt.Vertical
                            size: frame.height / contentText.height
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                        }
                    }
                }

                onCurrentItemChanged: updateFocus()

                onFocusChanged: {
                    if (focus) {
                        updateFocus();
                    }
                }

                function updateFocus() {
                    if (currentIndex === 1) {
                        if (nodeElementsLocal.checked) {
                            rpcLogin.forceActiveFocus();
                        } else {
                            rpcHost.forceActiveFocus();
                            rpcHost.selectAll();
                        }
                    }
                }
            }

            BusyIndicator {
                id: spinner
                anchors.centerIn: parent
                running: false;
                visible: running
            }

            Keys.onPressed: {
                if (event.key !== Qt.Key_Enter && event.key !== Qt.Key_Return) {
                    return;
                } else if (toNextPage.visible) {
                    toNextPage.clicked();
                } else {
                    toPrevPage.clicked();
                }
            }
        }

        RowLayout {
            id: buttons

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom

            spacing: 20

            CustButton {
                id: cancelBtn
                text: qsTr("CANCEL")

                visible: !root.accepted
                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignRight
                font.pixelSize: 18

                implicitHeight: parent.height
                implicitWidth: parent.width
                baseColor: Style.getShade("66")
                onClicked: root.close()
            }

            Item { Layout.fillWidth: true }

            CustButton {
                id: toPrevPage
                text: qsTr("PREV")

                visible: stackRoot.currentIndex !== 0 && !root.accepted

                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignLeft
                font.pixelSize: 18

                implicitHeight: parent.height
                implicitWidth: parent.width
                baseColor: toNextPage.visible ? Style.getShade("66") : Style.dyn.baseActive
                onClicked: --stackRoot.currentIndex
            }

            CustButton {
                id: toNextPage
                text: if (stackRoot.currentIndex === 0)
                          qsTr("NEXT")
                      else if(root.accepted)
                          qsTr("DONE")
                      else
                          qsTr("APPLY")

                visible: stackRoot.currentIndex !== 2 || root.accepted

                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignRight
                font.pixelSize: 18

                implicitHeight: parent.height
                implicitWidth: parent.width
                baseColor: Style.dyn.baseActive
                onClicked: {
                    if (stackRoot.currentIndex === 0) {
                        rpcHost.text = "0.0.0.0";
                        rpcPort.text = "7041";
                        rpcLogin.text = "";
                        rpcPassword.text = "";

                        if (nodeElementsLocal.checked) {
                            rpcHost.text = "localhost";
                            root.tryConfig();
                            return;
                        }
                    } else if (stackRoot.currentIndex === 1) {
                        root.tryConfig();
                        return;
                    } else {
                        root.close();
                        return;
                    }

                    ++stackRoot.currentIndex
                }
            }
        }
    }

    property var focusControl: undefined
    onAboutToShow: {
        spinner.running = false;
        accepted = false;
    }

    onAboutToHide: {
        stackRoot.currentIndex = 0;
        rpcHost.text = "";
        rpcPort.text = "";
        rpcLogin.text = "";
        rpcPassword.text = "";
        nodeElementsLocal.checked = true;
        mainContentItem.refreshFocus();
        spinner.running = false;
        accepted = false;
    }

    function tryConfig() {
        accepted = false;
        spinner.running = true;
        netManager.tryAndApply(rpcHost.text,
                         Number(rpcPort.text),
                         rpcLogin.text,
                         rpcPassword.text);
    }
}
