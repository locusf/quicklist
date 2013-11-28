# The name of your app
TARGET = harbour-quicklist

# C++ sources
SOURCES += main.cpp \
    database.cpp \
    databaseconstants.cpp \
    signaler.cpp

# C++ headers
HEADERS += \
    database.h \
    databaseconstants.h \
    signaler.h

# QML files and folders
qml.files = *.qml pages cover main.qml

# The .desktop file
desktop.files = harbour-quicklist.desktop

# Please do not modify the following line.
include(sailfishapplication/sailfishapplication.pri)

OTHER_FILES = rpm/quicklist.yaml

