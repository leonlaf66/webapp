//
//  HomeHouseCell.m
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HomeHouseCell.h"

@implementation HomeHouseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    
    _houseStatusLabel.layer.cornerRadius = 2;
    _houseStatusLabel.layer.borderColor = [UIColor colorWithString:@"#F05E4B"].CGColor;
    _houseStatusLabel.layer.borderWidth = 0.5;
    
    
    _houseDayLabel.layer.cornerRadius = 2;
    _houseDayLabel.layer.borderColor = GlobalTintColor.CGColor;
    _houseDayLabel.layer.borderWidth = 0.5;

}
-(void)setSdata:(NSDictionary *)sdata{

    _sdata = sdata;
    
    [ self setData:_sdata[@"house"]];
}

-(void)setData:(NSDictionary *)data{
    _data = data;
    NSDictionary *lang = [self getMyLocal];
    
    [_myImageView sd_setImageWithURL:[NSURL URLWithString:data[@"image"]] placeholderImage:nil];
    _locationLabel.text = _data[@"location"];
    
    _titleLabel.text =  _data[@"name"];
    
    
    
    
    
    
      _houseTypeLabel.text = _data[@"prop_type_name"];
      _houseStatusLabel.text = _data[@"status_name"];
      _houseDayLabel.text = _data[@"list_days_description"];
    
   // NSLog(@"--%@",_data[@"list_price"]);
          self.priceLabel.textColor =GlobalRedColor;
    
    if([[self getMyLang] containsString:@"zh"]){
    
         self.priceLabel.text = [NSString stringWithFormat:@"售价：%@",_data[@"list_price"]];
     _descLabel.text =  [NSString stringWithFormat:@"卧室 %@| 全卫 %@ 半卫 %@ | 居住面积 %@",_data[@"no_bedrooms"],_data[@"no_full_baths"],_data[@"no_half_baths"],_data[@"square_feet"]];
        
  
//        
//        
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:  self.priceLabel.text];
//        
//        NSRange rang = [ self.priceLabel.text rangeOfString:@"万美元"];
//        
//        if(rang.length == 0){
//        rang = [ self.priceLabel.text rangeOfString:@"$"];
//        
//        }
//        NSRange pricerang =  NSMakeRange(3, rang.location);
//        
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rang];
//        
//        [attrString addAttribute:NSForegroundColorAttributeName value:GlobalRedColor range:pricerang];
//        self.priceLabel.attributedText = attrString;
        
    }else{
          self.priceLabel.text = [NSString stringWithFormat:@"Price：%@",_data[@"list_price"]];
          _descLabel.text =  [NSString stringWithFormat:@"%@beds %@.%@baths %@",_data[@"no_bedrooms"],_data[@"no_full_baths"],_data[@"no_half_baths"],_data[@"square_feet"]];
        
        
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: self.priceLabel.text];
//        
//        NSRange rang =  NSMakeRange(0,  6);
//        NSRange pricerang =  NSMakeRange(6,  self.priceLabel.text.length - 6);
//        
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rang];
//        
//        [attrString addAttribute:NSForegroundColorAttributeName value:GlobalRedColor range:pricerang];
//        self.priceLabel.attributedText = attrString;
    
    }
    
//    if (true) {
//       
//        
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
//        
//        NSRange rang = [self.priceLabel.text rangeOfString:[NSString stringWithFormat:@"%@:",lang[@"price"]]];
//        NSRange pricerang =  NSMakeRange((rang.location + rang.length), self.priceLabel.text.length - rang.length - 3);
//        
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:rang];
//        
//        [attrString addAttribute:NSForegroundColorAttributeName value:GlobalRedColor range:pricerang];
//        self.priceLabel.attributedText = attrString;
//        
//    }else{
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
//        
//        NSRange rang = [self.priceLabel.text rangeOfString:[NSString stringWithFormat:@"%@:$",lang[@"price"]]];
//        NSRange pricerang =  NSMakeRange((rang.location + rang.length), self.priceLabel.text.length - rang.length);
//        
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:rang];
//        
//        [attrString addAttribute:NSForegroundColorAttributeName value:GlobalRedColor range:pricerang];
//        self.priceLabel.attributedText = attrString;
//
//        
//        
//    }
//    
    
 
    
    
    
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
