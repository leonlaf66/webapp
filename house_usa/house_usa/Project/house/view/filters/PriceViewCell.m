//
//  PriceViewCell.m
//  house_usa
//
//  Created by 林 建军 on 29/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "PriceViewCell.h"

@implementation PriceViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didEndExit:(id)sender {
    [_startPrice resignFirstResponder];
    [_endPrice resignFirstResponder];
    
    if([[_startPrice.text trim] length]>0 && [[_endPrice.text trim] length]>0){
        self.priceBack(@{@"value": [NSString stringWithFormat:@"%@-%@",_startPrice.text,_endPrice.text]});
    }else if([[_startPrice.text trim] length]>0 && [[_endPrice.text trim] length] == 0){
    
     self.priceBack(@{@"value": [NSString stringWithFormat:@"-%@",_startPrice.text]});
    }else if([[_startPrice.text trim] length] == 0 && [[_endPrice.text trim] length]>0){
        
        self.priceBack(@{@"value": [NSString stringWithFormat:@"%@-",_endPrice.text]});
    }else{
        
        self.priceBack(nil);
    }
}

@end
