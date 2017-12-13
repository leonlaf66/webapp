//
//  UPDao+City.m
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import "UPDao+Phone.h"

@implementation UPDao (Phone)


//创建城市
- (void)createPhone:(Phone *)phone{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:@"INSERT INTO "TABLE_BT_PHONE"(phoneName,phoneType) VALUES(?,?)",phone.phoneName,phone.type];
            
        }];
    });
   
}

//删除城市
- (void)deletePhone{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
           [db executeUpdate:@"delete  FROM "TABLE_BT_PHONE" where phoneType='1'"];
            
        }];
    });
    
}

- (void)adeletePhone{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:@"delete  FROM "TABLE_BT_PHONE" where phoneType='2'"];
            
        }];
    });
    
}

//获取
- (NSMutableArray *)getPhones{
    __block NSMutableArray *datas = [NSMutableArray array];
    [self inDatabase:^(FMDatabase *db) {
        NSString *sql=  nil;
         sql= [NSString stringWithFormat:@"SELECT * FROM "TABLE_BT_PHONE"   where phoneType='1'"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Phone *city = [[Phone alloc] init];
             city.phoneName = [rs stringForColumn:@"phoneName"];
            
            [datas addObject:city];
        }
        [rs close];
    }];
    return datas;
}


- (NSMutableArray *)getaPhones{

    __block NSMutableArray *datas = [NSMutableArray array];
    [self inDatabase:^(FMDatabase *db) {
        NSString *sql=  nil;
        sql= [NSString stringWithFormat:@"SELECT * FROM "TABLE_BT_PHONE"  where phoneType='2'"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Phone *city = [[Phone alloc] init];
            city.phoneName = [rs stringForColumn:@"phoneName"];
            
            [datas addObject:city];
        }
        [rs close];
    }];
    return datas;

}

@end
