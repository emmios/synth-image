#ifndef IMEDIA_H
#define IMEDIA_H

#include <QObject>
#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusAbstractAdaptor>
#include <QWindow>
#include <QDebug>

class Imedia : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "emmios.interface.image")

public:
    QWindow *main;

public slots:
    void image(QString file);

};

#endif // IMEDIA_H
