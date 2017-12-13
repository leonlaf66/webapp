//
//  UPDao+City.h
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import "UPDao.h"
#import "SearchKey.h"
@interface UPDao (SearchKey)
//创建
- (void)createSearchKeya:(SearchKey *)key;

//删除
- (void)deleteAllSearchKey;

//获取
- (NSMutableArray *)getSearchKeys;
@end
