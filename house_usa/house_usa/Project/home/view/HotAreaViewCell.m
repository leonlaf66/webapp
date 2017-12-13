//
//  HotAreaViewCell.m
//  house_usa
//
//  Created by 林 建军 on 08/09/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HotAreaViewCell.h"

@implementation HotAreaViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(Key *)data{
    _data = data;
    
     _titleLabel.text =  [NSString stringWithFormat:@"%@",_data.cityCode];
     _ctitleLabel.text =  [NSString stringWithFormat:@"%@",_data.cityName];
    
   ;
}

@end
