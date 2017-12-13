//
//  NewsListViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HouseFilterViewController.h"

@interface HouseFilterViewController ()<UIScrollViewDelegate>{
    
}
@property(nonatomic,strong)  NSArray *datas;

@property(nonatomic,strong)  NSArray *titleDatas;



@end

@implementation HouseFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = 0;
    _scrollView.delegate = self;
    if(_map){
        _scrollView.contentSize = CGSizeMake(200, 105*7+50);
         _width.constant = ScreenWidth - 100;
    
    }else{
       _scrollView.contentSize = CGSizeMake(ScreenWidth, 105*7+50);
        _width.constant = ScreenWidth;
    }
   
    _typeDatas = [NSMutableArray array];
    [self initData];

    [self loadsView];
    
    
  }

-(void)initData{

    if([[self getMyLang] containsString:@"zh"]){
        
        _titleDatas = @[@"类型",@"卧室",@"价格（美元）",@"面积（平方米）",@"卫生间",@"车位",@"上市天数"];
        
        _datas = @[@[@{@"title":@"独栋别墅",@"value":@"sf"},
                     @{@"title":@"多家庭",@"value":@"mf"},
                     @{@"title":@"公寓",@"value":@"cc"},
                     @{@"title":@"商业用房",@"value":@"ci"},
                     @{@"title":@"营业用房",@"value":@"bu"},
                     @{@"title":@"土地",@"value":@"ld"}
                     ],@[ @{@"title":@"一居室以上",@"value":@"1"},
                          @{@"title":@"二居室以上",@"value":@"2"},
                          @{@"title":@"三居室以上",@"value":@"3"},
                          @{@"title":@"四居室以上",@"value":@"4"},
                          @{@"title":@"五居室以上",@"value":@"5"},
                          @{@"title":@"六居室以上",@"value":@"6+"}
                          ],@[@{@"title":@"0-50万美元",@"tag":@"1",@"value":@{@"from":@"0",@"to":@"500000"}},
                              @{@"title":@"50万-80万美元",@"tag":@"2",@"value":@{@"from":@"500000",@"to":@"800000"}},
                              @{@"title":@"80万-120万美元",@"tag":@"3",@"value":@{@"from":@"800000",@"to":@"1200000"}},
                              @{@"title":@"120万美元+",@"tag":@"4",@"value":@{@"from":@"1200000"}}
                              ],@[@{@"title":@"0-100平方米",@"value":@{@"from":@"0",@"to":@"1076"},@"tag":@"1"},
                                  @{@"title":@"100-200平方米",@"value":@{@"from":@"1076",@"to":@"2152"},@"tag":@"2"},
                                  @{@"title":@"200-300平方米",@"value":@{@"from":@"2152",@"to":@"3228"},@"tag":@"3"},
                                  @{@"title":@"300平方米+",@"value":@{@"from":@"3228"},@"tag":@"4"}
                                  ],@[@{@"title":@"1+",@"value":@"1"},
                                      @{@"title":@"2+",@"value":@"2"},
                                      @{@"title":@"3+",@"value":@"3"},
                                      @{@"title":@"4+",@"value":@"4"},
                                      @{@"title":@"5+",@"value":@"5+"}],@[@{@"title":@"1",@"value":@"1"},
                                                           @{@"title":@"2",@"value":@"2"},
                                                           @{@"title":@"3",@"value":@"3"},
                                                           @{@"title":@"4",@"value":@"4"},
                                                           @{@"title":@"5+",@"value":@"5"}],@[@{@"title":@"新上市",@"value":@"1"},
                                                                                @{@"title":@"小于7天",@"value":@"2"},
                                                                                @{@"title":@"小于30天",@"value":@"3"}]];
    }else{
        _titleDatas = @[@"Type",@"Beds",@"Price($)",@"Living Area（Sq.Ft）",@"Baths",@"Parking",@"Days on Market"];
        
        _datas = @[@[@{@"title":@"Single Family",@"value":@"sf"},
                     @{@"title":@"Multi Family",@"value":@"mf"},
                     @{@"title":@"Condominium",@"value":@"cc"},
                     @{@"title":@"Commercial",@"value":@"ci"},
                     @{@"title":@"Business Oportunty",@"value":@"bu"},
                     @{@"title":@"Land",@"value":@"ld"}
                     ],@[ @{@"title":@"1+",@"value":@"1"},
                          @{@"title":@"2+",@"value":@"2"},
                          @{@"title":@"3+",@"value":@"3"},
                          @{@"title":@"4+",@"value":@"4"},
                          @{@"title":@"5+",@"value":@"5"},
                          @{@"title":@"6+",@"value":@"6"}
                          ],@[@{@"title":@"$0-$500000",@"tag":@"1",@"value":@{@"from":@"0",@"to":@"500000"}},
                              @{@"title":@"$500000-$800000",@"tag":@"2",@"value":@{@"from":@"500000",@"to":@"800000"}},
                              @{@"title":@"$800000-$1200000",@"tag":@"3",@"value":@{@"from":@"800000",@"to":@"1200000"}},
                              @{@"title":@"$1200000+",@"tag":@"4",@"value":@{@"from":@"1200000"}}
                              ],@[@{@"title":@"0-1000",@"value":@{@"from":@"0",@"to":@"1000"},@"tag":@"1"},
                                  @{@"title":@"1000-2000",@"value":@{@"from":@"1000",@"to":@"2000"},@"tag":@"2"},
                                  @{@"title":@"2000-3000",@"value":@{@"from":@"2000",@"to":@"3000"},@"tag":@"3"},
                                  @{@"title":@"3000+",@"value":@{@"from":@"3000"},@"tag":@"4"}
                                  ],@[@{@"title":@"1",@"value":@"1"},
                                      @{@"title":@"2",@"value":@"2"},
                                      @{@"title":@"3",@"value":@"3"},
                                      @{@"title":@"4",@"value":@"4"},
                                      @{@"title":@"5+",@"value":@"5+"}],
                   @[@{@"title":@"1+",@"value":@"1"},
                     @{@"title":@"2+",@"value":@"2"},
                     @{@"title":@"3+",@"value":@"3"},
                     @{@"title":@"4+",@"value":@"4"},
                     @{@"title":@"5+",@"value":@"5"}],@[@{@"title":@"New",@"value":@"1"},
                                                                                @{@"title":@"Less than 7 days",@"value":@"2"},
                                                                                @{@"title":@"Less than 30 days",@"value":@"3"}]];
        
    }
}
-(void)loadData{

    [self initData];

}
-(void)loadDataNext{

    
    [self loadData];
    NSInteger row = 0;
    
    //   NSArray *cdata = [_datas objectAtIndex:row];
    for ( NSArray *cdata in _datas) {
        NSString *myTitle = [_titleDatas objectAtIndex:row];
        if(row == 0){
            _typeCell.titleLabel.text = myTitle;
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                UIButton *btn = ( UIButton *)[_typeCell viewWithTag:10000+i ];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
              
            }
        } else if(row == 1){
            
            _bedsCell.titleLabel.text = myTitle;
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                UIButton *btn = ( UIButton *)[_bedsCell viewWithTag:20000+i ];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
            }
        }else if(row == 2){
            _priceCell.titleLabel.text = myTitle;
            
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                UIButton *btn = ( UIButton *)[_priceCell viewWithTag:30000+i ];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
            }
            
            [_scrollView addSubview:_priceCell];
        }else if(row == 3){
            
            _areaCell.titleLabel.text = myTitle;
          
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                UIButton *btn = ( UIButton *)[_areaCell viewWithTag:40000+i ];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
            }
            
            [_scrollView addSubview:_areaCell];
        }else if(row == 4){
            
            _bathCell.titleLabel.text = myTitle;
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                UIButton *btn = ( UIButton *)[_bathCell viewWithTag:50000+i ];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
              
            }
            
            
            [_scrollView addSubview:_bathCell];
        }else if(row == 5){
            
            _parkingCell.titleLabel.text = myTitle;
        
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                UIButton *btn = ( UIButton *)[_parkingCell viewWithTag:60000+i ];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
            }
            
            [_scrollView addSubview:_parkingCell];
        }else if(row == 6){

            _daysCell.titleLabel.text = myTitle;
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                UIButton *btn = ( UIButton *)[_daysCell viewWithTag:70000+i ];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
               
            }
            
            [_scrollView addSubview:_daysCell];
        }
        
        row++;
    }
    
}

