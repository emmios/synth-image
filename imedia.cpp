#include "imedia.h"


void Imedia::image(QString file)
{
    QMetaObject::invokeMethod(this->main, "imedia",
        Q_ARG(QVariant, file)
    );
}


