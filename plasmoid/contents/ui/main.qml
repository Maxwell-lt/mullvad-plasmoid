import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id:root
    anchors.fill: parent
    width: 300
    height: 300

    property string ip: ""
    property bool connected: false
    property string connectionType: ""
    property string exitName: ""
    property string country: ""
    property string city: ""

    function callback(x) {
        if (x.responseText) {
            console.log('Data retrieved!')
            var data = JSON.parse(x.responseText)
            root.ip = data.ip
            root.connected = data.mullvad_exit_ip
            root.country = data.country
            root.city = data.city
            if (root.connected) {
                root.connectionType = data.mullvad_server_type
                root.exitName = data.mullvad_exit_ip_hostname
            } else {
                root.connectionType = ""
                root.exitName = ""
            }
        }
    }

    function getMullvadData() {
        console.log('Fetching data')
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = (() => callback(xhr))
        xhr.open('GET', 'https://am.i.mullvad.net/json', true)
        xhr.send()
    }

    FontLoader {
        source: '../fonts/Cabin-Regular.ttf'
    }

    Timer {
        running: true
        repeat: true
        triggeredOnStart: true
        interval: 10000
        onTriggered: getMullvadData()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: getMullvadData()
    }

    Rectangle {
        id: titlebar
        anchors.top: root.top
        width: 300
        height: 50
        color: '#44AD4D'

        Text {
            anchors.centerIn: parent
            color: '#eee'
            font.family: Cabin
            font.pointSize: 20
            font.weight: Font.Bold
            text: 'MULLVAD STATUS'
        }
    }

    Rectangle {
        id: containerSpacer
        anchors.top: titlebar.bottom
        color: '#294d73'
        height: 250
        width: 300
    
        ColumnLayout {
            id: textContainer
            anchors.centerIn: parent
            spacing: 0
            

            Text {
                id: connectedText
                color: root.connected ? '#44ad4d' : '#e34039'
                font.family: Cabin
                font.pointSize: 12
                font.weight: Font.ExtraBold
                text: root.connected ? 'SECURE CONNECTION' : 'DISCONNECTED'
            }

            Text {
                id: locationText
                color: '#fff'
                font.family: Cabin
                font.pointSize: 18
                font.weight: Font.Bold
                text: root.city + '\n' + root.country
            }

            Text {
                id: nodeText
                color: '#ccc'
                font.family: Cabin
                font.pointSize: 10
                text: root.exitName
            }

            Text {
                id: typeText
                color: '#ccc'
                font.family: Cabin
                font.pointSize: 10
                text: root.connectionType
            }
            
            Text {
                id: ipText
                color: '#ccc'
                font.family: Cabin
                font.pointSize: 10
                text: root.ip
            }
        }
    }
}
