import QtQuick 1.1
import Sailfish.Silica 1.0

Page {
    id: page
    function do_add_item() {
        additem.visible = true
        hintlbl.visible = false
        additem.forceActiveFocus()
    }

    RemorsePopup {
        id: clearRemorse
    }
    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        id: itemview
        ViewPlaceholder {
            enabled: itemview.count == 0
            text: "Add by pressing button or using menus."
        }
        anchors.fill: parent
        header: PageHeader {
            title: "QuickList"
        }
        Label {
            id: hintlbl
        }
        delegate: BackgroundItem {
            id: itemdelegate
            function delete_and_append() {
                itemlabel.font.strikeout = (itemlabel.font.strikeout? false: true)
                var ine = 0;
                for(ine=0;ine<listmodel.count;ine++){
                    if (listmodel.get(ine).name == name) {
                        listmodel.remove(ine)
                    }
                }
                listmodel.append({name:name, deleted: true})
            }
            function delete_with_remorse() {
                delremorse.execute(itemdelegate, "Deleting", function(){
                var ine = 0;
                for(ine=0;ine<listmodel.count;ine++){
                    if (listmodel.get(ine).name == name) {
                        listmodel.remove(ine)
                    }
                }
                }, 1500)
            }

            Label {
                id: itemlabel
                x: theme.paddingLarge
                text: name
                font.strikeout: deleted
            }
            onClicked: {
                delete_and_append()
            }
            onPressAndHold: {
                delete_with_remorse()
            }
            RemorseItem {id: delremorse}
        }
        model: listmodel
        ListModel {
            id: listmodel
        }

        PullDownMenu {
            MenuItem {
                text: "Clear all"
                onClicked: do_remorse_clear()
                function do_remorse_clear()
                {
                    clearRemorse.execute("Clearing", function() {listmodel.clear()}, 1500)
                }
            }
            MenuItem {
                text: "Clear striked"
                function clear_striked() {
                    var i = 0;
                    for (i = 0; i < listmodel.count; i++) {
                        if (listmodel.get(i).deleted) {
                            listmodel.remove(i)
                        }
                    }
                    for (i = 0; i < listmodel.count; i++) {
                        if (listmodel.get(i).deleted) {
                            listmodel.remove(i)
                        }
                    }
                }
                onClicked: {
                    clear_striked()
                }
            }
            MenuItem {
                text: "Add item"
                onClicked: {
                    do_add_item()
                }
            }
        }
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
                     custom_add()
                 }
                 function custom_add() {
                     additem.visible = false
                     listmodel.append({name: additem.text, deleted: false})
                     do_sort()
                     additem.text = ""
                     parent.focus = true
                 }
                 function do_sort(obj)
                 {
                     var n;
                     var i;
                     for (n=0; n < listmodel.count; n++)
                     {
                         for (i=n+1; i < listmodel.count; i++)
                         {
                             var n_obj = listmodel.get(n);
                             var i_obj = listmodel.get(i);
                             var one = new String(n_obj.name);
                             var other = new String(i_obj.name);
                             if (one.localeCompare(other) == 1 && !i_obj.deleted)
                             {
                                 listmodel.move(i, n, 1);
                                 n=0;
                             }
                         }
                     }
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
