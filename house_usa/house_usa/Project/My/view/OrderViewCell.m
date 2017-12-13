//
//  OrderViewCell.m
//  house_usa
//
//  Created by 林 建军 on 22/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "OrderViewCell.h"

@implementation OrderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
 
    
    _h_status_label.layer.cornerRadius = 2;
    _h_status_label.layer.borderColor = [UIColor colorWithString:@"#F05E4B"].CGColor;
    _h_status_label.layer.borderWidth = 0.5;
    
    
    _dayLabel.layer.cornerRadius = 2;
    _dayLabel.layer.borderColor = GlobalTintColor.CGColor;
    _dayLabel.layer.borderWidth = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(NSDictionary *)data{
    _data = data;
    _timeLabel.text = _data[@"date_start"];
    [_myImageView sd_setImageWithURL:[NSURL URLWithString:data[@"house"][@"image"]] placeholderImage:nil];
    _locationLabel.text = data[@"house"][@"location"];
    _h_status_label.text = data[@"house"][@"status_name"];
    
    if([[self getMyLang] containsString:@"zh"]){
      
        if([_data[@"status"] integerValue] == 0){
         _statusLabel.text = @"未确认";
        }else  if([_data[@"status"] integerValue] == 1){
            _statusLabel.text = @"已确认";
        }
    
    }else{
        
        
        if([_data[@"status"] integerValue] == 0){
            _statusLabel.text = @"unconfirmed";
        }else  if([_data[@"status"] integerValue] == 1){
            _statusLabel.text = @"confirmed";
        }
       
        
    }
    
    
    _titleLabel.text = _data[@"house"][@"name"];
    
      _dayLabel.text = _data[@"house"][@"list_days_description"];
    
    
    if([[self getMyLang] containsString:@"zh"]){
        
        self.priceLabel.text = [NSString stringWithFormat:@"售价：%@",_data[@"house"][@"list_price"]];
      
        
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:  self.priceLabel.text];
        
        NSRange rang = [ self.priceLabel.text rangeOfString:@"万美元"];
        NSRange pricerang =  NSMakeRange(3, rang.location);
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rang];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:GlobalRedColor range:pricerang];
        self.priceLabel.attributedText = attrString;
        
        
        
        _desLabel.text =  [NSString stringWithFormat:@"卧室 %@| 全卫 %@ 半卫 %@ | 居住面积 %@",_data[@"house"][@"no_bedrooms"],_data[@"house"][@"no_full_baths"],_data[@"house"][@"no_half_baths"],_data[@"house"][@"square_feet"]];

        
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"Price：%@",_data[@"house"][@"list_price"]];
     
        
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: self.priceLabel.text];
        
        NSRange rang =  NSMakeRange(0,  6);
        NSRange pricerang =  NSMakeRange(6,  self.priceLabel.text.length - 6);
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rang];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:GlobalRedColor range:pricerang];
        self.priceLabel.attributedText = attrString;
        
          _desLabel.text =  [NSString stringWithFormat:@"%@beds %@.%@baths %@",_data[@"house"][@"no_bedrooms"],_data[@"house"][@"no_full_baths"],_data[@"house"][@"no_half_baths"],_data[@"house"][@"square_feet"]];
        
    }


}

@end
