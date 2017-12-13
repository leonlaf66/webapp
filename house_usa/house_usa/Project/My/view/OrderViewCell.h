//
//  OrderViewCell.h
//  house_usa
//
//  Created by 林 建军 on 22/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewCell : UITableViewCell
@property(nonatomic,strong) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *h_status_label;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end
