#ifndef CONTEXT_H
#define CONTEXT_H

#include <QObject>
#include <QScreen>
#include <QWindow>
#include <QPoint>
#include <QApplication>
#include <QCursor>
#include <QSettings>
#include <QDir>
#include <QImage>
#include <QFileInfoList>
#include <QFileInfo>
#include <QJsonObject>
#include <QDebug>
#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusAbstractAdaptor>

#include "xlibutil.h"
#include "imedia.h"

class Context : public QObject, public Xlibutil
{

    Q_OBJECT

public:
    Context();
    QString path;
    QString media;
    QString singular;
    QWindow *window;
    Imedia *imedia;
    QDBusConnection *connection;
    void checkInstance();
    Q_INVOKABLE int mouseX();
    Q_INVOKABLE int mouseY();
    Q_INVOKABLE QString uri();
    Q_INVOKABLE QString detailColor();
    Q_INVOKABLE QJsonObject imageInfo(QString file);
    Q_INVOKABLE int hq();
    Q_INVOKABLE void hq(int value);
    Q_INVOKABLE int windowMove(int x, int y, int w, int h);
    Q_INVOKABLE void clear();
    Q_INVOKABLE void disconnectDbus();

private:
    QScreen *screen = QApplication::screens().at(0);
};

#endif // CONTEXT_H
