import QtQuick 1.1
import Sailfish.Silica 1.0
import "../pages/FirstPage.qml" as Page

Rectangle {
    anchors.fill: parent
    color: "steelblue"
    
    Column {
        width: parent.width
        PageHeader {
            height: childrenRect.height
            title: "Quicklist"
            id: listheader
        }
        Repeater {
            id: listrep
            model: Page.childAt(0).listmodel
            delegate: Item {
                height: childrenRect.height
                width: parent.width
                Label {
                    text: name
                }
            }
        }
    }
}


