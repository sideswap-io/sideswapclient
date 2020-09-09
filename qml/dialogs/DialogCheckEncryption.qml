import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import "../custom-elements"
import "../style"

Popup {
    id: encDialog

    signal canceled()
    signal accepted(string passphrase)

    modal: true
    visible: false
    
    anchors.centerIn: parent
    closePolicy: Popup.NoAutoClose
    
    width: 500
    height: 400
    
    background: Rectangle {
        anchors.fill: parent
        color: Style.dyn.baseGrey
    }
    
    contentItem: ColumnLayout {
        spacing: 20
        
        CustIconButton {
            source: "qrc:/assets/close_cross.png"
            width: 20
            height: 20
            offset: 0
            showBckgrnd: false
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            
            onClicked: root.canceled()
        }
        
        CustLabel {
            id: header
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            text: qsTr("Enter your wallet passphrase")
            font.pixelSize: 30
        }
        
        CustPasswordInput {
            id: encPassword
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 60
            Layout.preferredWidth: header.width
            leftPadding: 20
            font.pixelSize: 20
            
            placeholderText: qsTr("Encryption key")
        }
        
        CustProgressBar {
            id: progressConfirm
            primaryColor: Style.getShade("3d")
            width: header.width
            from: 0
            to: 1
            value: 0
            Layout.alignment: Qt.AlignCenter
        }
        
        
        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            
            spacing: 20
            
            Item { Layout.fillWidth: true }
            
            CustButton {
                id: cancelPass
                Layout.preferredWidth: 120
                Layout.preferredHeight: 120
                
                radius: 120
                font.pixelSize: 18
                text: qsTr("CANCEL")
                borderOffset: 12
                baseColor: Style.dyn.baseGrey
                
                onClicked: root.canceled()
            }
            
            CustButton {
                id: acceptPass
                Layout.preferredWidth: 120
                Layout.preferredHeight: 120
                
                radius: 120
                font.pixelSize: 18
                text: qsTr("ACCEPT")
                borderOffset: 12
                baseColor: Style.dyn.baseActive
                

                onClicked: root.accepted(encPassword.text)
            }
            
            Item { Layout.fillWidth: true }
        }
        
        Keys.onPressed: {
            if (event.key !== Qt.Key_Enter && event.key !== Qt.Key_Return) {
                return;
            }
            acceptPass.clicked();
        }
        
    }
    
    onAboutToShow: {
        encPassword.clear();
        encPassword.forceActiveFocus()
    }
}
