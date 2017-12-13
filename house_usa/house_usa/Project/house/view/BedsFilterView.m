//
//  BedsFilterView.m
//  house_usa
//
//  Created by 林 建军 on 08/09/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BedsFilterView.h"
#import "PriceBtn.h"

@implementation BedsFilterView
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
      
        [self initItemsView];
        [self makeDatas];
        
    }
    return self;
    
}

-( NSArray *)getnewLnag{
    
    NSArray *ds = nil;
    
    if([[self getMyLang] containsString:@"zh"]){
        
        ds = @[@{@"title":@"不限",@"value":@""}, @{@"title":@"一居室以上",@"value":@"1"},
               @{@"title":@"二居室以上",@"value":@"2"},
               @{@"title":@"三居室以上",@"value":@"3"},
               @{@"title":@"四居室以上",@"value":@"4"},
               @{@"title":@"五居室以上",@"value":@"5"},
               @{@"title":@"六居室以上",@"value":@"6"}
               ];
    }else{
        
        ds =  @[@{@"title":@"ALL",@"value":@""}, @{@"title":@"1+",@"value":@"1"},
                @{@"title":@"2+",@"value":@"2"},
                @{@"title":@"3+",@"value":@"3"},
                @{@"title":@"4+",@"value":@"4"},
                @{@"title":@"5+",@"value":@"5"},
                @{@"title":@"6+",@"value":@"6"}
                ];
        
    }

    return ds;
}

-(void)initItemsView{
    NSArray *ds = [self getnewLnag];
    
    NSInteger tag = 2000000;
   
    
    for (NSInteger  i = 0; i< [ds count] ; i++) {
        
        NSDictionary *data =  [ds objectAtIndex:i];
        
        PriceBtn *butn  = [[PriceBtn alloc] initWithFrame:CGRectMake(0, i*(40+1), ScreenWidth, 40)];
        butn.tag = tag+i;
        
        butn.nameLabel.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [butn.nameLabel setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        butn.backgroundColor = [UIColor whiteColor];
        butn.nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [butn setData:data];
        
        if(i == 0){
            // [butn.nameLabel setTitleColor:GlobalTintColor forState:UIControlStateNormal];
            butn.isAll = YES;
            butn.nameLabel.selected = YES;
        }else{
            butn.isAll = NO;
            
        }
        
        [self addSubview:butn];
        UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(12, i*(40+1)+40, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithString:@"#f7f7f7"];
        [self addSubview:lineView];
        
        butn.backAction = ^(PriceBtn* btn){
            NSInteger tag = 2000000;
           
            for (NSInteger  i = 0; i< [ds count] ; i++) {
                
                PriceBtn *butn  = [self viewWithTag:tag+i ];
                butn.nameLabel.selected= NO;
                
                
            }
            _data = btn.data;
            btn.nameLabel.selected = YES;
            
        };
  
    
    }
    
    
    _surenBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, self.frame.size.height - 50, ScreenWidth - 24, 44)];
    
    [_surenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSDictionary *lang = [self getMyLocal];
    [_surenBtn setTitle:lang[@"okLabel"] forState:UIControlStateNormal];
    
    [_surenBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [_surenBtn setBackgroundColor:GlobalTintColor];
    _surenBtn.layer.cornerRadius = 3;
    [self addSubview:_surenBtn];
}

-(void)makeDatas{
    
    
    
    
}

-(void)search:(id)sender{
    self.hidden = YES;
    
    [self makeDatas];
    
    
    _backAction(nil);
    
    
}
-(void)setData:(NSDictionary *)data{
    NSInteger tag = 2000000;
      NSArray *ds = [self getnewLnag];
    for (NSInteger  i = 0; i< [ds count] ; i++) {
        
        PriceBtn *butn  = [self viewWithTag:tag+i ];
        butn.nameLabel.selected= NO;
        
    }

    _data = data;
    
    if(data){
        
        PriceBtn *butn  = [self viewWithTag:[data[@"value"]integerValue] + tag];
        butn.nameLabel.selected= YES;
    }
    

}

@end

