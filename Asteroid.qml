import QtQuick 2.0
import Bacon2D 1.0

Entity {
    id: asteroid
    objectName: "asteroid"
    property point center: Qt.point(x + width / 2, y + height / 2)
    property double maxImpulse: 100
    property double maxAngularVelocity: 0.01
    property int splitLevel: 1
    property variant childAsteroid

    signal asteroidCreated();
    signal asteroidDestroyed();

    width: asteroidImage.width
    height: asteroidImage.height


    bodyType: Body.Dynamic
    fixtures: [
        Circle {
            id: circleShape
            anchors.fill: parent
            radius: parent.width/2
            density: 10
            friction: 0.3
            restitution: 0.1
        }
    ]

    Image {
        id: asteroidImage
        anchors.centerIn: parent
        source: "images/asteroid-s"+ asteroid.splitLevel + "-" + Math.ceil((Math.random() * 5) + 1) + ".png"
    }

    Sprite {
        id: explosionAnimation
        anchors.centerIn: parent
        visible: false
        animation: "explosion"
        animations: SpriteAnimation {
            running: false
            name: "explosion"
            source: "images/explosion.png"
            frames: 4
            duration: 400
            onFinished: explosionAnimation.visible = false
        }
    }

    Component.onCompleted: {
        asteroidCreated();
        applyRandomImpulse();
        setRandomAngularVelocity();
    }

    function randomDirection() {
        return ((Math.random() >= 0.5) ? -0.1 : 0.1);
    }

    function randomImpulse() {
        return Math.random() * asteroid.maxImpulse * randomDirection();
    }

    function randomAngularVelocity() {
        return maxAngularVelocity * randomDirection();
    }

    function applyRandomImpulse() {
        var impulse = Qt.point(randomImpulse(), randomImpulse());
        applyLinearImpulse(impulse, getWorldCenter());
    }

    function setRandomAngularVelocity() {
        angularVelocity = randomAngularVelocity();
    }

    function createChild(component)
    {
        var asteroidObject = component.createObject(world);
        asteroidObject.x = asteroid.x + Math.random() * asteroid.width;
        asteroidObject.y = asteroid.y + Math.random() * asteroid.height;
    }

    function createChildren(component) {
        createChild(component);
        createChild(component);
    }

    function damage() {
        explosionAnimation.visible = true;
        explosionAnimation.initializeAnimation();
        explodeTimer.start();
    }

    Timer {
        id: explodeTimer
        interval: 400
        running: false
        onTriggered: {
            if (asteroid.childAsteroid !== undefined)
                createChildren(asteroid.childAsteroid)
            asteroidDestroyed();
            asteroid.destroy();
        }
    }
}
