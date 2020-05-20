import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "./Components"

AppCustom {
    id: root
    visible: true
    x: 100
    y: 100
    width: 840
    height: 540
    title: "Synth Image"
    color: "#00000000"
    flags: Qt.Window | Qt.FramelessWindowHint

    property string detail: "#007fff"
    property string media: Context.uri()
    property var view: image
    property bool gifLoadError: false
    property bool isClear: false

    onWidthChanged: {
        timer.stop()
        timer.start()
        rectMove.full()
    }

    onHeightChanged: {
        timer.stop()
        timer.start()
        rectMove.full()
    }

    onWindowStateChanged: {
        timer.stop()
        timer.start()
        rectMove.full()
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#13051d"
    }

    function gifError(arg) {
        gif.source = ""
        image.visible = false
        image.enabled = true
        gif.source = ""
        gif.anchors.fill = image.parent
        gif.visible = false
        gif.enabled = false
        image.source = "image://pixmap/" + "file://" + arg
        view = image

        image.x = 0
        image.y = 0
        image.width = root.width
        image.height = root.height

        hue.anchors.fill = image.parent
        hue.source = image

        flickable.x = 0
        flickable.y = 0
        flickable.width = root.width
        flickable.height = root.height
        flickable.contentY = 0
        flickable.contentX = 0
        flickable.contentWidth = root.width
        flickable.contentHeight = root.height

        quality(Context.hq() === 1 ? true : false)
        rectMove.full()
    }

    function imedia(arg) {
        var info = Context.imageInfo(arg)
        var len = arg.length
        var check = arg.toLowerCase()
        media = arg
        gifLoadError = false

        if (info.ext === "gif") {
            image.source = ""
            image.visible = false
            image.enabled = false
            //gif.visible = true
            gif.enabled = true
            view = gif
            image.anchors.fill = gif.parent
            gif.source = "file://" + arg
        } else {
            gif.source = ""
            gif.anchors.fill = image.parent
            gif.visible = false
            gif.enabled = false
            //image.visible = true
            image.enabled = true
            view = image
            image.source = "image://pixmap/" + "file://" + arg
        }

        hue.anchors.fill = view.parent
        hue.source = view

        view.x = 0
        view.y = 0
        view.width = root.width
        view.height = root.height

        flickable.x = 0
        flickable.y = 0
        flickable.width = root.width
        flickable.height = root.height
        flickable.contentY = 0
        flickable.contentX = 0
        flickable.contentWidth = root.width
        flickable.contentHeight = root.height

        root.requestActivate()
        quality(Context.hq() === 1 ? true : false)
        rectMove.full()

        var barLen = arg.split("/").length
        if (barLen > 0) {
            barLen = barLen  - 1
            var name = arg.split("/")[barLen]
            if (name) {
                root.title = "Synth Image | " + name
            }
        }
    }

    Flickable {
        id: flickable
        x: 0
        y: 0
        width: root.width
        height: root.height
        clip: true
        contentWidth: root.width
        contentHeight: root.height
        interactive: true
        onMovementStarted: {
            flickMouse.cursorShape = Qt.ClosedHandCursor
        }
        onMovementEnded: {
            flickMouse.cursorShape = Qt.OpenHandCursor
        }
        AnimatedImage {
            id: gif
            x: 0
            y: 0
            width: root.width
            height: root.height
            fillMode: AnimatedImage.PreserveAspectFit
            antialiasing: false
            smooth: false
            enabled: false
            cache: false
            visible: false
            onStatusChanged: {
                switch (status) {
                    case AnimatedImage.Ready:
                        playing = true
                        break
                    case AnimatedImage.Error:
                        gifError(media)
                        gifLoadError = true
                        break
                    default:
                        break
                }
            }
        }
        Image {
            id: image
            x: 0
            y: 0
            width: root.width
            height: root.height
            fillMode: Image.PreserveAspectFit
            antialiasing: false
            smooth: false
            enabled: false
            cache: false
            visible: false
        }
        HueSaturation {
            id: hue
            anchors.fill: image
            hue: 0.0
            saturation: 0.5
            lightness: 0.0
            source: view
            antialiasing: true
            smooth: true
            enabled: true
            cached: true
            visible: true
        }
        MouseArea {
            id: flickMouse
            anchors.fill: parent
            hoverEnabled: true
            onPressed: {
                cursorShape = Qt.ClosedHandCursor
            }
            onReleased: {
                cursorShape = Qt.OpenHandCursor
            }
            onHoveredChanged: {
                cursorShape = Qt.OpenHandCursor
            }
            onExited: {
                cursorShape = Qt.ArrowCursor
            }
        }
    }

    DropArea {
        id: dragTarget
        anchors.fill: parent
        property string url: ""
        onEntered: {
            url = drag.urls[0]
        }
        onDropped:
        {
            media = url.split("file://")[1]
            imedia(media)
        }
    }

    Timer {
        id: timer
        running: false
        interval: 300
        repeat: false
        onTriggered: {
            if (gifLoadError) {
                gifError(media)
            } else {
                imedia(media)
            }
        }
    }


    Rectangle {
        id: rectMove
        x: 0
        y: 0
        width: root.width
        height: root.height
        opacity: 0.0
        color: "#000000"
        property bool opc: true

        function full() {
            rectMove.height = root.height
            rectMove.opc = true
            rectMove.opacity = 0.0
        }

        function normal() {
            rectMove.height = root.height / 8
            rectMove.opc = false
            rectMove.opacity = 0.5
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onHoveredChanged: {
                if (rectMove.opc) {
                    parent.opacity = 0.0
                    rectMove.height = root.height
                } else {
                    parent.opacity = 0.5
                    rectMove.height = root.height / 8
                }
            }
            onExited: {
                parent.opacity = 0.0
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
                    root.showFullScreen();
                    fullscreen = false
                    decoration.visible = false
                } else {
                    root.showNormal();
                    fullscreen = true
                    decoration.visible = true
                }
                timer.stop()
                timer.start()
                rectMove.full()
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
                root.x = Context.mouseX() - startX
                root.y = Context.mouseY() - startY
                Context.windowMove(root.x, root.y, root.width, root.height)
            }

            onWheel: { }
        }
    }

    function quality(arg) {
        if (arg) {
            view.smooth = true
            view.antialiasing = true
            hue.enabled = true
            hue.visible = true
            view.visible = false
            Context.hq(1)
        } else {
            view.smooth = false
            view.antialiasing = false
            hue.visible = false
            hue.enabled = false
            view.visible = true
            Context.hq(0)
        }
    }

    WindowDecoration {
        id: decoration
        win: root
        opacity: 0
        detail: detail
        property int zoom: 200

        // make under
        Label {
            id: under
            x: 8
            y: 5
            text: "\uf2d2"
            size: 12
            opacity: 0.7
            color: "#ffffff"
            font.family: font_regular.name
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                property bool colorTmp: true

                onHoveredChanged: {
                    decoration.opacity = 1.0
                    cursorShape = Qt.PointingHandCursor
                }

                onExited: {
                    cursorShape = Qt.ArrowCursor
                }

                onClicked: {
                    if (colorTmp) {
                        parent.color = detail
                        root.flags = Qt.Tool | Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnBottomHint | Qt.Popup
                        bg.color = "#00000000"
                        decoration.min = false
                        if (!isClear) {
                            isClear = true
                            Context.disconnectDbus()
                            Context.clear()
                        }
                    } else {
                        parent.color = "#ffffff"
                        root.flags = Qt.Tool | Qt.Window | Qt.FramelessWindowHint
                        bg.color = "#13051d"
                        //decoration.min = true
                    }
                    colorTmp = !colorTmp
                }
            }
        }
        // high quality
        Label {
            id: hq
            x: under.x + under.width + 12
            y: 4
            text: "\uf0fd"
            size: 14
            opacity: 0.7
            color: Context.hq() === 0 ? "#ffffff" : detail
            property int activeHq: Context.hq()
            font.family: font_solid.name
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onHoveredChanged: {
                    decoration.opacity = 1.0
                    cursorShape = Qt.PointingHandCursor
                }

                onExited: {
                    cursorShape = Qt.ArrowCursor
                }

                onClicked: {
                    if (hq.activeHq === 1) {
                        quality(false)
                        hq.activeHq = 0
                        hq.color = "#ffffff"
                    } else {
                        quality(true)
                        hq.activeHq = 1
                        hq.color = detail
                    }
                }
            }
        }

        //zoom in
        Label {
            id: zoomIn
            x: (hq.x + hq.width) + 24
            y: 5
            text: "\uf00e"
            size: 12
            opacity: 0.7
            color: "#ffffff"
            font.family: font_regular.name
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onHoveredChanged: {
                    decoration.opacity = 1.0
                    cursorShape = Qt.PointingHandCursor
                    parent.color = detail
                }

                onExited: {
                    cursorShape = Qt.ArrowCursor
                    parent.color = "#ffffff"
                }

                onClicked: {

                    if (flickable.contentWidth >= root.width || flickable.contentHeight >= root.height) {
                        flickable.contentWidth += decoration.zoom
                        flickable.contentHeight += decoration.zoom
                        flickable.contentY += decoration.zoom / 2
                        flickable.contentX += decoration.zoom / 2
                        view.width = flickable.contentWidth
                        view.height = flickable.contentHeight
                        rectMove.normal()
                    } else if (flickable.contentWidth < root.width || flickable.contentHeight < root.height) {
                        flickable.contentWidth = root.width
                        flickable.contentHeight = root.height
                        flickable.contentY = 0
                        flickable.contentX = 0
                        view.width = root.width
                        view.height = root.height
                    }
                }
            }
        }
        // zoom out
        Label {
            id: zoomOut
            x: (zoomIn.x + zoomIn.width) + 12
            y: 5
            text: "\uf010"
            size: 12
            opacity: 0.7
            color: "#ffffff"
            font.family: font_regular.name
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onHoveredChanged: {
                    decoration.opacity = 1.0
                    cursorShape = Qt.PointingHandCursor
                    parent.color = detail
                }

                onExited: {
                    cursorShape = Qt.ArrowCursor
                    parent.color = "#ffffff"
                }

                onClicked: {
                    if (flickable.contentWidth <= root.width || flickable.contentHeight <= root.height) {
                        if (flickable.contentWidth > root.width / 2 || flickable.contentHeight > root.height / 2) {
                            flickable.contentWidth = view.width / 2
                            flickable.contentHeight = view.height / 2
                            flickable.contentY = -((view.height / 2) / 2)
                            flickable.contentX = -((view.width / 2) / 2)
                            view.width = view.width / 2
                            view.height = view.height / 2
                        }
                    } else {
                        flickable.contentWidth -= decoration.zoom
                        flickable.contentHeight -= decoration.zoom
                        flickable.contentY -= decoration.zoom / 2
                        flickable.contentX -= decoration.zoom / 2
                        view.width = flickable.contentWidth
                        view.height = flickable.contentHeight

                        if (flickable.contentWidth == root.width || flickable.contentHeight == root.height) {
                            flickable.contentWidth = root.width
                            flickable.contentHeight = root.height
                            flickable.contentY = 0
                            flickable.contentX = 0
                            view.width = root.width
                            view.height = root.height
                        }
                    }

                    if (view.width <= root.width && view.height <= root.height) {
                        rectMove.full()
                    }
                }
            }
        }
        // zoom normal
        Label {
            id: zoomNormal
            x: (zoomOut.x + zoomOut.width) + 12
            y: 6
            text: "\uf0c8"
            size: 12
            opacity: 0.7
            color: "#ffffff"
            font.family: font_solid.name
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onHoveredChanged: {
                    decoration.opacity = 1.0
                    cursorShape = Qt.PointingHandCursor
                    parent.color = detail
                }

                onExited: {
                    cursorShape = Qt.ArrowCursor
                    parent.color = "#ffffff"
                }

                onClicked: {
                    timer.stop()
                    timer.start()
                    rectMove.full()
                }
            }
        }
    }

    Component.onCompleted: {
        detail = Context.detailColor()
        decoration.detail = detail
        imedia(media)
    }
}
