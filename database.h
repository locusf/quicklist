#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QtSql>
#include "databaseconstants.h"
#include <QDebug>

class database : public QObject
{
    Q_OBJECT
public:
    explicit database(QObject *parent = 0);
    static database* instance();
    ~database();
signals:
    void fireItem(QString item);
public slots:
    void createTables();
    bool saveItem(QString item);
    void fireItems();
private:
    static database* m_instance;
    QSqlDatabase* db;
};

#endif // DATABASE_H
