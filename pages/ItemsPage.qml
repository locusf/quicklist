import QtQuick 1.1
import Sailfish.Silica 1.0

Page {
    id: itemspage
    property string selectedItem
    signal itemSelected (string item)
    Component.onCompleted: {
        Database.fireItems()
    }

    SilicaListView {
        contentHeight: childrenRect.height
        anchors.fill: parent
        Connections {
            target: Database
            onFireItem: {
                itemmodel.append({name: item})
            }
        }
        header: PageHeader {
            title: "Previous items"
        }
        model: ListModel {id: itemmodel}
        delegate: TextSwitch {
            id: itemlbl
            width: parent.width
            text: name
            checked: false
            automaticCheck: false
            onClicked: {
                if (!itemlbl.checked) {
                    Signaler.addItem(name)
                    itemlbl.checked = true
                }
            }
            onPressAndHold: {
                delremorse.execute(itemlbl, "Deleting "+ name, function() {
                    itemmodel.remove(index)
                    Database.deleteItem(name)
                }, 2000);
            }
            RemorseItem {id: delremorse}
        }
    }
}
