//
//  ProDetailHeader.h
//  house_usa
//
//  Created by 林 建军 on 28/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiPentacleView.h"

@interface ProDetailHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *pinglunBtn;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet MultiPentacleView *startView;
@property (weak, nonatomic) IBOutlet UIImageView *headerimgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UILabel *profLabel;
@property (weak, nonatomic) IBOutlet UILabel *dtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end
