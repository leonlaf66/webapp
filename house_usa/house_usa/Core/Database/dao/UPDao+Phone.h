//
//  UPDao+City.h
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import "UPDao.h"
#import "Phone.h"
@interface UPDao (Phone)
//创建城市
- (void)createPhone:(Phone *)phone;

//删除城市
- (void)deletePhone;

//获取
- (NSMutableArray *)getPhones;

- (NSMutableArray *)getaPhones;

- (void)adeletePhone;

@end
