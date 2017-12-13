//
//  PriceFilterView.m
//  house_usa
//
//  Created by 林 建军 on 13/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "PriceFilterView.h"
#import "PriceBtn.h"

@implementation PriceFilterView

-(instancetype)initWithFrame:(CGRect)frame setType:(NSInteger)type{
    
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        _type = type;
       
        
    }
    return self;
    
}

-(void)setPtype:(NSInteger)ptype{

    _ptype = ptype;
    
     [self initItemsView];
}

-( NSArray *)getnewLnag{
    
    NSArray *ds = nil;
    
    if(_type == 3){
        
        if(_ptype == 2){
            
            if([[self getMyLang] containsString:@"zh"]){
                
                ds = @[@{@"title":@"不限(单位：美元)",@"value":@{@"from":@"0"},@"tag":@"0"},@{@"title":@"0-1000美元",@"tag":@"1",@"value":@{@"from":@"0",@"to":@"1000"}},
                       @{@"title":@"1000-2000美元",@"tag":@"2",@"value":@{@"from":@"1000",@"to":@"2000"}},
                       @{@"title":@"2000-3000美元",@"tag":@"3",@"value":@{@"from":@"2000",@"to":@"3000"}},
                       @{@"title":@"3000美元+",@"tag":@"4",@"value":@{@"from":@"3000"}}
                       ];
            }else{
                
                ds =  @[@{@"title":@"ALL",@"value":@{@"from":@"0"},@"tag":@"0"},@{@"title":@"$0-$1000",@"tag":@"1",@"value":@{@"from":@"0",@"to":@"1000"}},
                        @{@"title":@"$1000-$2000",@"tag":@"2",@"value":@{@"from":@"1000",@"to":@"2000"}},
                        @{@"title":@"$2000-$3000",@"tag":@"3",@"value":@{@"from":@"2000",@"to":@"3000"}},
                        @{@"title":@"$3000+",@"tag":@"4",@"value":@{@"from":@"3000"}}
                        ];
                
            }

        
        }else{
        
        
            
            if([[self getMyLang] containsString:@"zh"]){
                
                ds = @[@{@"title":@"不限(单位：美元)",@"value":@{@"from":@"0"},@"tag":@"0"},@{@"title":@"0-50万美元",@"tag":@"1",@"value":@{@"from":@"0",@"to":@"500000"}},
                       @{@"title":@"50万-80万美元",@"tag":@"2",@"value":@{@"from":@"500000",@"to":@"800000"}},
                       @{@"title":@"80万-120万美元",@"tag":@"3",@"value":@{@"from":@"800000",@"to":@"1200000"}},
                       @{@"title":@"120万美元+",@"tag":@"4",@"value":@{@"from":@"1200000"}}
                       ];
            }else{
                
                ds =  @[@{@"title":@"ALL",@"value":@{@"from":@"0"},@"tag":@"0"},@{@"title":@"$0-$500000",@"tag":@"1",@"value":@{@"from":@"0",@"to":@"500000"}},
                        @{@"title":@"$500000-$800000",@"tag":@"2",@"value":@{@"from":@"500000",@"to":@"800000"}},
                        @{@"title":@"$800000-$1200000",@"tag":@"3",@"value":@{@"from":@"800000",@"to":@"1200000"}},
                        @{@"title":@"$1200000+",@"tag":@"4",@"value":@{@"from":@"1200000"}}
                        ];
                
            }

        
        }
        
        
        
        
        
    }else if(_type == 4){
        
        if([[self getMyLang] containsString:@"zh"]){
            
            ds = @[@{@"title":@"不限(单位：平方米)",@"tag":@"0",@"value":@{@"from":@"0"}}, @{@"title":@"0-100平方米",@"value":@{@"from":@"0",@"to":@"1076"},@"tag":@"1"},
                   @{@"title":@"100-200平方米",@"value":@{@"from":@"1076",@"to":@"2152"},@"tag":@"2"},
                   @{@"title":@"200-300平方米",@"value":@{@"from":@"2152",@"to":@"3228"},@"tag":@"3"},
                   @{@"title":@"300平方米+",@"value":@{@"from":@"3228"},@"tag":@"4"}
                   ];
        }else{
            
            ds =  @[@{@"title":@"ALL",@"value":@{@"from":@"0"}},@{@"title":@"0-1000",@"value":@{@"from":@"0",@"to":@"1000Sq.Ft"},@"tag":@"1"},
                    @{@"title":@"1000-2000Sq.Ft",@"value":@{@"from":@"1000",@"to":@"2000"},@"tag":@"2"},
                    @{@"title":@"2000-3000Sq.Ft",@"value":@{@"from":@"2000",@"to":@"3000"},@"tag":@"3"},
                    @{@"title":@"3000Sq.Ft+",@"value":@{@"from":@"3000"},@"tag":@"4"}
                    ];
            
        }
        
    }
    return ds;
}

