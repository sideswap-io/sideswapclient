import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../custom-elements"
import "../style"

TabBase {
    id: root

    property var tabs: {
        "pegRequest" : 0,
        "pegResponse" : 1,
        "success" : 2,
    }

    property bool isPegIn
    property bool enablePeg: receiveAddress.address.length !== 0
    property string peginPrev: ""
    property string pegoutPrev: ""
    property double minimumPegin: 0.0
    property double minimumPegout: 0.0
    property string percentPegin: ""
    property string percentPegout: ""

    onIsPegInChanged: {
        if (isPegIn) {
            pegoutPrev = enablePeg ? receiveAddress.address : "";
            receiveAddress.setInput(peginPrev);
        } else {
            peginPrev = enablePeg ? receiveAddress.address : "";
            receiveAddress.setInput(pegoutPrev);
        }
        receiveAddress.forceActiveFocus();
    }

    Connections {
        target: netManager

        onStateChanged: {
            var state = JSON.parse(data)
            root.isPegIn = state.pegin
            spinner.running = (state.status === "Waiting")
            switch (state.status) {
                case "Idle":
                    root.changeTab(tabs.pegRequest)
                    break;
                case "Waiting":
                    root.changeTab(tabs.pegRequest)
                    break;
                case "Active":
                    root.changeTab(tabs.pegResponse)
                    returnAddress.text = state.peg_addr
                    break;
                default:
                    console.log("unexpected status: " + state.status)
            }
            root.minimumPegin = state.min_pegin_amount / 100000000
            root.minimumPegout = state.min_pegout_amount / 100000000
            root.percentPegin = (100 - state.server_fee_percent_peg_in)
            root.percentPegout = (100 - state.server_fee_percent_peg_out)
        }

        onHistoryChanged: {
            if (stackRoot.currentIndex === tabs.pegResponse) {
                const hist = JSON.parse(data).orders.reverse();
                const last = hist[0];
                if (last.data.Peg !== undefined && returnAddress.text === last.data.Peg.peg_addr
                        && receiveAddress.address === last.data.Peg.own_addr
                        && ("Pending" !== last.data.Peg.status && !last.data.Peg.status.startsWith("Loading"))) {
                    root.changeTab(tabs.success)
                }
            }
        }
    }

    SwipeView {
        id: stackRoot
        currentIndex: tabs.pegRequest
        anchors{
            fill: parent
            topMargin: 20 + 20 * mainWindow.dynHeightMult
            bottomMargin: 10 + 20 * mainWindow.dynHeightMult
            leftMargin: 20 + 20 * mainWindow.dynWidthMult
            rightMargin: anchors.leftMargin
        }
        interactive: false
        clip: true

        ColumnLayout {
            id: requestPage
            clip: true

            ColumnLayout {
                Layout.maximumHeight: 700

                spacing: 10 + 10 * mainWindow.dynHeightMult
                Layout.alignment: Qt.AlignCenter

                GridLayout {
                    Layout.minimumHeight: 125
                    Layout.maximumHeight: 250

                    columns: 3
                    rows: 2

                    Layout.alignment: Qt.AlignCenter

                    CustLabel {
                        Layout.columnSpan: 2
                        Layout.preferredHeight: 30 + 30 * mainWindow.dynHeightMult
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        font.pixelSize: 20
                        font.bold: false
                        text: qsTr("Deliver")
                    }

                    CustLabel {
                        Layout.preferredHeight: 30 + 30 * mainWindow.dynHeightMult
                        font.pixelSize: 20
                        font.bold: false
                        text: qsTr("Receive")
                    }

                    CustPegElement {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 120
                        Layout.maximumHeight: 165
                        Layout.preferredWidth: 280 + 37 * dynWidthMult

                        currency: root.isPegIn ? "BTC" : "L-BTC"
                        icon: root.isPegIn
                                 ? "qrc:/assets/btc_icon.png"
                                 : "qrc:/assets/lbtc_icon.png"

                        subHeader: qsTr("Min amount: ")
                        amount: qsTr("%1 %2")
                                 .arg(root.isPegIn
                                    ? Number(root.minimumPegin).toFixed(8)
                                    : Number(root.minimumPegout).toFixed(8))
                                 .arg(currency)

                        onClicked: netManager.toggle()
                    }

                    Item {
                        Layout.preferredWidth: 66
                        Layout.fillHeight: true

                        CustIconButton {
                            anchors.centerIn: parent

                            width: 40
                            height: 40
                            offset: 0
                            showBckgrnd: false

                            source: "qrc:/assets/data_exchange_arrows.png"
                            onClicked: netManager.toggle()
                        }

                    }

                    CustPegElement {
                        Layout.fillHeight: true
                        Layout.minimumHeight: 120
                        Layout.maximumHeight: 165
                        Layout.preferredWidth: 280 + 37 * dynWidthMult

                        currency: !root.isPegIn ? "BTC" : "L-BTC"
                        icon: !root.isPegIn
                                 ? "qrc:/assets/btc_icon.png"
                                 : "qrc:/assets/lbtc_icon.png"

                        subHeader: qsTr("Conversation rate:")
                        amount: qsTr("%1%")
                                    .arg(root.isPegIn ? root.percentPegin : root.percentPegout)
                        onClicked: netManager.toggle()
                    }
                }

                Item {
                    Layout.maximumHeight: 5 + 15 * mainWindow.dynHeightMult
                    Layout.alignment: Qt.AlignCenter
                }

                CustLabel {
                    Layout.preferredWidth: 370
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignCenter
                    horizontalAlignment: Qt.AlignCenter
                    font.pixelSize: 30
                    text: qsTr("Your %1 receiving address")
                            .arg(root.isPegIn ? qsTr("L-BTC") : qsTr("BTC"))
                }

                CustAddressInput {
                    id: receiveAddress
                    Layout.preferredWidth: 600 + 80 * dynWidthMult
                    Layout.preferredHeight: 50 + 20 * mainWindow.dynHeightMult
                    Layout.alignment: Qt.AlignCenter
                    liquidCheck: root.isPegIn
                    placeholderText: qsTr("Insert your %1 receiving address here")
                                        .arg(root.isPegIn ? qsTr("L-BTC") : qsTr("BTC"))
                }

                CustButton {
                    id: startPegButton
                    Layout.preferredWidth: 120 + 30 * mainWindow.dynHeightMult
                    Layout.preferredHeight: Layout.preferredWidth
                    Layout.alignment: Qt.AlignCenter

                    radius: 150
                    font.pixelSize: 20
                    text: root.isPegIn ? qsTr("PEG IN") : qsTr("PEG OUT")
                    borderOffset: 12
                    baseColor: Style.dyn.baseActive
                    enabled: root.enablePeg

                    onClicked: netManager.startPeg(receiveAddress.address)
                }

            }


            Keys.onPressed: {
                if (event.key !== Qt.Key_Enter && event.key !== Qt.Key_Return) {
                    return;
                }

                if (startPegButton.enabled) {
                    startPegButton.clicked();
                }
            }
        }

        ColumnLayout {
            id: responsePage
            clip: true

            ColumnLayout {
                Layout.maximumHeight: 650

                spacing: 10 + 10 * mainWindow.dynHeightMult
                Layout.alignment: Qt.AlignCenter

                CustLabel {
                    Layout.preferredWidth: 270
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignCenter
                    horizontalAlignment: Qt.AlignCenter
                    font.pixelSize: 30
                    text: qsTr("Send to address")
                }

                CustQrCode {
                    id: qrCode

                    Layout.alignment: Qt.AlignCenter

                    Layout.preferredHeight: 200 + 70 * Math.min(mainWindow.dynHeightMult, mainWindow.dynWidthMult)
                    Layout.preferredWidth: Layout.preferredHeight

                    function fillQr() {
                        let res = addrHelper.getScan(returnAddress.text)
                        let stringList = res.split("\n");
                        qrCode.processData(stringList.length, stringList.join('').split(''))
                    }
                }

                CustAddressInput {
                    id: returnAddress
                    Layout.preferredWidth: 600 + 80 * mainWindow.dynWidthMult
                    Layout.preferredHeight: 50 + 20 * mainWindow.dynHeightMult
                    Layout.alignment: Qt.AlignCenter
                    horizontalAlignment: Qt.AlignHCenter
                    readOnly: true
                    font.pixelSize: 15
                    leftPadding: 0

                    onTextChanged: qrCode.fillQr()
                }

                RowLayout {
                    id: btns
                    property double preferredSize: Math.min(mainWindow.dynHeightMult, mainWindow.dynWidthMult)

                    Layout.alignment: Qt.AlignCenter
                    spacing: 20

                    CustRectButton {
                        Layout.preferredWidth: 190
                        Layout.preferredHeight: 120 + 40 * btns.preferredSize
                        iconSize: 60 + 20 * btns.preferredSize

                        source: "qrc:/assets/copy_action.png"
                        text: qsTr("Copy")

                        onClicked: {
                            clipboardHelper.copy(returnAddress.text);
                        }
                    }

                    CustRectButton {
                        Layout.preferredWidth: 190
                        Layout.preferredHeight: 120 + 40 * btns.preferredSize
                        iconSize: 60 + 20 * btns.preferredSize

                        source: "qrc:/assets/back_action.png"
                        text: qsTr("Back")

                        onClicked: netManager.pegBack()
                    }
                }
            }
        }

        ColumnLayout {
            id: successPage
            clip: true

            CustSuccessPage {
                Layout.alignment: Qt.AlignCenter

                header: qsTr("Transaction detected")
                onBackClicked: netManager.pegBack()
            }
        }

        Item {}

        onVisibleChanged: {
            if (currentIndex === tabs.pegRequest) {
                receiveAddress.forceActiveFocus();
            } else if (currentIndex === tabs.success) {
                root.changeTab(tabs.pegRequest)
            }
        }
        Component.onCompleted: receiveAddress.forceActiveFocus();
    }

    onEnsureFocus: receiveAddress.forceActiveFocus();

    BusyIndicator {
        id: spinner
        anchors.centerIn: parent
        running: false;
    }

    function changeTab(newIndex) {
        let oldIndex = stackRoot.currentIndex;

        if (newIndex === oldIndex) {
            return;
        }

        stackRoot.currentIndex = newIndex;

        if (newIndex === tabs.pegRequest) {
            receiveAddress.clearInput()
            receiveAddress.forceActiveFocus();
        }
    }
}
