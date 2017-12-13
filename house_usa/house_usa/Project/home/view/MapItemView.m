//
//  MapItemView.m
//  house_usa
//
//  Created by 林 建军 on 21/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "MapItemView.h"

@implementation MapItemView

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
     
        self.layer.cornerRadius = 2;
        self.userInteractionEnabled = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:9];
         _titleLabel.backgroundColor = GlobalTintColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
          _titleLabel.layer.cornerRadius = 2;
        _titleLabel.clipsToBounds = YES;
          [self addSubview:_titleLabel];
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.size.width, 0, 60, frame.size.height)];
        _typeLabel.font = [UIFont systemFontOfSize:9];
        _typeLabel.backgroundColor = [UIColor whiteColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.textColor = [UIColor colorWithString:@"#333333"];
        _typeLabel.layer.cornerRadius = 2;
        
        [self addSubview:_typeLabel];
      
    
    }
    return self;
}

-(double)getWidthWithString:(NSString*)str font:(UIFont*)font{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize detailSize = [str sizeWithAttributes:dict];
    return detailSize.width;
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
      CGRect frame = self.frame;
      _titleLabel.text =  _data.price;
    if(_selected){
      
       _titleLabel.backgroundColor = GlobalRedColor;
      //  NSDictionary *lang = [self getMyLocal];
        
         _typeLabel.text =  _data.type;
      

      //  frame.origin.x = -20;
    }else{
       _titleLabel.backgroundColor = GlobalTintColor;
        _typeLabel.text = @"";
     // frame.origin.x = -10;
    }
    
    
    
    double width = [self getWidthWithString:_typeLabel.text font:[UIFont systemFontOfSize:9]];
    if(width>0){
        width +=10;
    }
    
    double awidth = [self getWidthWithString: _titleLabel.text font:[UIFont systemFontOfSize:9]] + 10;
    
    
  
    
    frame.size.width = width + awidth;
    
  
    
    self.frame = frame;
    
    _titleLabel.frame = CGRectMake(0, 0, awidth, self.frame.size.height);
    
    _typeLabel.frame = CGRectMake(awidth, 0, width, self.frame.size.height);
    

}
-(void)setData:(FateModel *)data{
    _data = data;
   
      _titleLabel.text =  _data.price;
      _typeLabel.text =  @"";
//    
//    if(data[@"price"] != nil){
//    
//      _titleLabel.text =  data[@"price"];
//    }else{
//        _titleLabel.text =  data[@"list_price"];
//
//    
//    }
    
    
}
@end
