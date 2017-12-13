//
//  UPDao+City.m
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import "UPDao+SearchKey.h"
#import "SearchKey.h"
@implementation UPDao (SearchKey)



- (void)createSearchKeya:(SearchKey *)key{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
             [db executeUpdate:@"delete from "TABLE_BT_SEARCHKEY" where keyName=?",key.cityName];
             [db executeUpdate:@"INSERT INTO "TABLE_BT_SEARCHKEY"(keyName,keyCode) VALUES(?,?)",key.cityName,key.cityCode];
            
        }];
    });
   
}

//删除城市
- (void)deleteAllSearchKey{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
           [db executeUpdate:@"delete  FROM "TABLE_BT_SEARCHKEY" "];
            
        }];
    });
    
}

//获取
- (NSMutableArray *)getSearchKeys{
    __block NSMutableArray *datas = [NSMutableArray array];
    [self inDatabase:^(FMDatabase *db) {
        NSString *sql= [NSString stringWithFormat:@"SELECT * FROM "TABLE_BT_SEARCHKEY" order by ID desc"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            SearchKey *key = [[SearchKey alloc] init];
            key.cityName = [rs stringForColumn:@"keyName"];
             key.cityCode = [rs stringForColumn:@"keyCode"];
            [datas addObject:key];
        }
        [rs close];
    }];
    return datas;
}
@end
