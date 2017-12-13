//
//  UPDao+City.m
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import "UPDao+UserTime.h"

@implementation UPDao (UserTime)


//创建城市
- (void)createUser:(UserTime *)userTime{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:@"INSERT INTO "TABLE_BT_TIME"(ID,NAME,TELEPHONE,PWD) VALUES(?,?,?,?)",userTime.ID,userTime.name,userTime.email,userTime.token];
            
        }];
    });
   
}

//删除城市
- (void)deleteUser{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
           [db executeUpdate:@"delete  FROM "TABLE_BT_TIME" "];
            
        }];
    });
    
}

//获取
- (NSMutableArray *)getUsers{
    __block NSMutableArray *datas = [NSMutableArray array];
    [self inDatabase:^(FMDatabase *db) {
        NSString *sql=  nil;
         sql= [NSString stringWithFormat:@"SELECT * FROM "TABLE_BT_TIME" order by ID "];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            UserTime *city = [[UserTime alloc] init];
             city.ID = [rs stringForColumn:@"ID"];
             city.name = [rs stringForColumn:@"name"];
             city.email = [rs stringForColumn:@"telephone"];
             city.token = [rs stringForColumn:@"pwd"];
            [datas addObject:city];
        }
        [rs close];
    }];
    return datas;
}


- (UserTime *)getUserTime:(NSString *)ID{
    __block UserTime *city = nil;
    [self inDatabase:^(FMDatabase *db) {
        NSString *sql=  nil;
        sql= [NSString stringWithFormat:@"SELECT * FROM "TABLE_BT_TIME"  "];
        
        NSString *asql = [NSString stringWithFormat:@"%@ where ID='%@'",sql,ID];
        FMResultSet *rs = [db executeQuery:asql];
        
        if ([rs next]) {
            city = [[UserTime alloc] init];
            city.ID = [rs stringForColumn:@"ID"];
            city.name = [rs stringForColumn:@"name"];
            city.email = [rs stringForColumn:@"telephone"];
            
             city.token = [rs stringForColumn:@"pwd"];
        }
        [rs close];
    }];

    
    return city;

}

- (void)updateUserTime:(UserTime *)userTime{
    
}
@end
