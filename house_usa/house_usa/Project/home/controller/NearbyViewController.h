//
//  NearbyViewController.h
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BSViewController.h"

@interface NearbyViewController : BSViewController
@property(nonatomic)double lat;
@property(nonatomic)double lon;
@property(nonatomic,strong) NSArray *area_houses;
@property(nonatomic,strong) NSDictionary *currentData;
@end
