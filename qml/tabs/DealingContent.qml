import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../custom-elements"
import "../style"

TabBase {
    id: root

    property var assetsList: []
    property var availableAssets: []
    property var currentOrder: undefined

    property var rfq: undefined

    Connections {
        target: netManager

        onWalletInfoChanged: {
            const stateInfo = JSON.parse(data)

            if (stateInfo.balances) {
                const balanceInfo = JSON.parse(stateInfo.balances)
                let newList = {}
                for (let balance in balanceInfo) {
                    newList[root.getAppCurrency(balance)] = Number(balanceInfo[balance])
                }
                availableAssets = newList;
                updateAssetsList();
            }

//            dialog.visible = stateInfo.show_password_prompt

            if (root.rfq === undefined && stateInfo.status !== "OfferSent") {
                return;
            }

            switch (stateInfo.status) {
                case "OfferSent":
                    stackRoot.currentIndex = 2
                    root.rfq = stateInfo.rfq_offer;
                    break;
                case "WaitTxInfo":
                    stackRoot.currentIndex = 3
                    progressPsbtSign.value = 0;
                    break;
                case "WaitPsbt":
                    stackRoot.currentIndex = 3
                    progressPsbtSign.value = 0.5;
                    break;
                case "WaitSign":
                    stackRoot.currentIndex = 3
                    progressPsbtSign.value = 0.75;
                    break;
                case "Done":
                    stackRoot.currentIndex = 4
                    resultTx.text = stateInfo.tx_id
                    currentOrder = undefined;
                    root.rfq = undefined;
                    requiredToCheck = false;
                    break;
                case "Failed":
                    stackRoot.currentIndex = 0
                    currentOrder = undefined;
                    root.rfq = undefined;
                    requiredToCheck = false;
                    break;
                default:
                    console.log("unknown state: " + stateInfo.status)
                    break;
            }
        }

        onAssetsChanged: {
            const assetsInfo = JSON.parse(data);
            let fundedAssets = assetsInfo.assets;
            for (let i in fundedAssets) {
                let asset = fundedAssets[i];
                if (typeof availableAssets[asset.asset_id] === undefined) {
                    asset.amount = 0;
                } else {
                    asset.amount = availableAssets[asset.asset_id];
                }
            }
            assetsList = fundedAssets;
        }

        onUpdateOrders: {
            const orders = JSON.parse(data);
            if ( root.rfq !== undefined) {
                return;
            }
            if (orders.length === 0) {
                stackRoot.currentIndex = 0;
                currentOrder = undefined;
                requiredToCheck = false;
                return;
            }


            switch (orders[0].status) {
            case "OwnRfq": {
                stackRoot.currentIndex = 0;
            }
            break;
            default: {
                stackRoot.currentIndex = 1;
                currentOrder = orders[0];
                timer.start();
                requiredToCheck = true;
            }
            break;
            }
        }
    }

    SwipeView {
        id: stackRoot
        anchors.fill: parent
        currentIndex: 0
        anchors.margins: 10
        interactive: false
        clip: true

        ColumnLayout {
            id: initPage
            spacing: 5

            CustLabel {
                text: qsTr("No Orders available")
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                font.pixelSize: 20
            }

            Item {
                Layout.fillHeight: true
            }
        }

        ColumnLayout {
            id: rfqReply

            CustLabel {
                text: qsTr("Response RFQ")
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                font.pixelSize: 20
            }

            RowLayout {
                CustLabel {
                    text: qsTr("Receive :")
                    font.pixelSize: 20
                }

                CustLabel {
                    text: if (currentOrder !== undefined) qsTr("%1 %2")
                            .arg(fromSatoshi(currentOrder.rfq.sell_amount))
                            .arg(assetsNameByAssetId(currentOrder.rfq.buy_asset))
                          else ""

                    font.pixelSize: 20
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                CustLabel {
                    text: qsTr("Best quote :")
                    font.pixelSize: 20
                }

                CustLabel {
                    text: if (currentOrder !== undefined) qsTr("%1 %2")
                            .arg(fromSatoshi(currentOrder.top_bid))
                            .arg(assetsNameByAssetId(currentOrder.rfq.sell_asset))
                          else ""

                    font.pixelSize: 20
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                CustLabel {
                    text: qsTr("My last quote :")
                    font.pixelSize: 20
                }

                CustLabel {
                    text: if (currentOrder !== undefined) qsTr("%1 %2")
                            .arg(fromSatoshi(currentOrder.own_bid))
                            .arg(assetsNameByAssetId(currentOrder.rfq.sell_asset))
                          else ""

                    font.pixelSize: 20
                }

                Item {
                    Layout.fillWidth: true
                }
            }


            CustBalanceInput {
                id: proposal
                upperBound: 10000
            }

            CustProgressBar {
                id: progressQuote
                from: 0
                to: 1
                value: 0

                width: 400
            }

            Row {
                spacing: 10

                Layout.leftMargin: 45
                Layout.topMargin: 20

                CustButton {
                    text: qsTr("Apply")
                    width: 200
                    enabled: proposal.acceptableInput
                    onClicked: netManager.quoteRfq(currentOrder.order_id, Number(proposal.text) * 100000000)
                }

                CustButton {
                    text: qsTr("Cancel")
                    width: 200
                    enabled: currentOrder !== undefined && currentOrder.own_bid !== null
                    onClicked: netManager.cancelRfq(currentOrder.order_id)
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }

        ColumnLayout {
            id: swapOfferSent

            spacing: 5

            RowLayout {
                CustLabel {
                    text: qsTr("Send :")
                    font.pixelSize: 20
                }

                CustLabel {
                    text: if (rfq !== undefined ) qsTr("%1 %2")
                            .arg(fromSatoshi(rfq.sell_amount))
                            .arg(assetsNameByAssetId(rfq.sell_asset))
                          else ""

                    font.pixelSize: 20
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                CustLabel {
                    text: qsTr("Receive :")
                    font.pixelSize: 20
                }

                CustLabel {
                    text: if (rfq !== undefined ) qsTr("%1 %2")
                            .arg(fromSatoshi(rfq.buy_amount))
                            .arg(assetsNameByAssetId(rfq.buy_asset))
                          else ""

                    font.pixelSize: 20
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            Row {
                spacing: 10

                Layout.leftMargin: 45
                Layout.topMargin: 20

                CustButton {
                    text: progress.running ? qsTr("Cancel") : qsTr("Reject")
                    width: 200
                    onClicked:  netManager.swapCancel()
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }

        ColumnLayout {
            id: waitPsbt

            CustLabel {
                text: qsTr("Awaiting Psbt Signing")
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                font.pixelSize: 20
            }

            CustButton {
                text: qsTr("Cancel")
                width: 200
                onClicked: netManager.swapCancel()
            }

            CustProgressBar {
                id: progressPsbtSign
                from: 0
                to: 1
                value: 0
                width: 400
            }

            Item {
                Layout.fillHeight: true
            }
        }

        ColumnLayout {
            id: donePage
            spacing: 10

            RowLayout {
                id: txRow
                Layout.fillWidth: true
                height: 30

                spacing: 5

                CustLabel {
                    text: qsTr("Result transaction :")
                    horizontalAlignment: Qt.AlignHCenter
                    font.pixelSize: 20
                }

                CustLabel {
                    id: resultTx
                    horizontalAlignment: Qt.AlignHCenter
                    font.pixelSize: 20
                }

                CustIconButton {
                    source: "qrc:/assets/copy_action.png"
                    onClicked: {
                        resultTx.copy();
                    }
                }

                CustIconButton {
                    source: "qrc:/assets/redirect.png"
                    onClicked: {
                        let link = 'https://blockstream.info/liquid/tx/' + resultTx.text;
                        Qt.openUrlExternally(link);
                    }
                }
            }

            CustButton {
                Layout.topMargin: 20
                Layout.leftMargin: 20
                text: qsTr("Done")

                onClicked:  stackRoot.currentIndex = 0
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    Timer {
        id: timer
        interval: 25;
        running: false;
        repeat: true
        onTriggered: {
            if (currentOrder === undefined) {
                stop();
                return;
            }

            const current = new Date();
            const newValue = (current - currentOrder.created_at) / (currentOrder.expires_at - currentOrder.created_at);
            progressQuote.value = newValue;
            if (newValue > 1) stop();
        }
    }

//    Popup {
//        id: dialog
//        modal: true
//        parent: mainContentItem
//        visible: false

//        anchors.centerIn: parent
//        closePolicy: Popup.NoAutoClose

//        width: 430
//        height: 100

//        background: Rectangle {
//           anchors.fill: parent
//           color: "#3AA5BD"
//        }

//        contentItem: ColumnLayout {
//            id: bckgrnd

//            Item {

//                Layout.fillHeight: true
//                Layout.fillWidth: true

//                CustLabeledTextInput {
//                    id: encPassword

//                    anchors.centerIn: parent
//                    nameWidth: 200
//                    anchors.fill: parent
//                    description: qsTr("Enter encryption key :")
//                    font.pixelSize: 15
//                    echoMode: TextInput.Password
//                }
//            }

//            Row {

//                height: 30
//                Layout.fillWidth: true

//                spacing: 10
//                CustButton {
//                    text: qsTr("Cancel")
//                    width: 200
//                    onClicked: {
//                        netManager.cancelPassword()
//                    }
//                }

//                CustButton {
//                    text: qsTr("Accept")
//                    width: 200
//                    onClicked: {
//                        netManager.setPassword(encPassword.text)
//                    }
//                }
//            }

//        }

//        onAboutToShow: {
//            encPassword.contentItem.forceActiveFocus()
//        }
//    }


    function getAppCurrency(nodeCurrency) {
        return nodeCurrency === 'bitcoin' ? "L-BTC" : nodeCurrency
    }

    function toBitcoin(amount) {
        return (Number(amount) / 100000000).toString()
    }

    function getNodeCurrency(nodeCurrency) {
        return nodeCurrency === 'L-BTC' ? "b2e15d0d7a0c94e4e2ce0fe6e8691b9e451377f6e46e8045a86f7c4b5d4f0f23" : nodeCurrency
    }

    function assetsNameByAssetId(assetId) {
        for (let i in assetsList) {
            if (assetsList[i].asset_id === assetId) {
                return assetsList[i].ticker;
            }
        }
        return "";
    }

    function updateAssetsList() {
        let newAssetList = assetsList;
        for (let i in newAssetList) {
            let asset = newAssetList[i];
            if (typeof availableAssets[asset.asset_id] === undefined) {
                asset.amount = 0;
            } else {
                asset.amount = availableAssets[asset.asset_id];
            }
        }
        assetsList = newAssetList;
    }
}
