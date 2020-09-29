import QtQuick 2.11
import QtQuick.Controls 2.12

Item {
    id: pegContent

    property string tabName: ""
    property int tabIndex: -1
    property bool requiredToCheck: false

    signal ensureFocus();

    function showMessage(_message, _color) {
        mainWindow.showMessage(_message, _color);
    }

    function showNotification(_title, _message) {
        mainWindow.showNotification(tabName + " - " + _title, _message);
    }

    function fromSatoshi(n, precision) {
        return formatNumber(Number(n / 100000000), precision);
    }

    function toPrice(n) {
        return Number(n).toLocaleString(Qt.locale(), 'f', 2);
    }

    function formatNumber(n, precision) {
        const answ = isNaN(n) ? 0 : n;
        return Number(answ).toLocaleString(Qt.locale(), 'f', precision);
    }

    function formatString(str) {
        return Number.fromLocaleString(Qt.locale(), str) * 100000000;
    }

    function refreshFocus() {
        pegContent.ensureFocus();
    }

    onRequiredToCheckChanged: {
        if (!visible && requiredToCheck)
            contentItemRoot.setRequireToCheck(tabIndex, true);
        else
            contentItemRoot.setRequireToCheck(tabIndex, false);
    }

    onVisibleChanged: {
        if (visible)
            requiredToCheck = false;
    }
}
