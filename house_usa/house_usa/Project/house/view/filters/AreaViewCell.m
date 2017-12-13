//
//  AreaViewCell.m
//  house_usa
//
//  Created by 林 建军 on 29/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "AreaViewCell.h"

@implementation AreaViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didEndExit:(id)sender {
    [_startArea resignFirstResponder];
    [_endArea resignFirstResponder];
    
    if([[_startArea.text trim] length]>0 && [[_endArea.text trim] length] > 0){
        self.areaBack(@{@"value": [NSString stringWithFormat:@"%@-%@",_startArea.text,_endArea.text]});
    }else if([[_startArea.text trim] length]>0 && [[_endArea.text trim] length] ==0){
        
        self.areaBack(@{@"value": [NSString stringWithFormat:@"-%@",_startArea.text]});
    }else if([[_startArea.text trim] length] == 0 && [[_endArea.text trim] length] > 0){
        
        self.areaBack(@{@"value": [NSString stringWithFormat:@"%@-",_endArea.text]});
    }else{
    
      self.areaBack(nil);
    }

}
@end
