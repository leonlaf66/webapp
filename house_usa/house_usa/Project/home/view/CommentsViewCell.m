//
//  CommentsViewCell.m
//  house_usa
//
//  Created by 林 建军 on 28/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "CommentsViewCell.h"

@implementation CommentsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _startView.pentacleScore = 0;
    _headerImgView.clipsToBounds = YES;
    _headerImgView.layer.cornerRadius = 10;
    
    _pView.layer.borderColor  = [UIColor colorWithString:@"#dedede"].CGColor;
    _pView.layer.borderWidth = 0.5;
    _pView.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(NSDictionary *)data{

    _data = data;
    
    if(data[@"user"] &&data[@"user"][@"name"] ){
      _headerTitleLabel.text = _data[@"user"][@"name"];
    }
    
  
    
     _startView.pentacleScore = [_data[@"rating"] doubleValue];
    
     _dateLabel.text = [_data[@"created_at"] substringToIndex:19];
    _contentLabel.text = _data[@"comments"];
}

@end
