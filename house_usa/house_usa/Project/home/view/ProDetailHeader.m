//
//  ProDetailHeader.m
//  house_usa
//
//  Created by 林 建军 on 28/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "ProDetailHeader.h"

@implementation ProDetailHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _pinglunBtn.layer.cornerRadius = 2;
    _likeBtn.layer.cornerRadius = 2;
    _startView.pentacleScore = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