-(void)loadsView{

    [self initItemsView];

}
-(void)loadByType:(NSInteger)type{
    _type = type;
    [self loadDataNext];
    CGPoint position = CGPointMake(0, (_type - 1)*105);
    
    [_scrollView setContentOffset:position animated:YES];
}
-(void)reloadDatas:(NSInteger)type{
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadDataWithIndex:(NSInteger)index{
   
    
}

-(void)setAction{
    
    for (NSInteger i = 10000; i < 10006; i++) {
        
        FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
        obtn.selected = NO;
        [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
        [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        
        
        
    }
    
        for (NSInteger i = 20000; i < 20006; i++) {
          
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                 obtn.selected = NO;
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        
            
            
        }

        for (NSInteger i = 30000; i < 30006; i++) {
          
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
            obtn.selected = NO;
            
            
        }

        
        for (NSInteger i = 40000; i < 40005; i++) {
            
          
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
              obtn.selected = NO;
            
        }

        
        for (NSInteger i = 50000; i < 50006; i++) {
            
          
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
         
              obtn.selected = NO;
            
        }

        
        for (NSInteger i = 60000; i < 60006; i++) {
          
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
             obtn.selected = NO;
            
            
        }
     
        for (NSInteger i = 70000; i < 70004; i++) {
            
           
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
              obtn.selected = NO;
        }
    
    [_typeDatas removeAllObjects];
    _bedsData = nil;
    _priceData = nil;
    _areaData = nil;
    _bathData = nil;
    _parkingData = nil;
    _daysData = nil;

}
-(NSMutableArray *)typeDatas{

    [_typeDatas removeAllObjects];
    
    for (NSInteger i = 10000; i < 10006; i++) {
        
        FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
        if(obtn.selected){
            [_typeDatas addObject:obtn.data];
        }
    }

    return _typeDatas;
}

-(void)setTypes:(NSArray *)types{
    
    
    for (NSInteger i = 10000; i < 10006; i++) {
        
        FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
        obtn.selected = NO;
        
        
        [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
        [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    }
    
    for (NSDictionary * type in types) {
        
        if([type[@"value"] isEqualToString:@"sf"]){
            FilterButton *btn = [_typeCell viewWithTag:10000];
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            btn.selected = YES;
        }else  if([type[@"value"] isEqualToString:@"mf"]){
            FilterButton *btn = [_typeCell viewWithTag:10001];
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
             btn.selected = YES;
        }else  if([type[@"value"] isEqualToString:@"cc"]){
            FilterButton *btn = [_typeCell viewWithTag:10002];
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
             btn.selected = YES;
        }else  if([type[@"value"] isEqualToString:@"ci"]){
            FilterButton *btn = [_typeCell viewWithTag:10003];
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            btn.selected = YES;
        }else  if([type[@"value"] isEqualToString:@"bu"]){
            FilterButton *btn = [_typeCell viewWithTag:10004];
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            btn.selected = YES;
        }else  if([type[@"value"] isEqualToString:@"ld"]){
            FilterButton *btn = [_typeCell viewWithTag:10005];
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            btn.selected = YES;
        }
        
        
    }
    
    [_typeDatas removeAllObjects];
    
    for (NSInteger i = 10000; i < 10006; i++) {
        
        FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
        if(obtn.selected){
            [_typeDatas addObject:obtn.data];
        }
    }
    

}

-(void)setPrice:(NSDictionary *)prices{
    
    
    for (NSInteger i = 30000; i < 30004; i++) {
            FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i + 30000];
            [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
            [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        
    }
    
    if(prices != nil){
       
       FilterButton *btn = ( FilterButton *)[self.scrollView viewWithTag: [prices[@"tag"] integerValue] + 30000 - 1];
        [btn setBackgroundColor:GlobalTintColor];
        [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        _priceData = prices;
    }


}

-(void)setArea:(NSDictionary *)bs{
    
    for (NSInteger i = 40000; i < 40005; i++) {
        FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i];
        [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
        [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        
    }
    
    if(bs != nil){
        
        FilterButton *btn = ( FilterButton *)[self.scrollView viewWithTag: [bs[@"tag"] integerValue] + 40000 - 1];
        [btn setBackgroundColor:GlobalTintColor];
        [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        _areaData = bs;
    }
    

}

-(void)setBeds:(NSDictionary *)bs{
    for (NSInteger i = 20000; i < 20006; i++) {
        FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i];
        [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
        [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        
    }
    
    if(bs != nil){
        
        FilterButton *btn = ( FilterButton *)[self.scrollView viewWithTag: [bs[@"value"] integerValue] + 20000 - 1];
        [btn setBackgroundColor:GlobalTintColor];
        [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        _bedsData = bs;
    }

    
}

-(void)typeAction:(id)sender{
    FilterButton *btn = sender;
    btn.selected =  !btn.selected;
    if(btn.tag>=10000 && btn.tag<=10005){
        
        if(!btn.selected){
        
            [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
            [btn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        }else{
        
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        [_typeDatas removeAllObjects];
     
        for (NSInteger i = 10000; i < 10006; i++) {
            
           FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
            if(obtn.selected){
                [_typeDatas addObject:obtn.data];
            }
        }
      
          //_ty = btn.data;
    }else  if(btn.tag>=20000 && btn.tag<=20005){
       
        for (NSInteger i = 20000; i < 20006; i++) {
            if(btn.tag != i){
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
            }
           
            
        }
        
        if(btn.selected){
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            _bedsData = btn.data;
        
        }else{
            [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
            [btn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        }
        
    }else  if(btn.tag>=30000 && btn.tag<=30004){
        for (NSInteger i = 30000; i < 30006; i++) {
            if(btn.tag != i){
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
            }
           
            
        }
        if(btn.selected){
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            _priceData = btn.data;
            _priceCell.startPrice.text = @"";
            _priceCell.endPrice.text = @"";
            
        }else{
            
            [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
            [btn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
            
        }
    }else  if(btn.tag>=40000 && btn.tag<=40004){
       
        for (NSInteger i = 40000; i < 40005; i++) {
            
            if(btn.tag != i){
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
            }
           
            
        }
        if(btn.selected){
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            _areaData = btn.data;
            _areaCell.startArea.text = @"";
              _areaCell.endArea.text = @"";
            
        }else{
            [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
            [btn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        }
    }else  if(btn.tag>=50000 && btn.tag<=50006){
        
        for (NSInteger i = 50000; i < 50006; i++) {
            
            if(btn.tag != i){
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
            }
           
            
        }
        if(btn.selected){
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            _bathData = btn.data;
            
        }else{
            [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
            [btn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        }
    }else  if(btn.tag>=60000 && btn.tag<=60006){
        
        for (NSInteger i = 60000; i < 60006; i++) {
            
            if(btn.tag != i){
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
            }
           
            
        }
       
        if(btn.selected){
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            _parkingData = btn.data;
            
        }else{
            [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
            [btn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        }
    }else  if(btn.tag>=70000 && btn.tag<=70004){
        for (NSInteger i = 70000; i < 70004; i++) {
            
            if(btn.tag != i){
                FilterButton *obtn = ( FilterButton *)[self.scrollView viewWithTag:i ];
                [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
            }
           
        }
        if(btn.selected){
            [btn setBackgroundColor:GlobalTintColor];
            [btn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            _daysData = btn.data;
            
        }else{
            [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
            [btn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        }
    }

}

// Customize the appearance of table view cells.
- (void) initItemsView{
      NSInteger row = 0;
    BLOCK_OBJC(self,this);
 //   NSArray *cdata = [_datas objectAtIndex:row];
    for ( NSArray *cdata in _datas) {
          NSString *myTitle = [_titleDatas objectAtIndex:row];
        if(row == 0){
            
            _typeCell= [[[NSBundle mainBundle]loadNibNamed:@"TypeViewCell" owner:nil options:nil] firstObject];
            //cell.titleLabel.text = data[@"title"];
            _typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _typeCell.titleLabel.text = myTitle;
            if(_map){
             _typeCell.frame = CGRectMake(0, row*105, ScreenWidth - 40, 105);
            }else{
             _typeCell.frame = CGRectMake(0, row*105, ScreenWidth, 105);
            }
           
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                FilterButton *btn = ( FilterButton *)[_typeCell viewWithTag:10000+i ];
                btn.data = obj;
                btn.selected = NO;
                [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_scrollView addSubview:_typeCell];
        } else if(row == 1){
            
            _bedsCell= [[[NSBundle mainBundle]loadNibNamed:@"BedsViewCell" owner:nil options:nil] firstObject];
            
            if(_map){
               _bedsCell.frame = CGRectMake(0, row*105, ScreenWidth-40, 105);
            }else{
                _bedsCell.frame = CGRectMake(0, row*105, ScreenWidth, 105);
            }
            
            //cell.titleLabel.text = data[@"title"];
            _bedsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _bedsCell.titleLabel.text = myTitle;
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                FilterButton *btn = ( FilterButton *)[_bedsCell viewWithTag:20000+i ];
                btn.data = obj;
                 btn.selected = NO;
                [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_scrollView addSubview:_bedsCell];
        }else if(row == 2){
            
            _priceCell= [[[NSBundle mainBundle]loadNibNamed:@"PriceViewCell" owner:nil options:nil] firstObject];
            _priceCell.priceBack = ^(NSDictionary *data){
                if(data){
                _priceData = data;
                    
                    for (NSInteger i = 30000; i < 30006; i++) {
                  FilterButton *obtn = ( FilterButton *)[this.scrollView viewWithTag:i ];
                            [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                            [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
                
                        obtn.selected = NO;
                        
                    }

                
                }
                
            
            };
            
            if(_map){
                _priceCell.frame = CGRectMake(0, row*105, ScreenWidth - 40, 105);
            }else{
                _priceCell.frame = CGRectMake(0, row*105, ScreenWidth, 105);
            }

            
            _priceCell.titleLabel.text = myTitle;
            _priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            // cell.data = data;
            
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                FilterButton *btn = ( FilterButton *)[_priceCell viewWithTag:30000+i ];
                btn.data = obj;
                 btn.selected = NO;
                [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_scrollView addSubview:_priceCell];
        }else if(row == 3){
            
            _areaCell= [[[NSBundle mainBundle]loadNibNamed:@"AreaViewCell" owner:nil options:nil] firstObject];
            
            _areaCell.areaBack = ^(NSDictionary *data){
                if(data){
                 _areaData = data;
                    
                    for (NSInteger i = 40000; i < 40005; i++) {
                        
                       
                            FilterButton *obtn = ( FilterButton *)[this.scrollView viewWithTag:i ];
                            [obtn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                            [obtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
                      
                        obtn.selected = NO;
                        
                    }

                }
               
                
            };
            
            if(_map){
                 _areaCell.frame = CGRectMake(0, row*105, ScreenWidth-40, 105);
            }else{
                _areaCell.frame = CGRectMake(0, row*105, ScreenWidth, 105);
            }
            
            //cell.titleLabel.text = data[@"title"];
            _areaCell.titleLabel.text = myTitle;
            _areaCell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                FilterButton *btn = ( FilterButton *)[_areaCell viewWithTag:40000+i ];
                btn.data = obj;
                 btn.selected = NO;
                [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_scrollView addSubview:_areaCell];
        }else if(row == 4){
            
            _bathCell= [[[NSBundle mainBundle]loadNibNamed:@"BathViewCell" owner:nil options:nil] firstObject];
            if(_map){
                _bathCell.frame = CGRectMake(0, row*105, ScreenWidth-40, 105);
            }else{
                 _bathCell.frame = CGRectMake(0, row*105, ScreenWidth, 105);
            }
            
            
            //cell.titleLabel.text = data[@"title"];
            _bathCell.titleLabel.text = myTitle;
            _bathCell.selectionStyle = UITableViewCellSelectionStyleNone;
            // cell.data = data;
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                FilterButton *btn = ( FilterButton *)[_bathCell viewWithTag:50000+i ];
                btn.data = obj;
                 btn.selected = NO;
                [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            [_scrollView addSubview:_bathCell];
        }else if(row == 5){
            
            _parkingCell= [[[NSBundle mainBundle]loadNibNamed:@"ParkingViewCell" owner:nil options:nil] firstObject];
            if(_map){
                _parkingCell.frame = CGRectMake(0, row*105, ScreenWidth-40, 105);
            }else{
                _parkingCell.frame = CGRectMake(0, row*105, ScreenWidth, 105);
            }
            
            //cell.titleLabel.text = data[@"title"];
            _parkingCell.titleLabel.text = myTitle;
            _parkingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                FilterButton *btn = ( FilterButton *)[_parkingCell viewWithTag:60000+i ];
                btn.data = obj;
                 btn.selected = NO;
                [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_scrollView addSubview:_parkingCell];
        }else if(row == 6){
            
            _daysCell= [[[NSBundle mainBundle]loadNibNamed:@"DaysViewCell" owner:nil options:nil] firstObject];
            
            if(_map){
                _daysCell.frame = CGRectMake(0, row*105, ScreenWidth - 40, 105);

            }else{
                _daysCell.frame = CGRectMake(0, row*105, ScreenWidth, 105);

            }
            //cell.titleLabel.text = data[@"title"];
            _daysCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _daysCell.titleLabel.text = myTitle;
            for (NSInteger i = 0; i < cdata.count; i++) {
                NSDictionary *obj = [cdata objectAtIndex:i];
                FilterButton *btn = ( FilterButton *)[_daysCell viewWithTag:70000+i ];
                btn.data = obj;
                 btn.selected = NO;
                [btn setBackgroundColor:[UIColor colorWithString:@"#f7f7f7"]];
                [btn setTitle:obj[@"title"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_scrollView addSubview:_daysCell];
        }

        row++;
    }
  
   
    
    
}


@end
