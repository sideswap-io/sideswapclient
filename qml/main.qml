import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import Qt.labs.platform 1.1
import QtGraphicalEffects 1.12
import QtQuick.Window 2.13
import "./custom-elements"
import "./style"
import "./dialogs"

ApplicationWindow {
    id: mainWindow

    title: qsTr("SideSwap")
    visible: false

    minimumWidth: 800
    minimumHeight: 600

    background: LinearGradient {
        start: Qt.point(mainContentItem.x, mainContentItem.y + mainContentItem.height)
        end: Qt.point(mainContentItem.x + mainContentItem.width, mainContentItem.y)

        gradient: Gradient {
            GradientStop { position: 0.0; color: Style.getShade("22")}
            GradientStop { position: 1.0; color: Style.getShade("50") }
        }
    }

    readonly property int prefferedWidth: 1200
    readonly property int middleWidth: minimumWidth + ((prefferedWidth - minimumWidth) / 2)
    readonly property int prefferedHeight: 800
    readonly property int middleHeight: minimumHeight + ((prefferedHeight - minimumHeight) / 2)
    property double dynHeightMult: Math.min(1, (height - minimumHeight) / (prefferedHeight - minimumHeight))
    property double dynWidthMult: Math.min(1, (width - minimumWidth) / (prefferedWidth - minimumWidth))

    RowLayout {
        id: mainWindowLyt
        anchors.fill: parent
        spacing: 0

        SettingsDrawer {
            id: settings
            Layout.preferredHeight: mainWindow.height
            Layout.minimumWidth: 80
            Layout.maximumWidth: 240
            Layout.preferredWidth: collapsed
                                   ? Layout.minimumWidth
                                   : Layout.maximumWidth
        }

        ColumnLayout {
            id: contentLyt
            Layout.fillHeight: true
            Layout.fillWidth: true

            ApplicationContent {
                id: mainContentItem
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            StatusBar {
                id: statusBar
                Layout.fillWidth: true
            }
        }
    }

    Component.onCompleted: {
        if (Screen.width > prefferedWidth)
           width = prefferedWidth;
        else if (Screen.width > middleWidth)
           width = middleWidth;
        else
           width = minimumWidth;

        if (Screen.height > prefferedHeight)
            height = prefferedHeight;
        else if (Screen.height > middleHeight)
            height = middleHeight;
        else
            height = minimumHeight;

        x = Screen.virtualX + ((Screen.width < minimumWidth) ? 0 : (Screen.width - width) / 2);
        y = Screen.virtualY + ((Screen.height < minimumHeight) ? 0 : (Screen.height - height) / 2);
        mainWindow.visible = true

        // Workaround for "QSystemTrayIcon::setVisible: No Icon set" error (set icon first)
        trayIcon.icon.mask = false
        trayIcon.icon.source = "qrc:/assets/side_swap_logo.png"
        trayIcon.visible = true
    }

    TrayIcon {
        id: trayIcon
        visible: false
    }

    WizardAddWallet {
        id: walletWizard
        parent: mainWindowLyt
    }


    function showMessage(_message, _color) {
        statusBar.showMessage(_message, _color);
    }

    function showNotification(_title, _message) {
        // trayIcon.showMessage(mainWindow.title + " - " + _title, _message);
    }
}
