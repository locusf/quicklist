
#ifndef SAILFISHAPPLICATION_H
#define SAILFISHAPPLICATION_H

class QString;
class QApplication;
class QDeclarativeView;
#include "database.h"
#include "signaler.h"

namespace Sailfish {

QApplication *createApplication(int &argc, char **argv);
QDeclarativeView *createView(const QString &);
void showView(QDeclarativeView* view);

}

#endif // SAILFISHAPPLICATION_H

