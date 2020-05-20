#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWindow>
#include <QObject>
#include <QDebug>
#include <QMetaObject>
#include <QVariant>

#include "context.h"
#include "singleapplication.h"
#include "imageprovider.h"

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    //https://doc.qt.io/qt-5/qtglobal.html#qInstallMessageHandler
}

int main(int argc, char *argv[])
{
    //qputenv("QT_LOGGING_RULES", "qml=false");
    qInstallMessageHandler(myMessageOutput);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);

    //QGuiApplication app(argc, argv);
    singleApplication app(argc, argv);

    Context *context = new Context();
    context->singular = app._singular->nativeKey(); 
    context->checkInstance();

    // Kill instance
    if(app.lock())
    {
        QDBusInterface iface("emmios.interface.image", "/emmios/interface/image", "emmios.interface.image", QDBusConnection::sessionBus());
        if (iface.isValid())
        {
            iface.call("image", argv[1]);
        }

        return -1;
    }
    else
    {
        QDir dir;
        QString path = dir.homePath() + "/.config/synth/synth-image/";
        QFile file(path + "settings.conf");

        if(!file.exists())
        {
            file.open(QIODevice::ReadWrite);
            QSettings settings(path + "settings.conf", QSettings::NativeFormat);
            settings.setValue("hq", 1);
            file.close();
        }

        if (argc >= 2)
        {
            context->media = argv[1];
        }

        ImageProvider *imageProvider = new ImageProvider();

        QQmlApplicationEngine engine;
        engine.rootContext()->setContextProperty("Context", context);
        engine.addImageProvider("pixmap", imageProvider);
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
        //if (engine.rootObjects().isEmpty())
        //    return -1;

        app.setLock();

        QObject *main = engine.rootObjects().first();
        QWindow *window = qobject_cast<QWindow *>(main);
        context->window = window;

        Imedia *imedia = new Imedia();
        imedia->main = window;

        QDBusConnection connection = QDBusConnection::sessionBus();
        connection.registerObject("/emmios/interface/image", imedia, QDBusConnection::ExportAllSlots);
        connection.connect("emmios.interface.image", "/emmios/interface/image", "emmios.interface.image", "image", imedia, SLOT(image()));
        connection.registerService("emmios.interface.image");

        context->imedia = imedia;
        context->connection = &connection;

        return app.exec();
    }
}
