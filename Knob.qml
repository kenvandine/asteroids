import QtQuick 2.0

Rectangle {
    color: "transparent"
    property real centerX: dialer.x + dialer.width / 2
    property real centerY: dialer.y + dialer.width / 2
    property real rotation: dialer.rotation
    property bool isUpPressed: false
    property bool isDownPressed: false

    function getEventAngle(event)
    {
        var angle = Math.atan2(event.y - centerY, event.x - centerX);

        if(angle < 0)
            angle += 2 * Math.PI;

        return angle;
    }

    function dialerMoved(event)
    {
        dialer.rotation = getEventAngle(event) * 180 / Math.PI;
    }


    Image {
        id: dialer
        anchors.fill: parent
        source: "images/knob.png"
        opacity: 0.1
        rotation: parent.rotation
        onRotationChanged: print(rotation)
    }

    MouseArea {
	anchors.fill: parent
	onPositionChanged: {
            dialer.rotation = (getEventAngle(mouse) * 180) / Math.PI;
            //dialerMoved(mouse);
        }
    }
}
