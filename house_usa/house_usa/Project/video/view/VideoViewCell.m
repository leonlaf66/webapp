//
//  VideoViewCell.m
//  house_usa
//
//  Created by 林 建军 on 05/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "VideoViewCell.h"

@implementation VideoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _pView.layer.cornerRadius = 5;
    
  

   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)data{

    _data =  data;
    
    _titleLabel.text = data[@"username"];
    
     [self createAvPlayer];
}


#pragma mark - 播放器躯干
- (void)createAvPlayer{
    
    
}




@end
