//
//  City.h
//  wesnail
//
//  Created by 林 建军 on 4/29/16.
//  Copyright © 2016 林建军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
//城市ID
@property (nonatomic, strong) NSString * cityID;
//城市名称
@property (nonatomic, strong) NSString * cityName;

@property (nonatomic, strong) NSString * groupName;
//查询关键字short_name
@property (nonatomic, strong) NSString * name;

@property (nonatomic, strong) NSString * shortName;

@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * location;
@end
