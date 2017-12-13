//
//  HomeHeaderCell.m
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HomeHeaderCell.h"

@implementation HomeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _toolView.backgroundColor = [UIColor whiteColor];
   // CALayer * layer = [_toolView layer];
    //layer.cornerRadius = 2.5;;
    //添加四个边阴影
    _toolView.layer.shadowColor = GlobalTintColor.CGColor;//阴影颜色
    //阴影颜色
   
    //阴影offset
    _toolView.layer.shadowOffset = CGSizeMake(0, 1);
    //阴影path
   
    _toolView.layer.shadowPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, ScreenWidth - 20, _toolView.frame.size.height)].CGPath;;
    //不透明度
    _toolView.layer.shadowOpacity = 0.4;
    //阴影圆角半径
   // _toolView.layer.shadowRadius = 3;
    
    NSDictionary *lang = [self getMyLocal];
    
     _nearbyLabel.text = lang[@"nearbyLabel"];
     _newsLabel.text = lang[@"newsLabel"];
   
     _servicesLabel.text = lang[@"servicesLabel"];
    
     _flowLabel.text = lang[@"flowLabel"];
      _locationBtn.layer.cornerRadius = 10;
    _locationBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
   // [_buyBtn setTitle:lang[@"buyBtn"] forState:UIControlStateNormal];
    //[_rentalBtn setTitle:lang[@"rentalBtn"] forState:UIControlStateNormal];

   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
