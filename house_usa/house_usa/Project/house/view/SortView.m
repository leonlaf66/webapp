//
//  SortView.m
//  house_usa
//
//  Created by 林 建军 on 05/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "SortView.h"

@implementation SortView

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
        self.backgroundColor = [UIColor colorWithString:@"#f7f7f7"];
        [self initItemsView];
    
    }
    return self;

}

-(void)initItemsView{

    SortBtn *bnt1 = [[SortBtn alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, 44)];
    [bnt1 setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    [bnt1 setTitle:@"默认排序" forState:UIControlStateNormal];
     bnt1.titleLabel.font = [UIFont systemFontOfSize:14];
    bnt1.backgroundColor = [UIColor whiteColor];
     [bnt1 setTitleColor:GlobalTintColor forState:UIControlStateSelected];
     bnt1.selected = YES;
    bnt1.tag = 777771;
    bnt1.sortName = nil;
     bnt1.sortValue = nil;
    [self addSubview:bnt1];
    
    
    SortBtn *bnt2 = [[SortBtn alloc] initWithFrame:CGRectMake(0, 46, ScreenWidth, 44)];
    [bnt2 setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    [bnt2 setTitle:@"上市时间" forState:UIControlStateNormal];
    bnt2.titleLabel.font = [UIFont systemFontOfSize:14];
     bnt2.backgroundColor = [UIColor whiteColor];
    [bnt2 setTitleColor:GlobalTintColor forState:UIControlStateSelected];
    bnt2.selected = NO;
       bnt2.tag = 777772;
    bnt2.sortName = @"days-market";
    bnt2.sortValue = @"0";
    [self addSubview:bnt2];
    
    
    SortBtn *bnt3 = [[SortBtn alloc] initWithFrame:CGRectMake(0, 91, ScreenWidth, 44)];
    [bnt3 setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    [bnt3 setTitle:@"价格从高到底" forState:UIControlStateNormal];
    bnt3.titleLabel.font = [UIFont systemFontOfSize:14];
    bnt3.backgroundColor = [UIColor whiteColor];
    [bnt3 setTitleColor:GlobalTintColor forState:UIControlStateSelected];
    bnt3.selected = NO;
    bnt3.tag = 777773;
    bnt3.sortName = @"price";
    bnt3.sortValue = @"2";
    [self addSubview:bnt3];
    
    
    SortBtn *bnt4 = [[SortBtn alloc] initWithFrame:CGRectMake(0, 136, ScreenWidth, 44)];
    [bnt4 setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    [bnt4 setTitle:@"价格从低到高" forState:UIControlStateNormal];
    bnt4.titleLabel.font = [UIFont systemFontOfSize:14];
    bnt4.backgroundColor = [UIColor whiteColor];
    [bnt4 setTitleColor:GlobalTintColor forState:UIControlStateSelected];
    bnt4.selected = NO;
    bnt4.tag = 777774;
    bnt4.sortName = @"price";
    bnt4.sortValue = @"1";
    [self addSubview:bnt4];
    
    
    SortBtn *bnt5 = [[SortBtn alloc] initWithFrame:CGRectMake(0, 181, ScreenWidth, 44)];
    [bnt5 setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    [bnt5 setTitle:@"卧室从多到少" forState:UIControlStateNormal];
    bnt5.titleLabel.font = [UIFont systemFontOfSize:14];
    bnt5.backgroundColor = [UIColor whiteColor];
    [bnt5 setTitleColor:GlobalTintColor forState:UIControlStateSelected];
    bnt5.selected = NO;
    bnt5.tag = 777775;
    bnt5.sortName = @"beds";
    bnt5.sortValue = @"3";
    [self addSubview:bnt5];
    

    SortBtn *bnt6 = [[SortBtn alloc] initWithFrame:CGRectMake(0, 226, ScreenWidth, 44)];
    [bnt6 setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    [bnt6 setTitle:@"卧室从少到多" forState:UIControlStateNormal];
    bnt6.titleLabel.font = [UIFont systemFontOfSize:14];
    bnt6.backgroundColor = [UIColor whiteColor];
    [bnt6 setTitleColor:GlobalTintColor forState:UIControlStateSelected];
    bnt6.selected = NO;
    bnt6.tag = 777776;
    bnt6.sortName = @"beds";
    bnt6.sortValue = @"4";
    [self addSubview:bnt6];

}
@end
