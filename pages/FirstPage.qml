import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    function do_add_item() {
        additem.visible = true
        additem.forceActiveFocus()
    }
    function custom_add() {
        Database.saveItem(additem.text)
        newmodel.append({name: additem.text})
        do_sort()
        additem.text = ""
        parent.focus = true
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
        VerticalScrollDecorator {}
        PullDownMenu {
            MenuItem {
                text: "Clear all"
                onClicked: {
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

        Connections {
            target: Signaler
            onItemAdded: {
                newmodel.append({name: item})
                do_sort()
                additem.text = ""
                parent.focus = true
            }
        }

        Column {
            width: parent.width
            PageHeader {
                id: header
                title: "QuickList"
            }
            Row {

                spacing: 40
                width: parent.width
                TextField {
                     id: additem
                     width: 250
                     placeholderText: ""
                     horizontalAlignment: left
                     textMargin: 15
                     Keys.onReturnPressed: {
                         custom_add()
                     }

                }
                Button {
                    text: "Add"
                    width: 80
                    onClicked: {
                        if(additem.text.length == 0) {
                            pageStack.push(Qt.resolvedUrl("ItemsPage.qml"))
                        } else {
                            custom_add()
                        }
                    }
                }
                IconButton {
                    icon.source: "image://theme/icon-l-cancel"
                    onClicked: {
                        delmodel.clear()
                    }
                }
            }
            Repeater {
                model: ListModel {
                    id: newmodel
                }


                delegate:
                 TextSwitch {
                    id: itemlabel
                    x: theme.paddingLarge
                    text: name
                    checked: false

                    onClicked: {
                        delmodel.append(newmodel.get(index))
                        newmodel.remove(index)
                    }
                    onPressAndHold: {
                        delremorse.execute(itemlabel, "Deleting " + name, function() {
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
                delegate: TextSwitch {
                    id: dellabel
                    checked: true
                    x: theme.paddingLarge
                    text: name

                    onClicked: {
                        newmodel.append(delmodel.get(index))
                        delmodel.remove(index)
                        do_sort()
                    }
                    onPressAndHold: {
                        cdelremorse.execute(dellabel, "Deleting " + name, function() {
                            delmodel.remove(index)
                        }, 2000)
                    }
                    RemorseItem {id: cdelremorse}
                }
            }

        }

    }
}

