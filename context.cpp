#include "context.h"

Context::Context()
{
    QDir dir;
    this->path = dir.homePath() + "/.config/synth/synth-player/";
}

void Context::checkInstance()
{
    unsigned long _items;
    Window *list = this->xwindows(&_items);
    bool check = false;

    for (int i = 0; i < _items; i++)
    {
        QString wmclass = this->xwindowClass(list[i]);
        if (wmclass == "synth-image")
        {
            QString type = QString(this->xwindowType(list[i]));
            if (type == "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE" || type == "_NET_WM_WINDOW_TYPE_NORMAL")
            {
                check = true;
                break;
            }
        }
    }

    if (!check)
    {
        QDir dir;
        dir.remove(singular);
    }
}

void Context::disconnectDbus()
{
    connection->unregisterObject("/emmios/interface/image");
    connection->disconnect("emmios.interface.image", "/emmios/interface/image", "emmios.interface.image", "image", imedia, SLOT(image()));
    connection->unregisterService("emmios.interface.image");
}

void Context::clear()
{
    QDir dir;
    dir.remove(singular);
}

QJsonObject Context::imageInfo(QString file)
{
    QJsonObject json;
    QFileInfo info(file);
    QImage image(file);

    json.insert("ext", info.suffix());
    json.insert("abosluteFilePath", info.absoluteFilePath());
    json.insert("w", image.width());
    json.insert("h", image.height());
    json.insert("path", info.absolutePath());
    json.insert("name", info.fileName());

    return json;
}

int Context::windowMove(int x, int y, int w, int h)
{
    Display *d = XOpenDisplay(0);
    Status status;
    XEvent xevent;
    Atom moveresize;

    moveresize = XInternAtom(d, "_NET_MOVERESIZE_WINDOW", False);

    if (!moveresize)
    {
        return -1;
    }

    if (y < 0) y = 0;

    xevent.type = ClientMessage;
    xevent.xclient.window = this->window->winId();
    xevent.xclient.message_type = moveresize;
    xevent.xclient.format = 32;
    xevent.xclient.data.l[0] = StaticGravity | (1 << 8) | (1 << 9) | (1 << 10) | (1 << 11);
    xevent.xclient.data.l[1] = x;
    xevent.xclient.data.l[2] = y;
    xevent.xclient.data.l[3] = w;
    xevent.xclient.data.l[4] = h;

    status = XSendEvent(d, DefaultRootWindow(d), False,
                SubstructureNotifyMask | SubstructureRedirectMask, &xevent);

    XCloseDisplay(d);
    return status;
}

int Context::mouseX()
{   
    QPoint Mouse = QCursor::pos(this->screen);
    return Mouse.x();
}

int Context::mouseY()
{
    QPoint Mouse = QCursor::pos(this->screen);
    return Mouse.y();
}

QString Context::uri()
{
    return media;
}

QString Context::detailColor()
{
    QDir dir;
    QSettings panel(dir.homePath() + "/.config/synth/panel/settings.conf", QSettings::NativeFormat);
    QString color = panel.value("color").toString();
    if (color.isEmpty()) color = "#007fff";
    return color;
}

int Context::hq()
{
    QSettings video(this->path + "settings.conf", QSettings::NativeFormat);
    return video.value("hq").toInt();
}

void Context::hq(int value)
{
    QSettings video(this->path + "settings.conf", QSettings::NativeFormat);
    video.setValue("hq", value);
}
