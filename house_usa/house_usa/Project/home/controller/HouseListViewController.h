//
//  HouseListViewController.h
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BSViewController.h"
#import "HouseFilterViewController.h"
#import "SortBtn.h"
@interface HouseListViewController : BSViewController
@property(nonatomic,strong) NSString *type;

@property(nonatomic,strong)IBOutlet UIButton *backBtn;

@property(nonatomic,strong) NSString *searchKey;
@property(nonatomic,strong) NSString *key;

@property(nonatomic)  BOOL hideBackBtn;
@end
