QT += core qml quick widgets x11extras dbus
CONFIG += c++11
CONFIG += warn_off
#CONFIG += console

#QMAKE_CFLAGS_WARN_ON -= -Wall
#QMAKE_CXXFLAGS_WARN_ON -= -Wall

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
CONFIG(release, debug | release): DEFINES += QT_NO_DEBUG_OUTPUT

QT_LOGGING_RULES="*.debug=false;qml=false"

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
    xlibutil.h \
    context.h \
    singleapplication.h \
    imedia.h \
    imageprovider.h

SOURCES += main.cpp \
    xlibutil.cpp \
    context.cpp \
    singleapplication.cpp \
    imedia.cpp \
    imageprovider.cpp

RESOURCES += qml.qrc \
    components.qrc

LIBS += -lX11

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
