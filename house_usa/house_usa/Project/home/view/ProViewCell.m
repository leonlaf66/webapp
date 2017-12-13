//
//  ProViewCell.m
//  house_usa
//
//  Created by 林 建军 on 27/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "ProViewCell.h"

@implementation ProViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setData:(NSDictionary *)data{

    _data = data;
    //photo_url
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:data[@"photo_url"]] placeholderImage:nil];
    
      _startView.pentacleScore = [_data[@"rating"] doubleValue];
      _nameLabel.text =_data[@"name"] ;
    if([[self getMyLang] containsString:@"zh"]){
       _desLabel.text = [NSString stringWithFormat:@"业务范围:%@",_data[@"business"] ];
    
    }else{
     _desLabel.text = [NSString stringWithFormat:@"BUSINESS:%@",_data[@"business"] ];
    }
    
    //business
//rating
}
@end
