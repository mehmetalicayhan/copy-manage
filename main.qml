import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import org.mehmetali.clipboard 1.0
import org.mehmetali.filemanager 1.0

ApplicationWindow {
    id:root
    visible: true
    width: 300
    height: Screen.height
    x:Screen.desktopAvailableWidth - width
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"

    // Parse File Data

    property var listModel:[]
    property double transparency:0.8
    function parseString(str) {
          const regex = /(\[record:\])((.|\n)*?)(\[endrecord:\])/gim;
          let m;
          let results = [];

          while ((m = regex.exec(str)) !== null) {
              if (m.index === regex.lastIndex) {
                  regex.lastIndex++;
              }

              m.forEach((match, groupIndex) => {
                  if (groupIndex === 2 && (match !== "" || match !== " ")) {
                      results.unshift(match.trim());
                  }
              });
          }

          const uniqueResults = [...new Set(results)];


          listModel = uniqueResults;
          return uniqueResults;
      }

    // Base Rectangle
    Rectangle {

        id: parent
        width: root.width
        height: root.height
        color: "#B3B6B0B0"

        // Topbar
        Rectangle {
            id:topbar
            width: parent.width
            height: 40
            x:0
            y:0
            color: "#B6B0B0"
            opacity: 1

            NumberAnimation {
                id:ana
                target: clipboardList
                property: "currentIndex"
                from:clipboardList.currentIndex
                to:0
                duration: 0
                easing.type: {type: Easing.OutBack;}
            }
            Image{
                id:icon
                source: "./icons/Icon.png"
                width: 105
                height: 26
                anchors.left: topbar.left
                anchors.verticalCenter: topbar.verticalCenter
                anchors.leftMargin: 10
                MouseArea{
                    anchors.fill: icon
                    onClicked: {
                        ana.start()
                    }
                }
            }
            // Settings
            //            Button {
            //                id:settingsButton
            //                width: 19
            //                height: 19
            //                background: Image{
            //                    source: settingsButton.hovered ? "./icons/settings-hover.svg" : "./icons/settings.svg"
            //                }
            //                anchors.right: closeButton.left
            //                anchors.rightMargin: 10
            //                anchors.verticalCenter: topbar.verticalCenter
            //                onClicked: settingsPopup.open()
            //                // Todo : design setting page and navigate it
            //            }

            //            Popup{
            //                id:settingsPopup
            //                width: 300
            //                height: 100
            //                y:45
            //                background: Rectangle{
            //                    color: "#ccc"
            //                    Slider {
            //                        from: 80
            //                        value: 25
            //                        to: 100
            //                        onValueChanged: root.opacity = value/100
            //                    }

            //                }
            //                modal: true
            //                focus: true

            //                enter: Transition {
            //                    NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
            //                }

            //                exit: Transition {
            //                    NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
            //                }

            //                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

            //            }

            Button {
                id:closeButton
                width: 19
                height: 19
                background: Image{
                    source: closeButton.hovered ? "./icons/close-hover.svg" : "./icons/close.svg"
                }
                anchors.right: topbar.right
                anchors.rightMargin: 10
                anchors.verticalCenter: topbar.verticalCenter
                onClicked: Qt.quit()
            }

        }

        // List Copied Data
        ListView {
            id:clipboardList

            anchors{
                left:parent.left
                right: parent.right
                top:topbar.bottom
                bottom: parent.bottom
            }

            anchors.topMargin: 20
            anchors.leftMargin: 30
            anchors.bottomMargin: 20
            spacing: 40

            focus: true
            height: parent.height
            clip: true
            model:parseString(file.readFile())

            delegate: ClipboardItem{
                Drag.active: mouseArea.drag.active
                Drag.dragType: Drag.Automatic
                Drag.mimeData: { "text/plain": clipboardItem.text }
                Drag.proposedAction: Qt.CopyAction
                Drag.supportedActions: Qt.CopyAction | Qt.MoveAction
                Drag.keys: ["text/plain"]


//                Drag.onDragStarted : {
//                    print("Start drag:")
//                }
                Drag.onDragFinished: {

                    Drag.drop();
                }

                color: clipboardList.currentIndex === index ? "#d0c4bc" : "white"

                MouseArea{
                    id:mouseArea
                    anchors.fill: parent
                    onClicked: {
                        clipboardList.currentIndex=index
                    }
                    drag.target: clipboardItem
                }

                clipboardItem.text: modelData
                clipboardItem.x : parent.x+25
                clipboardItem.y : parent.y+3
                anchors.bottomMargin: 20

                DropArea {
                    anchors.fill: parent
                    keys: ["text/plain"]
                    onDropped: {
                        if (drop.hasText) {
                            if (drop.proposedAction == Qt.MoveAction || drop.proposedAction == Qt.CopyAction) {
                                drop.acceptProposedAction()
                            }
                        }
                    }
                }


            }


        }


        //  File processes
        FileManager{
            id:file
            property var data
            Component.onCompleted: data=file.readFile()
        }


        // Clipboard


        Clipboard{
            function controlIsItemExist(lastElement) {
                for(let i = 0 ;i<listModel.length;i++){
                    if(listModel[i]===lastElement){
                        console.log("ok")
                        return false;
                    }
                }

                return true;
            }

            id:clipboard
            property var data
            Component.onCompleted: data=getClipboardData()
            onClipboardChanged:{
                var lastElement = clipboard.clipboardList[clipboard.clipboardList.length-1];
                if(controlIsItemExist(lastElement)){
                    listModel.unshift(lastElement);
                    clipboardList.model = listModel;
                }
            }
        }

        Action{
            shortcut: "Ctrl+C"
            onTriggered: {

                clipboard.setClipboardData(clipboardList.currentItem.clipboardItem.text)
            }
        }

        Action{
            id:quitAction
            shortcut: StandardKey.Quit
            onTriggered: Qt.quit()
        }




    }
}
