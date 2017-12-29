//
//  UPDao+City.m
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import "UPDao+Key.h"
#import "Key.h"
@implementation UPDao (Key)



- (void)createSearchKey:(NSArray *)operation{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            // [db executeUpdate:@"delete from "TABLE_BT_KEY" where keyName=?",key.cityName];
            
            
            
            for (NSDictionary *obj  in operation) {
                
                Key *key = [[Key alloc] init];
                key.cityName = obj[@"desc"];
                key.cityCode = obj[@"title"];
                
                [db executeUpdate:@"INSERT INTO "TABLE_BT_KEY"(keyName,keyCode) VALUES(?,?)",key.cityName,key.cityCode];
                
            }
            
            
        }];
    });
   
}

//删除城市
- (void)deleteAllSearchKey{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
           [db executeUpdate:@"delete  FROM "TABLE_BT_KEY" "];
            
        }];
    });
    
}

//获取
- (NSMutableArray *)getSearchKeys:(NSString *)name{
    __block NSMutableArray *datas = [NSMutableArray array];
    [self inDatabase:^(FMDatabase *db) {
       
           NSString *sql= [NSString stringWithFormat:@"SELECT * FROM "TABLE_BT_KEY" where keyCode like '%@%%'    group by keyName limit 0,5",name];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Key *key = [[Key alloc] init];
             key.cityName = [rs stringForColumn:@"keyName"];
             key.cityCode = [rs stringForColumn:@"keyCode"];
            [datas addObject:key];
        }
        [rs close];
    }];
    return datas;
}


@end
