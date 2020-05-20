#include "imageprovider.h"

ImageProvider::ImageProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap)
{

}

QPixmap ImageProvider::requestPixmap(const QString &file, QSize *size, const QSize &requestedSize)
{
    QPixmap pix;

    if (!file.isEmpty())
    {
        QString path = file.split("file://").at(1);
        QImage image(path, "jpg");

        if (image.isNull()) image = QImage(path, "png");
        if (image.isNull()) image = QImage(path);

        image = image.convertToFormat(QImage::Format_ARGB32_Premultiplied);
        QPixmap pix(image.width(), image.height());
        pix.convertFromImage(image);
        //pix = pix.scaled(QSize(image.width(), image.height()), Qt::KeepAspectRatio, Qt::SmoothTransformation);
        return pix;
    }

    return pix;
}
