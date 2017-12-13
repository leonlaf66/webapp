//
//  MyNavigationBar.m
//  decoration
//
//  Created by 林 建军 on 13/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "MyNavigationBar.h"
#import "UIColor+XTExtension.h"
@implementation MyNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize bgView;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]||
                [view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                self.bgView = view;
            }
        }
    }
    return self;
}


- (void)show:(CGFloat)alp
{
    [UIView animateWithDuration:0.2 animations:^{
        //self.bgView.alpha = alp;
    }];
}
/**
 *   隐藏
 */
- (void)hidden
{
    //self.bgView.hidden = YES;
}


@end
