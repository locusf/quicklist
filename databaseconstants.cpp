#include "databaseconstants.h"

const QString databaseconstants::ITEM_TABLE = "items";
const QString databaseconstants::CREATE_ITEM_TABLE = "CREATE TABLE " + ITEM_TABLE + " (item TEXT PRIMARY KEY)";
const QString databaseconstants::INSERT_ITEM_TO_TABLE = "INSERT OR REPLACE INTO " + ITEM_TABLE + " (item) VALUES (?)";
const QString databaseconstants::SELECT_FROM_ITEM_TABLE = "SELECT * FROM "+ITEM_TABLE +" ORDER BY item ASC";

databaseconstants::databaseconstants()
{
}
