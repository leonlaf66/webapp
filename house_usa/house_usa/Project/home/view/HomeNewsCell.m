//
//  HomeNewsCell.m
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HomeNewsCell.h"

@implementation HomeNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(NSDictionary *)data{

    _data = data;//image
    
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:_data[@"image"]] placeholderImage:[UIImage imageNamed:@"header_news_default"]];
    
    _titleLabel.text = _data[@"title"];
    
     int value = (arc4random() % 100000) + 1;
    
     int valuea = (arc4random() % 100000) + 1;
    if([[self getMyLang] containsString:@"zh"]){
      _myLabel.text = [NSString stringWithFormat:@"阅读  %d  收藏 %d",value,valuea];
    }else{
    
      _myLabel.text = [NSString stringWithFormat:@"%d read   %d bookmarked",value,valuea];
    }
    
    
    
  
}

@end
