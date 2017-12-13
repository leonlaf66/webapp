//
//  HotAreaViewController.h
//  house_usa
//
//  Created by 林 建军 on 08/09/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BSViewController.h"

typedef void (^AddressGetBackAction)(id data);

@interface HotAreaViewController : BSViewController
@property(nonatomic,strong) NSDictionary *datas;
@property(nonatomic,strong) AddressGetBackAction getBackAction;
@end
