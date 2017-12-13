//
//  HouseFilterViewController.h
//  house_usa
//
//  Created by 林 建军 on 29/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BSViewController.h"
#import "HouseFilterViewCell.h"
#import "BMapUtil.h"
#import "MJRefresh.h"
#import "HomeModel.h"
#import "TypeViewCell.h"
#import "BedsViewCell.h"
#import "PriceViewCell.h"
#import "AreaViewCell.h"
#import "BathViewCell.h"
#import "ParkingViewCell.h"
#import "DaysViewCell.h"
#import "FilterButton.h"
typedef void (^GetBackAction)(id data);
@interface HouseFilterViewController : BSViewController
@property(nonatomic)NSInteger type;
@property(nonatomic,strong) GetBackAction getBackAction;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) NSMutableArray *typeDatas;
@property(nonatomic,strong) NSDictionary *bedsData;
@property(nonatomic,strong) NSDictionary *priceData;
@property(nonatomic,strong) NSDictionary *areaData;
@property(nonatomic,strong) NSDictionary *bathData;
@property(nonatomic,strong) NSDictionary *parkingData;
@property(nonatomic,strong) NSDictionary *daysData;

@property(nonatomic,strong) TypeViewCell *typeCell;
@property(nonatomic,strong) BedsViewCell *bedsCell;
@property(nonatomic,strong) PriceViewCell *priceCell;
@property(nonatomic,strong) AreaViewCell *areaCell;
@property(nonatomic,strong) BathViewCell *bathCell;
@property(nonatomic,strong) ParkingViewCell *parkingCell;
@property(nonatomic,strong) DaysViewCell *daysCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property(nonatomic) BOOL map;
-(void)loadByType:(NSInteger)type;

-(void)setAction;
-(void)initData;
-(void)loadsView;

-(void)setTypes:(NSArray *)types;


-(void)setPrice:(NSDictionary *)prices;

-(void)setArea:(NSDictionary *)as;

-(void)setBeds:(NSDictionary *)bs;
@end
