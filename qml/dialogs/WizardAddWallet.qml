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

    property bool nodeElementsLocal: walletsList.currentIndex === 0
    property bool nodeElementsRemote: walletsList.currentIndex === 1

    property bool accepted: false
    property bool failedConfig: false
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
                root.accepted = true;
                root.close();
                return;
            }

            if (stackRoot.currentIndex !== 1) {
                ++stackRoot.currentIndex;
            }

            if (answer.result === "IncorrectCredential") {
                rpcLogin.forceActiveFocus();
            } else if (rpcHost.readOnly) {
                rpcPort.forceActiveFocus();
            } else {
                rpcHost.forceActiveFocus();
            }

            vbar.position = 0;
            failedConfig = true;
        }
    }

    contentItem: ColumnLayout {
        id: contentRoot

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

        Item {
            id: contentBackend
            Layout.fillHeight: true
            Layout.fillWidth: true

            SwipeView {
                id: stackRoot
                currentIndex: 0

                anchors.fill: parent

                interactive: false
                clip: true

                ColumnLayout {
                    id: chooseWallet
                    spacing: 10

                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        CustLabel {
                            id: title
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                            text: qsTr("Select your Liquid wallet")
                            font.pixelSize: 30
                        }

                        ListView {
                            id: walletsList

                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.margins: 10
                            clip: true
                            spacing: 10
                            topMargin: 10

                            model: [
                                {"text": qsTr("Elements core (Local)"), "source": "qrc:/assets/elements_active.png"},
                                {"text": qsTr("Elements core (Remote)"), "source": "qrc:/assets/elements_active.png"}
                            ]

                            delegate: CustShadow {
                                width: 400
                                height: 60
                                anchors.horizontalCenter: parent.horizontalCenter

                                controlItem: Rectangle {
                                    property bool isActive: walletsList.currentIndex === index

                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    border.color: isActive ? Style.dyn.baseActive : Style.dyn.baseGrey
                                    border.width: isActive ? 2 : 0
                                    radius: 5

                                    color: isActive ? Qt.tint( border.color, "#a0000000") : Style.dyn.baseGrey

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 15
                                        anchors.left: parent.left
                                        spacing: 20
                                        CustIconButton {
                                            width: 30
                                            height: 30
                                            Layout.alignment: Qt.AlignLeft
                                            offset: 7
                                            radius: width / 2

                                            baseColor: Style.getShade("2a")
                                            source: "qrc:/assets/elements_active.png"
                                        }

                                        CustLabel { text: modelData.text ; Layout.alignment: Qt.AlignLeft;  font.pixelSize: 16 }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: walletsList.currentIndex = index
                                }
                            }

                        }

                        CustLabel {
                            padding: 5
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            font.pixelSize: 15
                            Layout.preferredWidth: 580
                            Layout.preferredHeight: 60
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            color: Style.dyn.fontColor
                            horizontalAlignment: Qt.AlignHCenter
                            font.bold: false
                            textFormat: Text.RichText

                            text: qsTr("To execute swaps, you need to run your own Elements node. " +
                                       "You can download the Elements node binaries from the " +
                                       "<style>a:link { color: " + Style.dyn.helpColor + "; }</style><a href=\"https://github.com/ElementsProject/elements/releases\">GitHub repository</a>.")

                        }
                    }
                }

                ColumnLayout {
                    id: setupConfig
                    spacing: 10

                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        CustLabel {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            horizontalAlignment: Qt.AlignHCenter
                            Layout.fillWidth: true

                            text: qsTr("Connection settings")
                            font.pixelSize: 30
                        }

                        Item { Layout.fillHeight: true }

                        RowLayout {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.margins: 20

                            GridLayout {
                                id: settingsContent

                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                                Layout.leftMargin: 20
                                Layout.rightMargin: 20

                                columnSpacing: 20
                                columns: 2

                                CustLabel { text: qsTr("Host"); Layout.alignment: Qt.AlignLeft; font.pixelSize: 18 }
                                CustTextInput {
                                    id : rpcHost
                                    Layout.preferredWidth: 220
                                    Layout.preferredHeight: 50
                                    underscore: true
                                    font.pixelSize: 18
                                    readOnly: root.nodeElementsLocal
                                    color: !readOnly ? Style.dyn.fontColor : Style.dyn.disabledFontColor
                                    showDecoration: true
                                    leftPadding: 20
                                    onTextEdited: root.failedConfig = false
                                }

                                CustLabel { text: qsTr("Port"); Layout.alignment: Qt.AlignLeft; font.pixelSize: 18 }
                                CustTextInput {
                                    id : rpcPort;
                                    Layout.preferredWidth: 220
                                    Layout.preferredHeight: 50
                                    showDecoration: true
                                    font.pixelSize: 18
                                    leftPadding: 20
                                    onTextEdited: root.failedConfig = false
                                }

                                CustLabel { text: qsTr("Login"); color: Style.dyn.disabledFontColor; Layout.alignment: Qt.AlignLeft; font.pixelSize: 18}
                                CustTextInput {
                                    id : rpcLogin;
                                    Layout.preferredWidth: 220
                                    Layout.preferredHeight: 50
                                    showDecoration: true
                                    font.pixelSize: 18
                                    leftPadding: 20
                                    onTextEdited: root.failedConfig = false
                                }

                                CustLabel { text: qsTr("Password"); color: Style.dyn.disabledFontColor; Layout.alignment: Qt.AlignLeft; font.pixelSize: 18 }
                                CustTextInput {
                                    id : rpcPassword
                                    Layout.preferredWidth: 220
                                    Layout.preferredHeight: 50
                                    showDecoration: true
                                    font.pixelSize: 18
                                    leftPadding: 20
                                    echoMode: TextInput.Password
                                    onTextEdited: root.failedConfig = false
                                }
                            }

                            RowLayout {
                                id: instruction

                                Layout.preferredHeight: 220
                                Layout.minimumHeight: 220
                                Layout.maximumHeight: 220
                                Layout.fillWidth: true
                                visible: root.failedConfig

                                Rectangle {
                                    id: frame
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    radius: 5

                                    border.width: 2
                                    border.color: Style.stat.critical
                                    color: Style.getShade("41")

                                    Item {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        clip: true

                                        Text {
                                            id: contentText
                                            y: -vbar.position * height
                                            width: parent.width
                                            height: implicitHeight
                                            elide: Text.ElideRight
                                            wrapMode: Text.WordWrap
                                            font.pixelSize: 16
                                            color: Style.dyn.fontColor
                                            padding: 20
                                            horizontalAlignment: Text.AlignLeft
                                            verticalAlignment: Text.AlignVCenter
                                            anchors.centerIn: vbar.size > 1 ? parent : undefined

                                            textFormat: Text.RichText

                                            property string networkIssue: qsTr("<h3 style=\"text-align: center\">Elements node offline</h3>" +
                                                   "<p>We cannot establish a network connection to your Elements node. Please ensure your node is running, is fully synced, and has the correct network parameters.</p>" +
                                                   "<p>Your configuration file (elements.conf) must contain the following: " +
                                                   "<style>a:link { color: " + Style.dyn.helpColor + "; }</style><a href=\"https://github.com/ElementsProject/elements/blob/master/share/examples/liquid.conf#L350\">server=1</a></p>")

                                            property string accessIssue: qsTr("<h3 style=\"text-align: center\">Authentication failed</h3>" +
                                                   "<p>The Elements node rejected our authentication request. Please ensure you have entered the correct username (login) and password.</p>")

                                            property string walletExists: qsTr("<h3 style=\"text-align: center\">Duplicate Elements node connection</h3>" +
                                                                              "<p>You already have an Elements node configured with these parameters.</p>")

                                            property string unknownError: qsTr("<h3>The Elements node return uknown error</h3>")
                                            onLinkActivated: Qt.openUrlExternally(link)
                                        }
                                    }


                                    MouseArea {
                                        anchors.fill: parent
                                        acceptedButtons: Qt.NoButton
                                        onWheel: if (vbar.size > 1)
                                                    return;
                                                 else if (wheel.angleDelta.y < 0)
                                                    vbar.increase()
                                                 else
                                                    vbar.decrease()
                                    }
                                }

                                CustHScrollBar {
                                    id: vbar
                                    baseColor: Style.getShade("3d")
                                    orientation: Qt.Vertical
                                    size: frame.height / contentText.height
                                    Layout.fillHeight: true
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }
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
                        if (root.nodeElementsLocal) {
                            rpcLogin.forceActiveFocus();
                        } else {
                            rpcHost.forceActiveFocus();
                            rpcHost.selectAll();
                        }
                    } else {
                        contentBackend.forceActiveFocus()
                    }
                }
            }

            CustSpinner {
                id: spinner
                anchors.centerIn: parent
                running: false;
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
            Layout.bottomMargin: 20
            Layout.leftMargin: 20
            Layout.rightMargin: 20

            spacing: 20

            Item { Layout.fillWidth: !cancelBtn.visible }

            CustShadow {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 50
                Layout.alignment: Qt.AlignRight
                visible: !root.accepted

                controlItem: CustButton {
                    id: cancelBtn
                    text: qsTr("CANCEL")


                    font.pixelSize: 18

                    implicitHeight: parent.height
                    implicitWidth: parent.width
                    baseColor: Style.getShade("66")
                    onClicked: root.close()
                }
            }

            Item { Layout.fillWidth: cancelBtn.visible }

            CustShadow {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 50
                Layout.alignment: Qt.AlignLeft
                visible: stackRoot.currentIndex !== 0 && !root.accepted

                controlItem: CustButton {
                    id: toPrevPage
                    text: qsTr("PREV")

                    font.pixelSize: 18

                    implicitHeight: parent.height
                    implicitWidth: parent.width
                    baseColor: toNextPage.visible ? Style.getShade("66") : Style.dyn.baseActive
                    onClicked: --stackRoot.currentIndex
                }
            }

            CustShadow {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 50
                Layout.alignment: Qt.AlignRight
                visible: stackRoot.currentIndex !== 2 || root.accepted

                controlItem:  CustButton {
                    id: toNextPage
                    text: if (stackRoot.currentIndex === 0)
                              qsTr("NEXT")
                          else if(root.accepted)
                              qsTr("DONE")
                          else
                              qsTr("APPLY")

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
                            root.failedConfig = false;

                            if (root.nodeElementsLocal) {
                                rpcHost.text = "localhost";
                                root.tryConfig();
                                return;
                            }
                        } else if (stackRoot.currentIndex === 1) {
                            root.failedConfig = false;
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
    }

    property var focusControl: undefined
    onAboutToShow: {
        spinner.running = false;
        accepted = false;
        contentBackend.forceActiveFocus();
    }

    onAboutToHide: {
        stackRoot.currentIndex = 0;
        rpcHost.text = "";
        rpcPort.text = "";
        rpcLogin.text = "";
        rpcPassword.text = "";
        mainContentItem.refreshFocus();
        spinner.running = false;
        accepted = false;
        root.failedConfig = false;
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
