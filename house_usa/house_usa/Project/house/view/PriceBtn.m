//
//  PriceBtn.m
//  house_usa
//
//  Created by 林 建军 on 13/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "PriceBtn.h"

@implementation PriceBtn



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _nameLabel =   [[UIButton alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth - 12, 40)];
        
        [_nameLabel addTarget:self action:@selector(changeStatea:) forControlEvents:UIControlEventTouchUpInside];
        
        [_nameLabel setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        
          [_nameLabel setTitleColor:GlobalTintColor forState:UIControlStateSelected];
        [self addSubview:_nameLabel];
        
    }
    return self;
    
}



-(void)changeStatea:(id)sender{
    UIButton *btn = (UIButton *)sender;
     _backAction(self);
    
    
}

-(void)setData:(NSDictionary *)data{
    
    _data = data;
    
    [_nameLabel setTitle:_data[@"title"] forState:UIControlStateNormal];
}

@end

