import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

ApplicationWindow {
    property alias detailPopup: second
    id:second
    width:640
    visible:true
    height: 480
    flags: Qt.FramelessWindowHint | Qt.Window
    property string content: ""
    x:Screen.desktopAvailableWidth - width -300
    y:0
    color: "#B6B0B0"
    Button {
        z:100001
        id:detailCloseBtn
        width: 19
        height: 19
        background: Image{
            source: detailCloseBtn.hovered ? "./icons/close-hover.svg" : "./icons/close.svg"
        }
        anchors{
            right: parent.right
            top: parent.top
            rightMargin: 10
            topMargin: 10

        }
        onClicked: second.close()
    }

    TextEdit {
        z:999999
        id:detailText
        anchors.fill:parent
        selectByMouse: true
        anchors{
            leftMargin: 30
            rightMargin: 30
            topMargin: 30
            bottomMargin: 50
        }

        width: 190
        wrapMode: TextEdit.Wrap
        readOnly: true
        text: content
        color: "black"
    }

}
