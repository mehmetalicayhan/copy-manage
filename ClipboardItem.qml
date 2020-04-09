import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
Rectangle{
    id:contentCover
    width: 370
    height: 200
    layer.enabled: true
    layer.effect: DropShadow {
        id: effect
        horizontalOffset: 3
        verticalOffset: 3
        samples: 16
        radius: 10
        smooth: true

    }
    color: Qt.rgba(40,40,40,0.6)
    radius: 4
    property alias clipboardItem:clipboardItemText


    //color: "white"

    Popup {
        id: popup
        background:Rectangle{
            color: Qt.rgba(40,40,40,0.6)
            id:popupRect
            anchors.fill: parent
            radius: 10
            Image{
                id:popupImg
                anchors{
                    centerIn: parent
                }

                source: "./icons/checked.svg"
                width: 70
                height:70
            }
        }

        width: contentCover.width
        height: contentCover.height
        modal: true
        focus: true


        MouseArea{
            anchors.fill: parent
            onClicked: popup.close()
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
        }

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }



    Button{
        z:10000
        width: 25
        height: 25
        anchors{
            right: parent.right
            top: parent.top
        }

        anchors.rightMargin: 5
        anchors.topMargin: 5

        id:copyButton
        background:Item{
            width: 25
            height: 25
            Image{
                id:image
                source: copyButton.hovered ? "./icons/copy-hover.svg" : "./icons/copy.svg"
                width: 15
                height: 15
                anchors.centerIn: parent

            }
            //radius: 8
            //color: copyButton.hovered ? "#ccc" : "white"
        }

        onClicked:{
            clipboard.setClipboardData(clipboardItemText.text)
            popup.open()
        }

    }

    Button{


        id: detailButton
        property bool isClicked: true
        z:100001
        width: 25
        height: 25
        visible: contentCover.height<clipboardItemText.contentHeight ? true : false
        anchors{
            right: copyButton.left
            top:copyButton.top
            rightMargin: 3
        }
        background:Item{
            width: 25
            height: 25
            Image{
                id:image2
                source: {detailButton.hovered ? "./icons/detail-"+detailButton.isClicked+"-hover.svg" : "./icons/detail-"+detailButton.isClicked+".svg"}
                width: 15
                height: 15
                anchors.centerIn: parent
            }

        }

        onClicked: {
            if(contentCover.height<clipboardItemText.contentHeight-20){
                var component = Qt.createComponent("CustomPopup.qml");
                var height = clipboardItemText.contentHeight
                var data = clipboardItemText.text
                var options = {
                    "width": Qt.binding(function() { return 640 }),
                    "height": Qt.binding(function() { return height }),
                    "content": Qt.binding(function() { return data }),
                };
                var popup = component.createObject(parent, options);
            }
        }
    }

    TextEdit {
        anchors{
            top:parent.top
            left:parent.left
            bottom: contentCover.bottom
        }


        anchors.leftMargin: 8
        anchors.topMargin: 8
        anchors.bottomMargin: 30

        id: clipboardItemText
        width: 190
        readOnly: true
        text: ""
        color: "black"
        opacity: 100
        wrapMode: TextEdit.Wrap

    }


}
