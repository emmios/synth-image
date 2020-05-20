import QtQuick 2.9
import "./"


Rectangle {
    x: 0
    y: 0
    width: parent.width
    height: 25
    color: "#00000000"

    property var win: Object
    property string detail: "#ffffff"
    property alias min: btnMin.visible

    Rectangle {
        anchors.fill: parent
        color: "#000"
        opacity: 0.5
    }

    MouseArea {
        id: geral
        anchors.fill: parent
        hoverEnabled: true

        onHoveredChanged: {
            decoration.opacity = 1.0
        }

        onExited: {
            decoration.opacity = 0.0
        }
    }

    MouseArea {
        id: mouseMain
        anchors.fill: parent
        property int startX: 0
        property int startY: 0
        property bool fullscreen: true

        onDoubleClicked: {
            if (fullscreen) {
                win.showFullScreen();
                fullscreen = false
                decoration.visible = false
            } else {
                win.showNormal();
                fullscreen = true
                decoration.visible = true
            }
            timer.stop()
            timer.start()
        }

        onPressed: {
            startX = mouseX
            startY = mouseY
            cursorShape = Qt.SizeAllCursor
        }

        onReleased: {
            cursorShape = Qt.ArrowCursor
        }

        onMouseXChanged: {
            win.x = Context.mouseX() - startX
            win.y = Context.mouseY() - startY
            Context.windowMove(win.x, win.y, win.width, win.height)
        }
    }

    Label {
        id: btnMin
        x: btnMax.x - width - 15
        y: btnMax.y - 2
        text: "\uf2d1"
        font.family: font_regular.name
        size: 10
        opacity: 0.8
        color: "#ffffff"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                decoration.opacity = 1.0
                btnMin.color = detail
                cursorShape = Qt.PointingHandCursor
            }

            onExited: {
                btnMin.color = "#ffffff"
                cursorShape = Qt.ArrowCursor
            }

            onClicked: {
                win.showMinimized()
            }
        }
    }

    Label {
        id: btnClose
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 8
        text: "\uf00d" //"\uf410"
        font.family: font_regular.name
        size: 12
        opacity: 0.8
        color: "#ffffff"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                decoration.opacity = 1.0
                btnClose.color = detail
                cursorShape = Qt.PointingHandCursor
            }

            onExited: {
                btnClose.color = "#ffffff"
                cursorShape = Qt.ArrowCursor
            }

            onClicked: {
                win.close()
            }
        }
    }

    Label {
        id: btnMax
        x: btnClose.x - width - 15
        y: btnClose.y + 2
        text: "\uf2d0"
        font.family: font_regular.name
        size: 10
        opacity: 0.8
        color: "#ffffff"

        MouseArea {
            anchors.fill: parent
            property bool maximezed: true
            hoverEnabled: true

            onHoveredChanged: {
                decoration.opacity = 1.0
                btnMax.color = detail
                cursorShape = Qt.PointingHandCursor
            }

            onExited: {
                btnMax.color = "#ffffff"
                cursorShape = Qt.ArrowCursor
            }

            function atualize() {
                if (decoration.func) decoration.func()
            }

            onClicked: {
                if (maximezed) {
                    win.showMaximized()
                } else {
                    win.showNormal()
                }
                maximezed = !maximezed
            }
        }
    }
}
