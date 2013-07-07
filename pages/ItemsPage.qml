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
        delegate: BackgroundItem {
            width: parent.width
            Label {
                text: name
            }
            onClicked: {
                pageStack.pop()
                selectedItem = name
                Signaler.addItem(name)
            }
        }
    }
}
