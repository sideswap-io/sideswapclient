import QtQuick 2.12
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import Qt.labs.qmlmodels 1.0
import "../custom-elements"
import "../style"

TabBase {
    id: root

    property var assetsList: ({})
    property var historyModel: null
    property var columns: [
        { "id" : "icons" , "label" : "", "width" : 170},
        { "id" : "created_at" , "label" : qsTr("Date"), "width" : 135},
        { "id" : "pegin" , "label" : qsTr("Type"), "width" : 135},
        { "id" : "amount" , "label" : qsTr("Amount"), "width" : 135},
        { "id" : "status" , "label" : qsTr("Status"), "width" : 135},
        { "id" : "expand" , "label" : qsTr("More"), "width" : 135},
    ]
    property int minimumWidth: 0

    Component.onCompleted: {
        for (let i in columns) {
            minimumWidth += columns[i].width;
        }
    }

    Connections {
        target: netManager
        onHistoryChanged: {
            root.historyModel = JSON.parse(data).orders.reverse()
            if (root.historyModel.length !== 0 && stackRoot.currentItem !== historyContent) {
                stackRoot.push(historyContent);
            }
        }

        onAssetsChanged: {
            let assetsMap = ({});
            const assetsInfo = JSON.parse(data).assets;
            for (let i in assetsInfo) {
                let asset = assetsInfo[i];
                assetsMap[asset.asset_id] = asset;
            }
            assetsList = assetsMap;
        }
    }

    ColumnLayout {
        anchors.fill: parent

        StackView {
            id: stackRoot

            Layout.fillHeight: true
            Layout.fillWidth: true
            initialItem: emptyHistory
            clip: true

            Item {
                id: emptyHistory
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 50

                    anchors.centerIn: parent
                    anchors.margins: 40

                    width: 320
                    height: implicitHeight

                    CustLabel {
                        id: headerItem
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        Layout.alignment: Qt.AlignCenter
                        horizontalAlignment: Qt.AlignCenter
                        font.pixelSize: 28
                        wrapMode: Text.WordWrap
                        text: qsTr("You haven't completed any swaps yet")
                    }

                    CustRoundIcon {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        source: "qrc:/assets/empty_history.png"
                    }

                    CustButton {
                        text: qsTr("GO TO SWAP")
                        Layout.alignment: Qt.AlignCenter
                        implicitHeight: 60
                        implicitWidth: 220
                        baseColor: Style.dyn.baseActive
                        font.pixelSize: 18
                        onClicked: contentItemRoot.goToSwap()
                    }
                }
            }

            ColumnLayout {
                id: historyContent
                x: -hbar.position * root.minimumWidth
                spacing: 5
                visible: stackRoot.currentItem === historyContent

                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    id: histHeader

                    Layout.topMargin: 40
                    Layout.preferredHeight: 30
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 0

                    Repeater {
                        model: columns
                        delegate: CustTextDelegate {
                            height: parent.height
                            Layout.minimumWidth: modelData.width
                            Layout.fillWidth: true
                            color: Style.dyn.disabledFontColor
                            text: modelData.label
                        }
                    }
                }

                ListView {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    spacing: 15
                    headerPositioning: ListView.OverlayHeader
                    snapMode: ListView.SnapToItem

                    model: root.historyModel
                    clip: true

                    delegate: Rectangle {
                        id: delegateRoot
                        height: 80 + (!expanded ? 0 : 200)
                        width: parent.width
                        property bool expanded: false
                        property color baseColor: Style.dyn.baseGrey

                        property bool isPegEntry: modelData.data.Peg !== undefined
                        property var rowData: isPegEntry ? modelData.data.Peg : modelData.data.Swap

                        onRowDataChanged: {
                            if (isPegEntry) {
                                const isPegin = rowData.pegin;
                                sourceIcon.source = isPegin
                                        ? "qrc:/assets/btc_icon.png"
                                        : "qrc:/assets/lbtc_icon.png";

                                destIcon.source = !isPegin
                                        ? "qrc:/assets/btc_icon.png"
                                        : "qrc:/assets/lbtc_icon.png";

                                typeDelegate.text = isPegin
                                        ? qsTr("Peg-In")
                                        : qsTr("Peg-Out")

                                amountDelegate.text = rowData.amount === 0
                                        ? qsTr("Pending")
                                        : ((Number(rowData.amount) / 100000000).toString()
                                                                + (isPegin ? ' BTC' : ' L-BTC'));

                                statusDelegate.text = rowData.status

                                expandingDataContra.header = isPegin ? "BTC" : "L-BTC"
                                expandingDataContra.content = rowData.peg_addr


                                expandingDataOwn.header = !isPegin ? "BTC" : "L-BTC"
                                expandingDataOwn.content = rowData.own_addr
                            } else {
                                const sell_asset = assetsList[rowData.sell_asset];
                                const buy_asset = assetsList[rowData.buy_asset];
                                const isSoldLBTC = sell_asset.ticker === "L-BTC"

                                sourceIcon.source = "data:image/png;base64," + sell_asset.icon;
                                destIcon.source = "data:image/png;base64," + buy_asset.icon;

                                typeDelegate.text = qsTr("Swap")

                                amountDelegate.text = String("%1 %2")
                                                            .arg(fromSatoshi(rowData.buy_amount, buy_asset.precision))
                                                            .arg(buy_asset.ticker);

                                statusDelegate.text = rowData.status;

                                expandingDataContra.header = qsTr("Transaction Info")
                                const noTxInfo = rowData.txid === null;
                                expandingDataContra.content = noTxInfo ? qsTr("No transaction info") : rowData.txid
                                expandingDataContra.showCopyAction = !noTxInfo
                                expandingDataContra.showRedirectAction = !noTxInfo

                                let price = "";
                                let amountOwn = "";
                                let currOwn = "";
                                let amountContra = "";
                                let currContra = "";

                                if (isSoldLBTC) {
                                    price = toPrice(Number(rowData.buy_amount) / Number(rowData.sell_amount));

                                    amountOwn = fromSatoshi(-1 * Number(rowData.sell_amount), sell_asset.precision);
                                    currOwn = sell_asset.ticker;

                                    amountContra = fromSatoshi(rowData.buy_amount, buy_asset.precision);
                                    currContra = buy_asset.ticker

                                } else {
                                    price = toPrice(Number(rowData.sell_amount) / Number(rowData.buy_amount));

                                    amountOwn = fromSatoshi(rowData.buy_amount, buy_asset.precision);
                                    currOwn = buy_asset.ticker;

                                    amountContra = fromSatoshi(-1 * Number(rowData.sell_amount), sell_asset.precision);
                                    currContra = sell_asset.ticker;
                                }

                                expandingDataOwn.rowModel = [
                                        { "header" : qsTr("Price"),  "content" : price          },
                                        { "header" : currOwn,        "content" : amountOwn      },
                                        { "header" : currContra,     "content" : amountContra   }
                                    ]
                            }
                        }

                        color : if (rowMouseArea.containsPress)
                                       return Qt.tint(baseColor, Style.stat.fullToneShader)
                                   else if (rowMouseArea.containsMouse)
                                       return Qt.tint(baseColor, Style.stat.halfToneShader)
                                   else
                                       return baseColor

                        radius: 5
                        clip: true

                        GridLayout {
                            id: staticData
                            anchors.fill: parent

                            rows: 3
                            columns: 6
                            rowSpacing: 0
                            columnSpacing: 0

                            Item {
                                id: icons
                                height: parent.height
                                Layout.minimumWidth: columns[0].width
                                Layout.alignment: Qt.AlignLeft
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 10

                                    Image {
                                        id: sourceIcon
                                        width: 40
                                        height: 40
                                        sourceSize.width:  width
                                        sourceSize.height: height
                                        Layout.alignment: Qt.AlignCenter
                                    }

                                    Image {
                                        id: exchangeIcon
                                        width: 15
                                        height: 15
                                        sourceSize.width:  width
                                        sourceSize.height: height
                                        Layout.alignment: Qt.AlignCenter

                                        source: "qrc:/assets/data_exchange_arrows.png"
                                    }

                                    Image {
                                        id: destIcon
                                        width: 40
                                        height: 40
                                        sourceSize.width:  width
                                        sourceSize.height: height
                                        Layout.alignment: Qt.AlignCenter
                                    }
                                }
                            }

                            CustTextDelegate {
                                id: dateDelegate
                                height: parent.height
                                Layout.minimumWidth: columns[1].width
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                color: Style.dyn.fontColor
                                text: Qt.formatDate(new Date(modelData.created_at), "yyyy-MM-dd")
                            }

                            CustTextDelegate {
                                id: typeDelegate
                                height: parent.height
                                Layout.minimumWidth: columns[2].width
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                color: Style.dyn.fontColor
                            }

                            CustTextDelegate {
                                id: amountDelegate
                                height: parent.height
                                Layout.minimumWidth: columns[3].width
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                color: Style.dyn.fontColor
                            }

                            CustStatusDelegate {
                                id: statusDelegate
                                height: parent.height
                                Layout.minimumWidth: columns[4].width
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Item {
                                id: expandCollapse

                                height: parent.height
                                Layout.minimumWidth: columns[5].width
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter

                                CustIconButton {
                                    width: 20
                                    height: 20
                                    offset: 0
                                    showBckgrnd: false
                                    anchors.centerIn: parent

                                    source: delegateRoot.expanded
                                                ? "qrc:/assets/collapse_arrow.png"
                                                : "qrc:/assets/expand_arrow.png"
                                    onClicked: delegateRoot.expanded = !delegateRoot.expanded
                                }

                            }

                            CustExpDelegate {
                                id: expandingDataContra
                                Layout.columnSpan: 6
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Layout.maximumHeight: 100
                                visible: delegateRoot.expanded

                                onCopyClicked: root.copyAddr(content)
                                onRedirectClicked: root.redirect(delegateRoot.isPegEntry, rowData, content)
                            }

                            CustExpDelegate {
                                id: expandingDataOwn
                                Layout.columnSpan: 6
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Layout.maximumHeight: 100
                                visible: delegateRoot.expanded
                                expandRow: !delegateRoot.isPegEntry

                                showCopyAction: delegateRoot.isPegEntry
                                showRedirectAction: delegateRoot.isPegEntry
                                onCopyClicked: root.copyAddr(content)
                                onRedirectClicked: root.redirect(delegateRoot.isPegEntry, rowData, content)
                            }
                        }

                        MouseArea {
                            id: rowMouseArea
                            anchors.top: parent.top
                            width: parent.width
                            height: 80
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: delegateRoot.expanded = !delegateRoot.expanded
                        }
                    }
                }
            }
        }

        CustHScrollBar {
            id: hbar
            Layout.fillWidth: true
            Layout.preferredHeight: 10
            size: stackRoot.currentItem === emptyHistory ? 1 : root.width / root.minimumWidth

            Connections {
                target: root
                onWidthChanged: hbar.position = 0;
            }
        }
    }

    function copyAddr(addr) {
       clipboardHelper.copy(addr);
    }

    function redirect(isPeg, rowData, addr) {
        var link = 'https://blockstream.info/';
        if (isPeg) {
            if (rowData.pegin) { link += 'liquid/'; }
            link += 'address/';
            link += addr;
        } else {
            if (rowData.status === "Failed") {
                return;
            }

            link += 'liquid/tx/' + rowData.txid;
        }

        Qt.openUrlExternally(link);
    }
}
