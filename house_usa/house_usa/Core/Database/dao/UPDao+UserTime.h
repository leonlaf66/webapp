//
//  UPDao+City.h
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import "UPDao.h"
#import "UserTime.h"
@interface UPDao (UserTime)
//创建城市
- (void)createUser:(UserTime *)userTime;

//删除城市
- (void)deleteUser;

//获取
- (NSMutableArray *)getUsers;

- (UserTime *)getUserTime:(NSString *)ID;

- (void)updateUserTime:(UserTime *)userTime;
@end
