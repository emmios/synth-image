#ifndef SINGLEAPPLICATION_H
#define SINGLEAPPLICATION_H

#include <QApplication>
#include <QObject>
#include <QSharedMemory>
#include <QWindow>
#include <QDebug>
#include <QObjectUserData>

class singleApplication : public QApplication
{
public:
    singleApplication(int &argc, char **argv);
    ~singleApplication();
    bool lock();
    void setLock();
    QSharedMemory *_singular; // shared memory !! SINGLE ACCESS
};

#endif // SINGLEAPPLICATION_H