-(void)initItemsView{
    NSArray *ds = [self getnewLnag];
    
    NSInteger tag = 3000000;
    if(_type == 4){
        tag = 4000000;
    }
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
            NSInteger tag = 3000000;
            if(_type == 4){
                tag = 4000000;
            }
            for (NSInteger  i = 0; i< [ds count] ; i++) {
                
                PriceBtn *butn  = [self viewWithTag:tag+i ];
                butn.nameLabel.selected= NO;
                
                
            }
            _selectedData = btn.data;
            btn.nameLabel.selected = YES;
            
        };
    }
    
    
    _surenBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, self.frame.size.height - 50, (ScreenWidth - 24), 40)];
    
    [_surenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSDictionary *lang = [self getMyLocal];
    [_surenBtn setTitle:lang[@"okLabel"] forState:UIControlStateNormal];
    
    [_surenBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [_surenBtn setBackgroundColor:GlobalTintColor];
    _surenBtn.layer.cornerRadius = 3;
    [self addSubview:_surenBtn];
    
    
    _startField = [[UITextField alloc] initWithFrame:CGRectMake(20, self.frame.size.height - 50, 80, 40)];
    
    _startField.layer.cornerRadius = 3;
    _startField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _startField.font = [UIFont systemFontOfSize:12];
    _startField.textAlignment = NSTextAlignmentCenter;
    _startField.placeholder = lang[@"minLabel"];
    _startField.layer.borderColor = [UIColor colorWithString:@"#dedede"].CGColor;
    _startField.layer.borderWidth = 1;
    _startField.backgroundColor = GlobalGrayColor;
    [_startField addTarget:self action:@selector(didEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
   // [self addSubview:_startField];
    
    
    
    
    UILabel *slabel = [[UILabel alloc] initWithFrame:CGRectMake(20+85, self.frame.size.height - 50, 20, 40)];
    slabel.text = @"~";
    
    slabel.textAlignment = NSTextAlignmentCenter;
    
    slabel.textColor = [UIColor colorWithString:@"#dedede"];
    
   // [self addSubview:slabel];
    
    
    
    _endField = [[UITextField alloc] initWithFrame:CGRectMake(20+85+25, self.frame.size.height - 50, 80, 40)];
    _endField.layer.cornerRadius = 3;
    _endField.layer.borderColor =  [UIColor colorWithString:@"#dedede"].CGColor;
    _endField.layer.borderWidth = 1;
     _endField.backgroundColor = GlobalGrayColor;
     _endField.placeholder = lang[@"maxLabel"];
    _endField.font = [UIFont systemFontOfSize:12];
    _endField.textAlignment = NSTextAlignmentCenter;
     _endField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  
    [_endField addTarget:self action:@selector(didEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[self addSubview:_endField];

    
}


- (void)didEndExit:(id)sender {
    [_startField resignFirstResponder];
    [_endField resignFirstResponder];
    
    
}

-(void)makeData{


}

-(void)search:(id)sender{
    self.hidden = YES;
    NSArray *ds = [self getnewLnag];
    
    
    
    NSInteger tag = 3000000;
    if(_type == 4){
        tag = 4000000;
    }
    
    for (NSInteger  i = 0; i< [ds count] ; i++) {
        
        PriceBtn *butn  = [self viewWithTag:tag+i ];
        if(butn.nameLabel.selected){
           
        }
        
        
    }
    
    
    _backAction(nil);
    
    
}
-(void)loadLang{
    NSArray *ds = [self getnewLnag];
    
    NSInteger tag = 3000000;
    if(_type == 4){
        tag = 4000000;
    }
    
    for (NSInteger  i = 0; i< [ds count] ; i++) {
        
        NSDictionary *data =  [ds objectAtIndex:i];
        
        PriceBtn *butn  = [self viewWithTag:tag+i ];
        [butn setData:data];
        
        
    }
    
    NSDictionary *lang = [self getMyLocal];
    [_surenBtn setTitle:lang[@"okLabel"] forState:UIControlStateNormal];
    
}

-(void)setSelectedData:(NSDictionary *)selectedData{
    
    
    NSArray *ds = [self getnewLnag];
    
    NSInteger tag = 3000000;
    if(_type == 4){
        tag = 4000000;
    }
    
    for (NSInteger  i = 0; i< [ds count] ; i++) {
        
        PriceBtn *butn  = [self viewWithTag:tag+i ];
        butn.nameLabel.selected= NO;
        
        
    }
    _selectedData = selectedData;
   
    if(selectedData){
    
        PriceBtn *butn  = [self viewWithTag:[selectedData[@"tag"]integerValue] + tag];
        butn.nameLabel.selected= YES;
    }
    
  


}

-(void)setDatas:(NSDictionary *)data{



}
@end
