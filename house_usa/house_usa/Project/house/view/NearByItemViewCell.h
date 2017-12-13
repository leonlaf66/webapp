//
//  NearByItemViewCell.h
//  house_usa
//
//  Created by 林 建军 on 25/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByItemViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bdLabel;
@property (weak, nonatomic) IBOutlet UILabel *baLabel;
@property (weak, nonatomic) IBOutlet UILabel *sqLabel;
@property (strong, nonatomic)  NSDictionary *data;
@end
