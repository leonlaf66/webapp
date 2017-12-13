

#import "UPDao.h"
#import "XTSandbox.h"
static FMDatabaseQueue *dbQueue;
@implementation UPDao

DEF_SINGLETON(UPDao);

- (id)init{
    self = [super init];
    if (self) {
        static dispatch_once_t predicate;
        dispatch_once( &predicate, ^{ \
            dbQueue = [[FMDatabaseQueue alloc] initWithPath:[[XTSandbox docPath] stringByAppendingPathComponent:@"wesnail.db"]];
           
            //创建数据库
            [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
               
                if (![db executeUpdate:CREATE_TABLE_BT_CITY]) {
                    *rollback = YES;return;
                }
                
                if (![db executeUpdate:CREATE_TABLE_BT_TIME]) {
                    *rollback = YES;return;
                }
                
                if (![db executeUpdate:CREATE_TABLE_BT_PHONE]) {
                    *rollback = YES;return;
                }
                
                if (![db executeUpdate:CREATE_TABLE_BT_SEARCHKEY]) {
                    *rollback = YES;return;
                }
                
                if (![db executeUpdate:CREATE_TABLE_BT_KEY]) {
                    *rollback = YES;return;
                }
                
                }];
            
            
            
        });
    }
    return self;
}

- (void)inDatabase:(DatabaseBlock)block{
    [dbQueue inDatabase:^(FMDatabase *db) {
//        [db setTraceExecution:YES];
        if (block) {
            block(db);
        }
    }];
}
- (void)inTransaction:(TransactionBlock)block{
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
      [db setTraceExecution:YES];
        if (block) {
            block(db,rollback);
            if (*rollback == YES) {
              //  DDLogError(@"数据库出错--->error:%@",[db lastErrorMessage]);
            }
        }
    }];
}

@end
