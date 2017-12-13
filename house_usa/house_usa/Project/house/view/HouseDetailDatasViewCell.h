//
//  HouseDetailDatasViewCell.h
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseDetailDatasViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *allBathRoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *allBathRoomValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedsValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *halfBathRoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *halfBathRoomValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *roiLabel;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UILabel *a1label;
@property (weak, nonatomic) IBOutlet UILabel *b1label;
@property (weak, nonatomic) IBOutlet UILabel *c1label;
@property (weak, nonatomic) IBOutlet UILabel *d1label;


@property (weak, nonatomic) IBOutlet UILabel *a2label;
@property (weak, nonatomic) IBOutlet UILabel *b2label;
@property (weak, nonatomic) IBOutlet UILabel *c2label;
@property (weak, nonatomic) IBOutlet UILabel *d2label;
@end
