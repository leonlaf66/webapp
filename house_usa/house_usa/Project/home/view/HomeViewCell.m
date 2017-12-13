//
//  HomeViewCell.m
//  house_usa
//
//  Created by 林 建军 on 04/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HomeViewCell.h"

@implementation HomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setData:(NSDictionary *)data{
    _data = data;
    _titleLabel.text = data[@"name"];
    _pView.layer.cornerRadius = 5;
    //SEVERADDR
   // [self.myImageView setUrlStrImage:[NSString stringWithFormat:@"%@/%@",SEVERADDR,data[@"url"]] placeholderImage:nil];
    


    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SEVERADDR,data[@"url"]]] placeholderImage:nil ];
}

@end
