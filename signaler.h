#ifndef SIGNALER_H
#define SIGNALER_H

#include <QObject>

class signaler : public QObject
{
    Q_OBJECT
public:
    explicit signaler(QObject *parent = 0);
    static signaler* instance();
signals:
    void itemAdded(QString item);
public slots:
    void addItem(QString item);
private:
    static signaler* m_instance;
};

#endif // SIGNALER_H
