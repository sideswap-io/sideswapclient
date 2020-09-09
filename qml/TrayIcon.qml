import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import Qt.labs.platform 1.1
import QtGraphicalEffects 1.12
import "./custom-elements"
import "./style"

SystemTrayIcon {
    id: trayIcon
    
    icon {
        mask: true;
        source: "qrc:/assets/side_swap_logo.png";
    }
    
    menu: Menu {
        
        MenuItem {
            text: qsTr("Show")
            onTriggered: mainWindow.show()
        }
        
        MenuSeparator {}
        
        MenuItem {
            text: qsTr("Quit")
            onTriggered: Qt.quit()
        }
    }
}
