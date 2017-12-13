//
//  TypeFilterView.m
//  house_usa
//
//  Created by 林 建军 on 12/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "TypeFilterView.h"

@implementation TypeFilterView



-(instancetype)initWithFrame:(CGRect)frame setType:(NSInteger)type{
  
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
         _type = type;
        [self initItemsView];
        _selectedDatas = [NSMutableArray array];
         [self makeDatas];
       
    }
    return self;

}

-( NSArray *)getnewLnag{
    
     NSArray *ds = nil;
    
    if(_type == 1){
        if([[self getMyLang] containsString:@"zh"]){
            
            ds = @[@{@"title":@"全部",@"value":@""},
                   @{@"title":@"独栋别墅",@"value":@"sf"},
                   @{@"title":@"多家庭",@"value":@"mf"},
                   @{@"title":@"公寓",@"value":@"cc"},
                   @{@"title":@"商业用房",@"value":@"ci"},
                   @{@"title":@"营业用房",@"value":@"bu"},
                   @{@"title":@"土地",@"value":@"ld"}
                   ];
        }else{
            
            ds =  @[@{@"title":@"ALL",@"value":@""},
                    @{@"title":@"Single Family",@"value":@"sf"},
                    @{@"title":@"Multi Family",@"value":@"mf"},
                    @{@"title":@"Condominium",@"value":@"cc"},
                    @{@"title":@"Commercial",@"value":@"ci"},
                    @{@"title":@"Business Oportunty",@"value":@"bu"},
                    @{@"title":@"Land",@"value":@"ld"}
                    ];
            
        }
        

    
    
    }else if(_type == 2){
    
        if([[self getMyLang] containsString:@"zh"]){
            
            ds = @[@{@"title":@"不限",@"value":@""}, @{@"title":@"一居室以上",@"value":@"1"},
                    @{@"title":@"二居室以上",@"value":@"2"},
                    @{@"title":@"三居室以上",@"value":@"3"},
                    @{@"title":@"四居室以上",@"value":@"4"},
                    @{@"title":@"五居室以上",@"value":@"5"},
                    @{@"title":@"六居室以上",@"value":@"6+"}
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
    
    }
        return ds;
}

-(void)initItemsView{
    NSArray *ds = [self getnewLnag];
    
    NSInteger tag = 1000000;
    if(_type == 2){
     tag = 2000000;
    }
    
    
    
    
        for (NSInteger  i = 0; i< [ds count] ; i++) {
        
        NSDictionary *data =  [ds objectAtIndex:i];
        
        TypeBtn *butn  = [[TypeBtn alloc] initWithFrame:CGRectMake(0, i*(40+1), ScreenWidth, 40)];
        butn.tag = tag+i;
        
        butn.nameLabel.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [butn.nameLabel setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        butn.backgroundColor = [UIColor whiteColor];
        butn.nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
         [butn setData:data];
      
        if(i == 0){
            [butn.nameLabel setTitleColor:GlobalTintColor forState:UIControlStateNormal];
             butn.isAll = YES;
        }else{
             butn.isAll = NO;

        }
            
            if(i == 1 || i == 2 || i == 3){
                butn.checkBtn.selected = YES;
            }
        
        [self addSubview:butn];
            UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(12, i*(40+1)+40, ScreenWidth, 1)];
            lineView.backgroundColor = [UIColor colorWithString:@"#f7f7f7"];
          [self addSubview:lineView];
            
            butn.backAction = ^(BOOL first){
                NSInteger tag = 1000000;
                if(_type == 2){
                    tag = 2000000;
                }

                if(first){
                    for (NSInteger  i = 0; i< [ds count] ; i++) {
    
                        
                        TypeBtn *butn  = [self viewWithTag:tag+i ];
                        
                        if(i == 0){
                            butn.checkBtn.selected = YES;

                        }else{
                           butn.checkBtn.selected = NO;
                        
                        }
                     
                        
                        
                    }
                
                }else{
                
                      TypeBtn *butn  = [self viewWithTag:tag ];
                    
                      butn.checkBtn.selected = NO;
                }
            
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
    
     NSArray *ds = [self getnewLnag];

    [_selectedDatas removeAllObjects];
    
    NSInteger tag = 1000000;
    if(_type == 2){
        tag = 2000000;
    }
    
    for (NSInteger  i = 0; i< [ds count] ; i++) {
        
        TypeBtn *butn  = [self viewWithTag:tag+i ];
        if(butn.checkBtn.selected){
            [_selectedDatas addObject:butn.data];
        }
        
        
    }


}

- (NSMutableArray *)selectedDatas
{
    [self makeDatas];
    return _selectedDatas;
}

-(void)search:(id)sender{
    self.hidden = YES;
    
    [self makeDatas];
    
    
    _backAction(nil);
    
    
}
-(void)loadLang{
       NSArray *ds = [self getnewLnag];
    
    NSInteger tag = 1000000;
    if(_type == 2){
        tag = 2000000;
    }

    for (NSInteger  i = 0; i< [ds count] ; i++) {
        
        NSDictionary *data =  [ds objectAtIndex:i];
        
        TypeBtn *butn  = [self viewWithTag:tag+i ];
        [butn setData:data];
        
        
    }
    
    NSDictionary *lang = [self getMyLocal];
 [_surenBtn setTitle:lang[@"okLabel"] forState:UIControlStateNormal];

}

-(void)setTypes:(NSArray *)types{
    
    NSInteger tag = 1000000;
   
    
    for (NSInteger  i = 0; i< 7 ; i++) {
        
        TypeBtn *butn  = [self viewWithTag:tag+i ];
        butn.checkBtn.selected = NO;
        
        
    }



        for (NSDictionary * type in types) {
            
            if([type[@"value"] isEqualToString:@"sf"]){
                TypeBtn *btn = (TypeBtn *)[self viewWithTag:1000001];
                
                btn.checkBtn.selected = YES;
            }else  if([type[@"value"] isEqualToString:@"mf"]){
                TypeBtn *btn = (TypeBtn *)[self viewWithTag:1000002];
                
                btn.checkBtn.selected = YES;
            }else  if([type[@"value"] isEqualToString:@"cc"]){
                TypeBtn *btn = (TypeBtn *)[self viewWithTag:1000003];
                
                btn.checkBtn.selected = YES;
            }else  if([type[@"value"] isEqualToString:@"ci"]){
                TypeBtn *btn = (TypeBtn *)[self viewWithTag:1000004];
                
                btn.checkBtn.selected = YES;
            }else  if([type[@"value"] isEqualToString:@"bu"]){
                TypeBtn *btn = (TypeBtn *)[self viewWithTag:1000005];
                
                btn.checkBtn.selected = YES;
            }else  if([type[@"value"] isEqualToString:@"ld"]){
                TypeBtn *btn = (TypeBtn *)[self viewWithTag:1000006];
                
                btn.checkBtn.selected = YES;
            }
            
            
        }
 [self makeDatas];
}

@end
