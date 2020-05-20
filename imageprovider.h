#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <QObject>
#include <QQuickImageProvider>
#include <QDebug>

class ImageProvider : public QQuickImageProvider
{
public:
    ImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
};

#endif // IMAGEPROVIDER_H
