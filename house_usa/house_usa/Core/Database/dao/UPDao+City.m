//
//  UPDao+City.m
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import "UPDao+City.h"
#import "City.h"
@implementation UPDao (City)


//创建城市
- (void)createCity:(City *)city{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
             [db executeUpdate:@"INSERT INTO "TABLE_BT_CITY"(cityID,groupName,picName,cdate,shortName,descc,location) VALUES(?,?,?,?,?,?,?)",city.cityID,city.groupName,city.name,[NSDate date],city.shortName,city.desc,city.location];
            
        }];
    });
   
}

//删除城市
- (void)deleteAllCity{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
           [db executeUpdate:@"delete  FROM "TABLE_BT_CITY" "];
            
        }];
    });
    
}

//获取
- (NSMutableArray *)getCitys:(NSString *)cityName{
    __block NSMutableArray *datas = [NSMutableArray array];
    [self inDatabase:^(FMDatabase *db) {
        NSString *sql= [NSString stringWithFormat:@"SELECT * FROM "TABLE_BT_CITY" order by ID desc"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            City *city = [[City alloc] init];
            city.name = [rs stringForColumn:@"picName"];
              city.cityID = [rs stringForColumn:@"cityID"];
             city.groupName = [rs stringForColumn:@"groupName"];
            city.shortName =  [rs stringForColumn:@"shortName"];
            city.desc = [rs stringForColumn:@"descc"];
            city.location = [rs stringForColumn:@"location"];
            [datas addObject:city];
        }
        [rs close];
    }];
    return datas;
}
@end
