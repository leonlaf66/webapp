//
//  HomeHouseCell.h
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHouseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (strong, nonatomic)  NSDictionary *data;

@property (strong, nonatomic)  NSDictionary *sdata;
@end
