//
//  MyBMKPinAnnotationView.m
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "MyBMKPinAnnotationView.h"

@implementation MyBMKPinAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
 
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    return inside;
}

-(instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
       // [self setBounds:CGRectMake(0, 0, 140, 45)];
       
        //[self initWithContentViews];//
    }
    
    return self;
}
-(void)setMapItemView:(MapItemView *)mapItemView{

    _mapItemView = mapItemView;
    _mapItemView.selected = NO;
    

    
    [self addSubview:_mapItemView];
}

-(void)setAselected:(BOOL)aselected{
    _aselected = aselected;
    
    _mapItemView.selected = aselected;
    
    if(_aselected){
    
      self.image = [UIImage imageNamed:@"downs-red"];
    }else{
      self.image = [UIImage imageNamed:@"downs"];
    
    }

}
@end
