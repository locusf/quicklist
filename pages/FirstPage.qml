import QtQuick 1.1
import Sailfish.Silica 1.0

Page {
    id: page

    RemorsePopup {
        id: clearRemorse
    }
    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        anchors.fill: parent
        header: PageHeader {
            title: "QuickList"
        }
        Button {
            text: "Add item"
            onClicked:{
                additem.visible = true
                hintlbl.visible = false
                additem.forceActiveFocus()
            }
        }
        Label {
            id: hintlbl
        }
        delegate: BackgroundItem {
            id: itemdelegate
            Label {
                id: itemlabel
                x: theme.paddingLarge
                text: name
                font.strikeout: deleted
            }
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
                delremorse.execute(itemdelegate, "Deleting", function(){
                var ine = 0;
                for(ine=0;ine<listmodel.count;ine++){
                    if (listmodel.get(ine).name == name) {
                        listmodel.remove(ine)
                    }
                }
                }, 1500)
            }
            RemorseItem {id: delremorse}
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
                  hintlbl.visible = false
                  additem.forceActiveFocus()
              }
          }
          MenuItem {
              text: "Clear striked"
              onClicked: {
                  var i = 0;
                  for (i = 0; i <= listmodel.count; i++) {
                      if (listmodel.get(i).deleted) {
                          listmodel.remove(i)
                      }
                  }
              }
          }
          MenuItem {
              text: "Clear all"
              onClicked: clearRemorse.execute("Clearing", function() {listmodel.clear()}, 1500)
          }
        }
        PullDownMenu {
            MenuItem {
                text: "Clear all"
                onClicked: clearRemorse.execute("Clearing", function() {listmodel.clear()}, 1500)
            }
            MenuItem {
                text: "Clear striked"
                onClicked: {
                    var i = 0;
                    for (i = 0; i <= listmodel.count; i++) {
                        if (listmodel.get(i).deleted) {
                            listmodel.remove(i)
                        }
                    }
                }
            }
            MenuItem {
                text: "Add item"
                onClicked: {
                    additem.visible = true
                    hintlbl.visible = false
                    additem.forceActiveFocus()
                }
            }

        }
        
        // Tell SilicaFlickable the height of its content.
        contentHeight: childrenRect.height
        
        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            TextField {
                 id: additem
                 width: 300
                 placeholderText: ""
                 visible: false
                 horizontalAlignment: left
                 textMargin: 15
                 onFocusOutBehaviorChanged: {
                     additem.visible = false
                 }
                 Keys.onReturnPressed: {
                     additem.visible = false
                     listmodel.append({name: additem.text, deleted: false})
                     additem.text = ""
                     parent.focus = true
                 }
                 background: Component {
                     Rectangle {
                         id: customBackground

                         anchors.fill: parent
                         border {
                             color: parent.errorHighlight ?  "red" :"steelblue"
                             width: parent.errorHighlight ? 3 : 1
                         }
                         color: "steelblue"
                         radius: 5
                         smooth: true
                         gradient: Gradient {
                             GradientStop { position: 0.0; color: customBackground.color }
                             GradientStop {
                                 position: 1.0;
                                 color: parent.errorHighlight ? "red" : Qt.darker(customBackground.color, 3.0)
                             }
                         }
                     }
                 }
             }

        }



    }
}


