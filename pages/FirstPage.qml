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
        Label {
            text: "Pull up or down to add item"
            id: hintlbl
            color: Qt.darker(theme.highlightColor, 1.5)
            font.weight: Font.Light
        }
        delegate: BackgroundItem {
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
                  hintlbl.visible = false
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
                text: "Clear"
                onClicked: listmodel.clear()
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


