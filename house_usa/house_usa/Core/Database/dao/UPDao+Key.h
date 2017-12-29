//
//  UPDao+City.h
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import "UPDao.h"
#import "Key.h"
@interface UPDao (Key)
//创建
- (void)createSearchKey:(NSArray *)key;

//删除
- (void)deleteAllSearchKey;

//获取
- (NSMutableArray *)getSearchKeys:(NSString *)name;


@end
