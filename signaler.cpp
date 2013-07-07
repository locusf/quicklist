#include "signaler.h"

signaler* signaler::m_instance = NULL;

signaler::signaler(QObject *parent) :
    QObject(parent)
{
}

signaler* signaler::instance() {
    if (!m_instance) {
        m_instance = new signaler();
    }
    return m_instance;
}

void signaler::addItem(QString item) {
    itemAdded(item);
}
