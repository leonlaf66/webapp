

/**********************************************************************/
#pragma mark - 定义表
/**********************************************************************/

#define TABLE_USER              @"User"


/**********************************************************************/
#pragma mark - 创建表
/**********************************************************************/

//用户表
#define CREATE_TABLE_USER @"CREATE TABLE IF NOT EXISTS " TABLE_USER"(\
'phone' VARCHAR(50,0) NOT NULL,\
'name' VARCHAR(50,0),\
'password' VARCHAR(50,0),\
'gesture' VARCHAR(50,0),\
'token' VARCHAR(100,0),\
'loginDate' TIMESTAMP,\
PRIMARY KEY('phone')\
)"


#define TABLE_BT_CITY           @"BT_City"

//,关键字
#define CREATE_TABLE_BT_CITY @"CREATE TABLE IF NOT EXISTS " TABLE_BT_CITY"(\
'ID' INTEGER PRIMARY KEY,\
'cityID' VARCHAR(70,0),\
'groupName' VARCHAR(50,0),\
'shortName' VARCHAR(255,0),\
'cdate' timestamp,\
'picName' VARCHAR(50,0),\
'descc' VARCHAR(255,0),\
'location' VARCHAR(255,0)\
)"



#define TABLE_CITY           @"table_City"

//城市列表shortName cityID
#define CREATE_TABLE_CITY @"CREATE TABLE IF NOT EXISTS " TABLE_CITY"(\
'cityID' VARCHAR(70,0),\
'pname' VARCHAR(50,0)\
)"

#define NumberExt           @"^[0-9]{8}$"





#define TABLE_BT_TIME           @"BT_TIME"

//,关键字
#define CREATE_TABLE_BT_TIME @"CREATE TABLE IF NOT EXISTS " TABLE_BT_TIME"(\
'ID' VARCHAR(150,0),\
'NAME' VARCHAR(150,0),\
'TELEPHONE' VARCHAR(150,0),\
'PWD' VARCHAR(150,0)\
)"






#define TABLE_BT_PHONE           @"BT_PHONE"

//,关键字
#define CREATE_TABLE_BT_PHONE @"CREATE TABLE IF NOT EXISTS " TABLE_BT_PHONE"(\
'phoneName' VARCHAR(50,0),\
'phoneType' VARCHAR(50,0)\
)"







//////新版


#define TABLE_BT_SEARCHKEY          @"BT_SEARCHKEY"

//,关键字
#define CREATE_TABLE_BT_SEARCHKEY @"CREATE TABLE IF NOT EXISTS " TABLE_BT_SEARCHKEY"(\
'ID' INTEGER PRIMARY KEY,\
'keyName' VARCHAR(80,0) UNIQUE,\
'keyCode' VARCHAR(80,0) \
)"




#define TABLE_BT_KEY          @"BT_KEY"

//,关键字
#define CREATE_TABLE_BT_KEY @"CREATE TABLE IF NOT EXISTS " TABLE_BT_KEY"(\
'ID' INTEGER PRIMARY KEY,\
'keyName' VARCHAR(80,0) UNIQUE,\
'keyCode' VARCHAR(80,0) \
)"
