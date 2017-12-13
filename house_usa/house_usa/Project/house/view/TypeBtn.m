//
//  TypeBtn.m
//  house_usa
//
//  Created by 林 建军 on 12/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "TypeBtn.h"

@implementation TypeBtn

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
        [self addSubview:_nameLabel];
        
        CGRect frame = CGRectMake( ScreenWidth - 50,10, 20, 20);
        _checkBtn = [[UIButton alloc] initWithFrame:frame];
        _checkBtn.layer.cornerRadius = 1;
        _checkBtn.layer.borderWidth = 0.5;
        _checkBtn.layer.borderColor = [UIColor colorWithString:@"#dedede"].CGColor;
        
       
         [_checkBtn setBackgroundImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
         [_checkBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_checkBtn addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_checkBtn aboveSubview:_nameLabel];
    }
    return self;

}

-(void)changeState:(id)sender{
    _checkBtn.selected = !_checkBtn.selected;
    
    if( _checkBtn.selected){
        _backAction(_isAll);
        
    }

}

-(void)changeStatea:(id)sender{
    _checkBtn.selected = !_checkBtn.selected;
    
    if( _checkBtn.selected){
        _backAction(_isAll);
    
    }
    
}

-(void)setData:(NSDictionary *)data{

    _data = data;
    
    [_nameLabel setTitle:_data[@"title"] forState:UIControlStateNormal];
}

@end
