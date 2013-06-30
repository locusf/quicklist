import QtQuick 1.1
import Sailfish.Silica 1.0

Page {
    id: page
    function do_add_item() {
        additem.visible = true
        additem.forceActiveFocus()
    }

    function do_sort(obj)
    {
        var n;
        var i;
        for (n=0; n < newmodel.count; n++)
        {
            for (i=n+1; i < newmodel.count; i++)
            {
                var n_obj = newmodel.get(n);
                var i_obj = newmodel.get(i);
                var one = new String(n_obj.name);
                var other = new String(i_obj.name);
                if (one.localeCompare(other) == 1)
                {
                    newmodel.move(i, n, 1);
                    n=0;
                }
            }
        }
    }
    RemorsePopup {
        id: clearRemorse
    }
    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        id: itemview
        contentHeight: childrenRect.height
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: "Clear all"
                onClicked: do_remorse_clear()
                function do_remorse_clear()
                {
                    clearRemorse.execute("Clearing", function() {
                        newmodel.clear()
                        delmodel.clear()
                    }, 1500)
                }
            }
            MenuItem {
                text: "Clear striked"
                onClicked: {
                    delmodel.clear()
                }
            }
            MenuItem {
                text: "Add item"
                onClicked: {
                    do_add_item()
                }
            }
        }
        PushUpMenu {
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
             horizontalAlignment: left
             textMargin: 15
             visible: false
             Keys.onReturnPressed: {
                 custom_add()
             }
             function custom_add() {
                 additem.visible = false
                 newmodel.append({name: additem.text})
                 do_sort()
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
        Column {
            width: parent.width
            PageHeader {
                id: header
                title: "QuickList"
            }

            Repeater {
                model: ListModel {
                    id: newmodel
                }

                delegate: BackgroundItem {
                    id: itemdelegate
                    Label {
                        id: itemlabel
                        x: theme.paddingLarge
                        text: name

                    }
                    onClicked: {
                        delmodel.append(newmodel.get(index))
                        newmodel.remove(index)
                    }
                    onPressAndHold: {
                        delremorse.execute(itemdelegate, "Deleting " + name, function() {
                            newmodel.remove(index)
                        }, 2000)
                    }
                    RemorseItem {id: delremorse}
                }
            }
            Repeater {
                model: ListModel {
                    id: delmodel
                }
                delegate: BackgroundItem {
                    id: deldelegate
                    Label {
                        font.strikeout: true
                        id: dellabel
                        x: theme.paddingLarge
                        text: name
                    }
                    onClicked: {
                        newmodel.append(delmodel.get(index))
                        delmodel.remove(index)
                        do_sort()
                    }
                    onPressAndHold: {
                        delremorse.execute(deldelegate, "Deleting " + name, function() {
                            delmodel.remove(index)
                        }, 2000)
                    }
                }
            }
        }
    }
}

