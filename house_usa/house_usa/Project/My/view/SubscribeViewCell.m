//
//  SubscribeViewCell.m
//  house_usa
//
//  Created by 林 建军 on 22/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "SubscribeViewCell.h"

@implementation SubscribeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _pView.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
