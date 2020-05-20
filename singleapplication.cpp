#include "singleapplication.h"


singleApplication::singleApplication(int &argc, char **argv)
    : QApplication(argc, argv, true)
{
    _singular = new QSharedMemory("synth-image", this);
}

singleApplication::~singleApplication()
{
    if(_singular->isAttached())
        _singular->detach();
}

void singleApplication::setLock()
{
    _singular->create(1, QSharedMemory::ReadWrite);
}

bool singleApplication::lock()
{
    if(_singular->attach(QSharedMemory::ReadOnly))
    {
        _singular->detach();
        return true;
    }

    return false;
}
