import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../custom-elements"
import "../style"
import "../dialogs"

TabBase {
    id: root

    property var tabs: {
        "swapRequest" : 0,
        "awaitingQuote" : 1,
        "offerReview" : 2,
        "success" : 3,
    }

    property var selectedDelivery: assetsList.length === 0 ? undefined : assetsList[deliver.currentIndex]
    property bool hasDelivery: selectedDelivery !== undefined
    property var receivingList: []
    property var selectedReceive: receivingList.length === 0 ? undefined : receivingList[receive.currentIndex]

    property var assetsList: []
    property var availableAssets: []

    property var currentOrder: undefined
    property var rfq: undefined

    property int networkFee: 0
    property int serverFee: 0
    property bool bEmptyWalletConfig: true

    property string price
    property double deliverAmount

    property var sendAsset: undefined
    property var recvAsset: undefined

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
            }
            else {
                availableAssets = [];
            }

            if (stateInfo.price) {
                root.price = toPrice(stateInfo.price)
            } else {
                root.price = qsTr("Awaiting Quote")
            }
            if (stateInfo.deliver_amount) {
                root.deliverAmount = stateInfo.deliver_amount
            }

            updateAssetsList(assetsList)

            encDialog.visible = stateInfo.show_password_prompt

            if (root.rfq === undefined && stateInfo.status !== "ReviewOffer") {
                return;
            }

            switch (stateInfo.status) {
                case "ReviewOffer":
                    root.rfq = stateInfo.rfq_offer;
                    btnAcceptSwap.enabled = true;
                    update_fee(stateInfo);
                    changeTab(tabs.offerReview);
                    break;
                case "WaitPsbt":
                    break;
                case "WaitSign":
                    break;
                case "Done":
                    changeTab(tabs.success);
                    currentOrder = undefined;
                    root.rfq = undefined;
                    break;
                case "Failed":
                    changeTab(tabs.swapRequest);
                    currentOrder = undefined;
                    root.rfq = undefined;
                    if (encDialog.visible) encDialog.close()
                    break;
                default:
                    console.log("unknown state: " + stateInfo.status)
                    break;
            }

            btnAcceptSwap.enabled = !stateInfo.swap_in_progress
            btnRejectSwap.enabled = !stateInfo.swap_in_progress
        }

        onUpdateRfqClient: {
            const order = JSON.parse(data);
            if ( root.rfq !== undefined) {
                return;
            }

            switch (order.status) {
            case "Pending": {
                currentOrder = order;

                changeTab(tabs.awaitingQuote);
                timer.start();
            }
            break;
            case "Expired": {
                currentOrder = undefined;
                changeTab(tabs.swapRequest);
            }
            break;
            }
        }

        onAssetsChanged: {
            const assetsInfo = JSON.parse(data);
            updateAssetsList(assetsInfo.assets)
        }

        onUpdateWalletsList: {
            let wallets = JSON.parse(data).configs;
            bEmptyWalletConfig = (wallets.length === 0);
        }
    }

    SwipeView {
        id: stackRoot
        currentIndex: tabs.swapRequest
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
            id: swapRequest

            clip: true
            spacing: 5 + 15 * mainWindow.dynHeightMult

            Item { Layout.fillHeight: true }

            GridLayout {
                Layout.minimumWidth: 660
                Layout.maximumWidth: Layout.minimumWidth
                Layout.minimumHeight: 100
                Layout.maximumHeight: Layout.minimumHeight

                columns: 3
                rows: 2
                rowSpacing: 0

                Layout.alignment: Qt.AlignCenter

                CustLabel {
                    Layout.preferredHeight: 30 + 30 * mainWindow.dynHeightMult
                    Layout.fillWidth: true
                    font.pixelSize: 20
                    font.bold: false
                    text: qsTr("Send")
                    horizontalAlignment: Qt.AlignHCenter
                }

                Item { width: 40}

                CustLabel {
                    Layout.preferredHeight: 30 + 30 * mainWindow.dynHeightMult
                    Layout.fillWidth: true
                    font.pixelSize: 20
                    font.bold: false
                    text: qsTr("Receive")
                    horizontalAlignment: Qt.AlignHCenter
                }

                CustCombobox {
                    id: deliver
                    model: root.assetsList
                    Layout.preferredWidth: 280 + 20 * mainWindow.dynWidthMult
                    Layout.alignment: Qt.AlignRight
                    textRole: "ticker"
                    onCurrentIndexChanged: {
                        let newList = [];
                        for (const i in root.assetsList) {
                            if (Number(i) !== Number(currentIndex)) {
                                newList.push(root.assetsList[i]);
                            }
                        }
                        root.receivingList = newList;
                        amount.clear();
                    }
                }

                Item {
                    Layout.preferredWidth: 40
                    height: 40

                    CustIconButton {
                        anchors.centerIn: parent

                        width: 40
                        height: 40
                        offset: 10
                        showBckgrnd: false

                        source: "qrc:/assets/data_exchange_arrows.png"
                        onClicked: {
                            for (const i in root.assetsList) {
                                if (root.assetsList[i].ticker === selectedReceive.ticker) {
                                    deliver.currentIndex = i;
                                    break;
                                }
                            }
                        }
                    }
                }

                CustCombobox {
                    id: receive
                    model: root.receivingList
                    Layout.preferredWidth: 280 + 20 * mainWindow.dynWidthMult
                    Layout.alignment: Qt.AlignLeft
                    textRole: "ticker"
                }
            }

            Item { Layout.preferredHeight: 5 + 15 * mainWindow.dynHeightMult }

            Row {
                Layout.alignment: Qt.AlignCenter
                spacing: 10

                ColumnLayout {
                    width: 350

                    CustLabel {
                        text: qsTr("Amount")
                        Layout.leftMargin: 5
                        horizontalAlignment: Qt.AlignLeft
                        font.pixelSize: 16
                        Layout.fillWidth: parent.width
                    }

                    CustBalanceInput {
                        id: amount

                        Layout.preferredHeight: 50
                        Layout.fillWidth: parent.width

                        upperBound: root.hasDelivery?
                                        Number.fromLocaleString(Qt.locale(),
                                                                fromSatoshi(root.selectedDelivery.amount, root.selectedDelivery.precision))
                                      : 0

                        decimals: root.hasDelivery? root.selectedDelivery.precision : 0
                        leftPadding: 20

                        Image {
                            width: 20
                            height: 20
                            sourceSize.width:  width
                            sourceSize.height: height
                            anchors.right: parent.right
                            anchors.rightMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            source: root.hasDelivery ? "image://assets/" + selectedDelivery.asset_id : ""
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: parent.width
                        Layout.leftMargin: 5
                        Layout.rightMargin: 10

                        CustLabel {
                            text: qsTr("Available amount")
                            horizontalAlignment: Qt.AlignLeft
                            font.bold: false
                            font.pixelSize: 14
                            color: Style.dyn.disabledFontColor
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        CustLabel {
                            Layout.alignment: Qt.AlignRight
                            text: root.hasDelivery
                                  ? fromSatoshi(root.selectedDelivery.amount, root.selectedDelivery.precision) : ""
                            font.pixelSize: 14
                        }
                    }
                }

                CustButton {
                    id: apply
                    text: qsTr("MAX")
                    implicitHeight: 50
                    implicitWidth: 100
                    onClicked: amount.text = (root.hasDelivery && root.selectedDelivery.amount > 0)
                               ? fromSatoshi(root.selectedDelivery.amount, root.selectedDelivery.precision)
                               : "0";
                    baseColor: Style.dyn.helpColor
                    fontColor: "black"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item { Layout.preferredHeight: 5 + 15 * mainWindow.dynHeightMult }

            CustButton {
                id: startSwapButton
                Layout.preferredWidth: 120 + 30 * mainWindow.dynHeightMult
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignCenter

                radius: 150
                font.pixelSize: 20
                text: qsTr("Request")
                borderOffset: 12
                baseColor: Style.dyn.baseActive
                enabled: amount.acceptableInput && Number(amount.text) !== 0

                onClicked: {
                    let deliverAmount = fromSatoshi(root.selectedDelivery.amount, root.selectedDelivery.precision) === amount.text
                        ? root.selectedDelivery.amount
                        : formatString(amount.text);

                    root.sendAsset = assetsList[deliver.currentIndex]
                    root.recvAsset = receivingList[receive.currentIndex]
                    netManager.createRfq(selectedDelivery.asset_id,
                                            deliverAmount,
                                            selectedReceive.asset_id);
                }
            }

            Item { Layout.fillHeight: true }

            Keys.onPressed: {
                if (event.key !== Qt.Key_Enter && event.key !== Qt.Key_Return) {
                    return;
                }

                if (startSwapButton.enabled) {
                    startSwapButton.clicked();
                }
            }
        }

        ColumnLayout {
            id: rfqCreated

            clip: true
            spacing: 5 + 15 * mainWindow.dynHeightMult

            Item { Layout.fillHeight: true }

            CustLabel {
                text: qsTr("Best Quote")
                Layout.fillWidth: true
                font.pixelSize: 30
                horizontalAlignment: Qt.AlignHCenter
            }

            CustQuoteBoard {
                Layout.alignment: Qt.AlignCenter
                Layout.preferredHeight: 160 + 20 * mainWindow.dynHeightMult

                sourceIcon: (root.sendAsset !== undefined) ? "image://assets/" + root.sendAsset.asset_id : ""
                destIcon: (root.recvAsset !== undefined) ? "image://assets/" + root.recvAsset.asset_id : ""
                price: root.price
                deliver: if (root.sendAsset !== undefined && root.deliverAmount !== undefined)
                             qsTr("Deliver %1 %2")
                                .arg(fromSatoshi(root.deliverAmount, root.sendAsset.precision))
                                .arg(root.sendAsset.ticker)
                         else ""
                receive:  if (currentOrder !== undefined && Number(currentOrder.recv_amount) !== 0)
                              qsTr("Receive %1 %2")
                                .arg(fromSatoshi(currentOrder.recv_amount, root.recvAsset.precision))
                                .arg(root.recvAsset.ticker)
                          else qsTr("No quotes")
            }

            Rectangle {
                radius: 5
                width: 400
                height: 140
                Layout.alignment: Qt.AlignCenter

                color: Style.dyn.baseGrey

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 20

                    columns: 2
                    rows: 3
                    Repeater {
                        id: awaitingQuoteRep
                        delegate: CustLabel {
                            text: modelData
                            Layout.fillWidth: true
                            font.pixelSize: 18
                            font.bold: index % 2
                            horizontalAlignment: index % 2 ? Qt.AlignRight : Qt.AlignLeft
                        }
                    }
                }
            }

            CustProgressBar {
                id: progressRfq
                width: 400
                from: 0
                to: 1
                value: 0
                Layout.alignment: Qt.AlignCenter
            }

            CustButton {
                text: qsTr("Cancel")
                Layout.alignment: Qt.AlignCenter
                implicitHeight: 60
                implicitWidth: 180
                baseColor: Style.dyn.baseActive
                font.pixelSize: 18
                onClicked: netManager.cancelRfq()
            }

            Item { Layout.fillHeight: true }
        }

        ColumnLayout {
            id: swapOfferRecieve

            clip: true
            spacing: 5 + 15 * mainWindow.dynHeightMult

            Item { Layout.fillHeight: true }

            CustLabel {
                text: qsTr("Confirm swap")
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                font.pixelSize: 30
            }

            CustQuoteBoard {
                Layout.alignment: Qt.AlignCenter
                Layout.preferredHeight: 160 + 20 * mainWindow.dynHeightMult

                sourceIcon: (root.sendAsset !== undefined) ? "image://assets/" + root.sendAsset.asset_id : ""
                destIcon: (root.recvAsset !== undefined) ? "image://assets/" + root.recvAsset.asset_id : ""
                price: root.price
                deliver: if (rfq !== undefined )
                             qsTr("Deliver %1 %2")
                                .arg(fromSatoshi(rfq.swap.send_amount, root.sendAsset.precision))
                                .arg(assetsNameByAssetId(rfq.swap.send_asset))
                         else ""

                receive: if (rfq !== undefined )
                             qsTr("Receive %1 %2")
                                .arg(fromSatoshi(rfq.swap.recv_amount, root.recvAsset.precision))
                                .arg(assetsNameByAssetId(rfq.swap.recv_asset))
                         else ""
            }

            Rectangle {
                radius: 5
                Layout.preferredWidth: 400
                Layout.preferredHeight: 100 + 20 * mainWindow.dynHeightMult
                Layout.alignment: Qt.AlignCenter

                color: Style.dyn.baseGrey

                ColumnLayout {
                    anchors{
                        fill: parent
                        topMargin: 5 + 15 * mainWindow.dynHeightMult
                        bottomMargin: anchors.topMargin
                        leftMargin: 10 + 10 * mainWindow.dynWidthMult
                        rightMargin: anchors.leftMargin
                    }

                    CustLabel {
                        text: qsTr("Commission")
                        Layout.fillWidth: true
                        font.pixelSize: 18
                        horizontalAlignment: Qt.AlignHCenter
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        columns: 2
                        rows: 2

                        Repeater {
                            id: awaitingAcceptRep
                            delegate: CustLabel {
                                text: modelData
                                Layout.fillWidth: true
                                font.pixelSize: 18
                                font.bold: index % 2
                                horizontalAlignment: index % 2 ? Qt.AlignRight : Qt.AlignLeft
                            }
                        }
                    }
                }
            }

            CustProgressBar {
                id: progressSigning
                width: 400
                from: 0
                to: 1
                value: 0
                Layout.alignment: Qt.AlignCenter
            }

            RowLayout {
                id: btns
                property double preferredSize: Math.min(mainWindow.dynHeightMult, mainWindow.dynWidthMult)

                spacing: 20
                Layout.alignment: Qt.AlignCenter

                CustRectButton {
                    id: btnRejectSwap
                    Layout.preferredWidth: 190
                    Layout.preferredHeight: 120 + 40 * btns.preferredSize
                    iconSize: 60 + 20 * btns.preferredSize

                    source: "qrc:/assets/close_cross.png"
                    text:  qsTr("Reject")

                    onClicked:  netManager.swapCancel()
                }

                CustRectButton {
                    id: btnAcceptSwap
                    Layout.preferredWidth: 190
                    Layout.preferredHeight: 120 + 40 * btns.preferredSize
                    iconSize: 60 + 20 * btns.preferredSize

                    source: "qrc:/assets/data_exchange_arrows.png"
                    text:  qsTr("Swap")

                    onClicked: {
                        btnAcceptSwap.enabled = false;
                        netManager.swapAccept()
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }

        ColumnLayout {
            id: successPage
            clip: true

            CustSuccessPage {
                Layout.alignment: Qt.AlignCenter

                header: qsTr("Swap completed")
                onBackClicked: changeTab(tabs.swapRequest);
            }
        }

        Item{}

        onVisibleChanged: {
            if (!visible) {
                return;
            }

            if (currentIndex === tabs.swapRequest)
                amount.forceActiveFocus();
            else if (currentIndex === tabs.success) {
                root.changeTab(tabs.swapRequest)
            }

            if (root.bEmptyWalletConfig && settingsHelper.showWizard)
                addWallet.open();
            settingsHelper.showWizard = false;
        }
        Component.onCompleted: amount.forceActiveFocus();
    }

    onEnsureFocus: amount.forceActiveFocus();

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

            if (root.rfq !== undefined) {
                progressSigning.from = 0
                progressSigning.to = root.rfq.expires_at - root.rfq.created_at
                progressSigning.value = new Date() - root.rfq.created_at;
                if (encDialog.visible) {
                    encDialog.progress.from = progressSigning.from
                    encDialog.progress.to = progressSigning.to
                    encDialog.progress.value = progressSigning.value
                }
                if (progressSigning.value >= progressSigning.to) stop();
            } else if (currentOrder !== undefined) {
                progressRfq.from = 0
                progressRfq.to = currentOrder.expires_at - currentOrder.created_at
                progressRfq.value = new Date() - currentOrder.created_at;
                if (progressRfq.value >= progressRfq.to) stop();
            } else {
                stop();
            }
        }
    }

    DialogCheckEncryption {
        id: encDialog
        parent: mainContentItem

        onAccepted: netManager.setPassword(passphrase);
        onCanceled: netManager.cancelPassword();
    }

    DialogBubble {
        id: addWallet

        property int index: -1
        property bool activateAction: true

        highlightCancel: false
        bubbleMode: false
        parent: contentLyt
        content: {
            "msg_type": "Question",
            "title" : qsTr("Connect your wallet"),
            "msg" : qsTr("To conduct swaps, you need to setup your liquid wallet. Do you wish to do so now?")
        }

        onCanceled: close()
        onAccepted: {
            close();
            walletWizard.open();
        }
    }

    function getAppCurrency(nodeCurrency) {
        return nodeCurrency === 'bitcoin' ? "L-BTC" : nodeCurrency
    }

    function assetsNameByAssetId(assetId) {
        for (let i in assetsList) {
            if (assetsList[i].asset_id === assetId) {
                return assetsList[i].ticker;
            }
        }
        return "";
    }

    function updateAssetsList(assets) {
        let fundedAssets = assets;
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

    function update_fee(stateInfo) {
        root.networkFee = Number(stateInfo.network_fee)
        root.serverFee = Number(stateInfo.server_fee)
    }

    function changeTab(newIndex) {
        let oldIndex = stackRoot.currentIndex;

        if (newIndex === oldIndex) {
            return;
        }

        stackRoot.currentIndex = newIndex;

        if (newIndex === 0) {
            amount.clear();
            amount.forceActiveFocus();
        } else if (newIndex === 1) {
            let swapInfo = qsTr("L-BTC / %2")
            .arg(root.selectedDelivery.ticker === "L-BTC"
                 ? root.selectedReceive.ticker
                 : root.selectedDelivery.ticker)
            awaitingQuoteRep.model = [
                "Swap",
                swapInfo,
                "Sell",
                root.selectedDelivery.ticker,
                "Quantity",
                amount.text
            ]
        } else if (newIndex === 2) {
            awaitingAcceptRep.model = [
                "Swap fee",
                qsTr("%1 L-BTC").arg(fromSatoshi(serverFee, 8)),
                "Transaction fee",
                qsTr("%1 L-BTC").arg(fromSatoshi(networkFee, 8))
            ]
        }
    }
}
