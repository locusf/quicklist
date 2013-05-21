import QtQuick 1.1
import Sailfish.Silica 1.0

Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        anchors.fill: parent
        header: PageHeader {
            title: "QuickList"
        }
        delegate: BackgroundItem {
            Label {
                id: itemlabel
                x: theme.paddingLarge
                text: name
                font.strikeout: deleted
            }
            property bool striked: itemlabel.font.strikeout;
            onClicked: {
                itemlabel.font.strikeout = (itemlabel.font.strikeout? false: true)
                var ine = 0;
                for(ine=0;ine<listmodel.count;ine++){
                    if (listmodel.get(ine).name == name) {
                        listmodel.remove(ine)
                    }
                }
                listmodel.append({name:name, deleted: true})
            }
            onPressAndHold: {
                var ine = 0;
                for(ine=0;ine<listmodel.count;ine++){
                    if (listmodel.get(ine).name == name) {
                        listmodel.remove(ine)
                    }
                }
            }
        }
        model: listmodel
        ListModel {
            id: listmodel
        }
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PushUpMenu {
          MenuItem {
              text: "Add item"
              onClicked: {
                  additem.visible = true
                  additem.forceActiveFocus()
              }
          }
          MenuItem {
              text: "Clear"
              onClicked: listmodel.clear()
          }
        }
        PullDownMenu {
            MenuItem {
                text: "Add item"
                onClicked: additem.visible = true
            }
            MenuItem {
                text: "Clear"
                onClicked: listmodel.clear()
            }
        }
        
        // Tell SilicaFlickable the height of its content.
        contentHeight: childrenRect.height
        
        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            TextField {
                 id: additem
                 width: 480
                 height: 300
                 placeholderText: ""
                 visible: false
                 onFocusOutBehaviorChanged: {
                     additem.visible = false
                 }
                 Keys.onReturnPressed: {
                     additem.visible = false
                     listmodel.append({name: additem.text, deleted: false})
                     additem.text = ""
                 }
             }

        }


    }
}


