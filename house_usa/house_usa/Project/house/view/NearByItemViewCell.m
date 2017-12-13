//
//  NearByItemViewCell.m
//  house_usa
//
//  Created by 林 建军 on 25/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "NearByItemViewCell.h"

@implementation NearByItemViewCell

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
     [_headerImageView sd_setImageWithURL:[NSURL URLWithString:data[@"image"]] placeholderImage:nil];
    _priceLabel.text = [NSString stringWithFormat:@" %@",_data[@"list_price"]];
   
    _addressLabel.text = _data[@"location"];
    _bdLabel.text = _data[@"rooms_descriptions"];
        NSInteger tol =  [_data[@"no_full_baths"] integerValue] + [_data[@"no_half_baths"] integerValue];
    if([[self getMyLang] containsString:@"zh"]){
        
    
        _bdLabel.text =  [NSString stringWithFormat:@"卧室 %@|卫生间 %ld| %@",_data[@"no_bedrooms"],tol,_data[@"square_feet"]];
        
       
        
    }else{
        
        _bdLabel.text =  [NSString stringWithFormat:@"%@beds %ldbaths %@",_data[@"no_bedrooms"],tol,_data[@"square_feet"]];
        
        
    }

    
}

@end
