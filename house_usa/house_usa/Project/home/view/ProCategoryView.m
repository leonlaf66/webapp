//
//  ProCategoryView.m
//  house_usa
//
//  Created by 林 建军 on 27/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "ProCategoryView.h"

@implementation ProCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setData:(NSDictionary *)data{

    _data = data;
}




-(instancetype)initWithFrame:(CGRect)frame setData:(NSDictionary *)data{
   
    self = [super initWithFrame:frame];
    if(self){
    
        _data = data;
        
        _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 50)/2, 5, 50, 50)];
        
        [self addSubview:_titleImage];
        
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, self.frame.size.width, 15)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithString:@"#333333"];
        
        _titleLabel.text = _data[@"name"];
        
        
        
        
       NSData* xmlData = [_data[@"icon"] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *result = [[NSString alloc] initWithData:xmlData  encoding:NSUTF8StringEncoding];
        
        
        NSString* encodedString = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [_titleImage sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:nil];

        [self addSubview:_titleImage];
        
        [self addSubview:_titleLabel];

    }
     return self;
}

@end
