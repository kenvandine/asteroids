import QtQuick 2.0

Rectangle {
    color: "transparent"
    property real centerX: knob.x + knob.width / 2
    property real centerY: knob.y + knob.width / 2
    property real rotation: knob.rotation

    function getEventAngle(event)
    {
        var angle = Math.atan2(event.y - centerY, event.x - centerX);
        if(angle < 0)
            angle += 2 * Math.PI;
        return angle;
    }

    Image {
        id: knob
        anchors.fill: parent
        source: "images/knob.png"
        opacity: 0.1
        rotation: parent.rotation
        onRotationChanged: print(rotation)
    }

    MouseArea {
	anchors.fill: parent
	onPositionChanged: {
            knob.rotation = (getEventAngle(mouse) * 180) / Math.PI;
        }
    }
}
