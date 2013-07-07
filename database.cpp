#include "database.h"
database* database::m_instance = NULL;
database::database(QObject *parent) :
    QObject(parent)
{
    db = new QSqlDatabase(QSqlDatabase::addDatabase("QSQLITE"));
    db->setDatabaseName("quicklist");
    qDebug() << "DatabaseManager: opening db...";
    bool ok = db->open();
    if(ok){
        qDebug()  << "DatabaseManager: db opened.";
    }else{
        qDebug()  << "DatabaseManager: db open error";
    }
    createTables();
}
database::~database() {
    if(db) {
        delete db;
        db = 0;
    }
}

database* database::instance() {
    if(!m_instance){
        m_instance = new database();
    }
    return m_instance;
}

void database::createTables() {
    db->exec(databaseconstants::CREATE_ITEM_TABLE);
}

bool database::saveItem(QString item) {
    QSqlQuery query = QSqlQuery(databaseconstants::INSERT_ITEM_TO_TABLE, *db);
    query.addBindValue(item);
    bool ok = query.exec();
    if (ok) {
        qDebug() << "Database :: item " << item << " saved.";
    } else {
        qDebug() << "Database :: item " << item << " was not saved : " << query.lastError();
    }
    return ok;
}

void database::fireItems() {
    QSqlQuery query = QSqlQuery(databaseconstants::SELECT_FROM_ITEM_TABLE, *db);
    bool ok = query.exec();
    while(query.next()) {
        fireItem(query.record().value("item").toString());
    }
}
