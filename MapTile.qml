import QtQuick 2.0

Item {

    property real longtitude
    property real latitude

    width: 300
    height: 300


    id: root

    Image {
        source: qsTr("http://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=%1x%2&maptype=roadmap&"+
                "sensor=false").arg(root.width).arg(root.height)

    }

}
