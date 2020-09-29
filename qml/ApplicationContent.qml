import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "./custom-elements"
import "./style"

Item {
    id: contentItemRoot

    property var tabs: [
        { "name" : qsTr("Peg In/Out"), "component" : "./tabs/PegContent.qml"      , "highlight" : false , "debugOnly" : false },
        { "name" : qsTr("Swap"),       "component" : "./tabs/SwapContent.qml"     , "highlight" : false , "debugOnly" : false },
        { "name" : qsTr("History"),    "component" : "./tabs/HistoryContent.qml"  , "highlight" : false , "debugOnly" : false },
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        anchors.bottomMargin: 10 + 10 * mainWindow.dynHeightMult

        CustBar {
            id: bar
            height: 30
            Layout.fillWidth: true

            model: tabs

            currentIndex: 0
        }

        StackLayout {
            id: content

            property var pages: []

            Layout.fillHeight: true
            Layout.fillWidth: true

            currentIndex: bar.currentIndex

            Repeater {
                model: tabs
                delegate: Loader {
                    source: modelData.component
                    onLoaded: {
                        item.tabName = modelData.name
                        item.tabIndex = model.index
                        content.pages.push(item)
                    }
                }
            }
        }
    }

    function goToPeg() {
        bar.currentIndex = 0
    }

    function goToSwap() {
        bar.currentIndex = 1
    }

    function goToHistory() {
        bar.currentIndex = 2
    }

    function goToDealig() {
        bar.currentIndex = 3
    }

    function setRequireToCheck(index, required) {
        bar.setRequireToCheck(index, required)
    }

    function refreshFocus() {
        content.pages[content.currentIndex].refreshFocus();
    }

}

