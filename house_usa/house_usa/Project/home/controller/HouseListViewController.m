//
//  HouseListViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HouseListViewController.h"
#import "HomeHouseCell.h"
#import "BMapUtil.h"
#import "MJRefresh.h"
#import "HomeModel.h"

#import "HouseDetailViewController.h"
#import "HouseFilterViewController.h"
#import "SortView.h"
#import "TypeFilterView.h"
#import "PriceFilterView.h"
#import "ListMapViewController.h"
#import "BedsFilterView.h"
#import "CompleteViewController.h"
#import "UPDao+Key.h"
@interface HouseListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSInteger currentPage;
    NSInteger pageSize;
    NSInteger totalPage;
}
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)  NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property(nonatomic,strong) NSString*sortName;
@property(nonatomic,strong) NSString*sortValue;
@property (weak, nonatomic) IBOutlet UITextField *searchTextInput;

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *spaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *bedsBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UIView *sortBtn;
@property(nonatomic,strong)  UIView *filerView;
@property(nonatomic)  NSInteger currentTag;
@property(nonatomic,strong)HouseFilterViewController *filterController;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;

@property(nonatomic,strong)  UIView *sortBgView;
@property(nonatomic,strong)  SortView *sorView;
@property(nonatomic)  CGFloat sortOffset;
@property(nonatomic,strong) UIButton *sureBtn;
@property(nonatomic,strong)UIButton *setBtn;
@property(nonatomic,strong)  UIView *filterBgView;

@property(nonatomic,strong)TypeFilterView *typeFilterView;

@property(nonatomic,strong)BedsFilterView *bedsFilterView;
@property(nonatomic,strong)PriceFilterView *priceFilterView;

@property(nonatomic,strong)PriceFilterView *areaFilterView;


@property (strong, nonatomic) CompleteViewController *comTroller;
@property(nonatomic,strong)  UIView *comView;
@end

@implementation HouseListViewController

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchAction:(id)sender {
    [_searchTextInput resignFirstResponder];
    _key = nil;
      _comView.hidden = YES;
    [self.tableView.header beginRefreshing];
}
- (IBAction)didSeachActino:(id)sender {
    [_searchTextInput resignFirstResponder];
     _key = nil;
      _comView.hidden = YES;
    [self.tableView.header beginRefreshing];
    
}
- (IBAction)gotoMap:(id)sender {
    
    ListMapViewController *controller = [[ListMapViewController alloc] initWithNibName:@"ListMapViewController" bundle:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //[_mapBtn setTitle:self.lang[@"map"] forState:UIControlStateNormal];
      _searchTextInput.placeholder = self.lang[@"homeSearchPlaceHolder"];
    
    
    [_typeBtn setTitle:self.lang[@"Type"] forState:UIControlStateNormal];
    [_priceBtn setTitle:self.lang[@"Price"] forState:UIControlStateNormal];
    [_spaceBtn setTitle:self.lang[@"LivingArea"] forState:UIControlStateNormal];
    [_bedsBtn setTitle:self.lang[@"Beds"] forState:UIControlStateNormal];
    [_moreBtn setTitle:self.lang[@"More"] forState:UIControlStateNormal];
    
     [_setBtn setTitle:self.lang[@"resetLabel"] forState:UIControlStateNormal];
     [_sureBtn setTitle:self.lang[@"searchLabel"] forState:UIControlStateNormal];
    
    _sortLabel.text = self.lang[@"sortLabel"];
    _filterController.priceCell.beweenLabel.text =self.lang[@"beweenLabel"];
     _filterController.areaCell.beweenLabel.text =self.lang[@"beweenLabel"];
    for (NSInteger i = 777771; i < 777777; i++) {
        UIButton *btn = (UIButton *)[_sorView viewWithTag:i];
       
        
        if(i == 777771){
          [btn setTitle:self.lang[@"defaultSort"] forState:UIControlStateNormal];
        }else if(i == 777772){
            [btn setTitle:self.lang[@"daysSort"] forState:UIControlStateNormal];
        }else if(i == 777773){
            [btn setTitle:self.lang[@"pricea"] forState:UIControlStateNormal];
        }else if(i == 777774){
            [btn setTitle:self.lang[@"priceb"] forState:UIControlStateNormal];
        }else if(i == 777775){
            [btn setTitle:self.lang[@"bedssorta"] forState:UIControlStateNormal];
        }else if(i == 777776){
            [btn setTitle:self.lang[@"bedssortb"] forState:UIControlStateNormal];
        }
    }
    
    [_typeFilterView loadLang];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _sortOffset = ScreenHight - 270;
    if(_hideBackBtn){
        _backBtn.hidden = YES;
        
        _sortOffset = ScreenHight - 270 - 47;
    }
    
    if(_searchKey){
    
        self.searchTextInput.text = _searchKey;
        
    }

    self.searchTextInput.delegate = self;
   
    _datas = [NSMutableArray array];
    _inputView.layer.cornerRadius = 3;
    [self setupRefreshHeaderView];
    
    pageSize = 15;
    currentPage = 1;
   
    _sortBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHight)];
    
    _sortBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _sortBgView.hidden = YES;
    UITapGestureRecognizer *backtapGra = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(hideSort)];
    _sortBgView.userInteractionEnabled = YES;
    
    [_sortBgView addGestureRecognizer:backtapGra];
    
    [self.view insertSubview:_sortBgView aboveSubview:_sortBtn];
    
    
    
    
    
    _filterBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, ScreenWidth, ScreenHight-110)];
    
    _filterBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _filterBgView.hidden = YES;
    UITapGestureRecognizer *fbacktapGra = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(hideFilter)];
    _filterBgView.userInteractionEnabled = YES;
    
    [_filterBgView addGestureRecognizer:fbacktapGra];
    
    [self.view insertSubview:_filterBgView aboveSubview:_sortBtn];
    
    
    
    
    
      _sorView  = [[SortView alloc] initWithFrame:CGRectMake(0, ScreenHight, ScreenWidth, 270)];
    _sorView.hidden = YES;
      [self.view insertSubview:_sorView aboveSubview:_sortBgView];
   
    
      [_sortBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    _sortBtn.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *backtapGr = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(goSort)];

    [_sortBtn addGestureRecognizer:backtapGr];

   
    
    CGFloat spacing = 3.0;
    
    ///
    
   
    
    _sortBtn.layer.cornerRadius = 25;

    
    ////
    
    
    
    // 图片右移
    CGSize imageSize = _typeBtn.imageView.frame.size;
    _typeBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
    
    // 文字左移
    CGSize titleSize = _typeBtn.titleLabel.frame.size;
    _typeBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
    
    
    
    CGSize priceBtnimageSize = _priceBtn.imageView.frame.size;
    _priceBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - priceBtnimageSize.width * 2 - spacing, 0.0, 0.0);
    
    // 文字左移
    CGSize priceBtntitleSize = _priceBtn.titleLabel.frame.size;
    _priceBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - priceBtntitleSize.width * 2 - spacing);
    
    
    CGSize spaceBtnimageSize = _spaceBtn.imageView.frame.size;
    _spaceBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - spaceBtnimageSize.width * 2 - spacing, 0.0, 0.0);
    
    // 文字左移
    CGSize spaceBtntitleSize = _spaceBtn.titleLabel.frame.size;
    _spaceBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - spaceBtntitleSize.width * 2 - spacing);
    
    
    
    CGSize bedsBtnimageSize = _bedsBtn.imageView.frame.size;
    _bedsBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - bedsBtnimageSize.width * 2 - spacing, 0.0, 0.0);
    
    // 文字左移
    CGSize _bedsBtntitleSize = _bedsBtn.titleLabel.frame.size;
    _bedsBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - _bedsBtntitleSize.width * 2 - spacing);
    
    
    
    CGSize moreBtnimageSize = _moreBtn.imageView.frame.size;
    _moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - moreBtnimageSize.width * 2 - spacing, 0.0, 0.0);
    
    // 文字左移
    CGSize _moreBtntitleSize = _moreBtn.titleLabel.frame.size;
    _moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - _moreBtntitleSize.width * 2 - spacing);
    
    [self addClickAction];
      BLOCK_OBJC(self,this);
    
    _filterController = [[HouseFilterViewController alloc] initWithNibName:@"HouseFilterViewController" bundle:nil];
    _filterController.scrollView.frame = CGRectMake(0, 0, ScreenWidth, 250);
    _filterController.getBackAction = ^(id sdata){
        this.filerView.hidden = YES;
        NSLog(@"selected data is %@",sdata[@"title"]);
        this.filterBgView.hidden = YES;
        [this.tableView.header beginRefreshing];
    
    };
    CGFloat height = ScreenHight - 110 ;
    if(_hideBackBtn){
       height = ScreenHight - 110 - 48;
    }
    
    _filerView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, ScreenWidth, height)];
    _filerView.backgroundColor = [UIColor redColor];
    _filerView.hidden = YES;
    _filterController.view.frame =CGRectMake(0, 0, ScreenWidth, height - 44);
     [_filerView addSubview: _filterController.view];
    [self.view insertSubview:_filerView aboveSubview:_sortBgView];
    
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, _filerView.frame.size.height - 44, ScreenWidth, 44)];
    bottonView.backgroundColor = [UIColor colorWithString:@"#f7f7f7"];
    [_filerView addSubview:bottonView];
    
    _setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, ScreenWidth/2, 42)];
    
    [_setBtn setTitle:@"Reset" forState:UIControlStateNormal];
    [_setBtn  setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    [_setBtn setBackgroundColor:[UIColor whiteColor]];
    
    
     [_setBtn addTarget:self action:@selector(resetActionBycon) forControlEvents:UIControlEventTouchUpInside];
    
    [bottonView addSubview:_setBtn];
    
   _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2, 2, ScreenWidth/2, 42)];
    
    [_sureBtn setTitle:@"Search" forState:UIControlStateNormal];
    [_sureBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn setBackgroundColor:GlobalTintColor];
    [_sureBtn addTarget:self action:@selector(searchActionBycon) forControlEvents:UIControlEventTouchUpInside];
    [bottonView addSubview:_sureBtn];
    
    
    
    for (NSInteger i = 777771; i < 777777; i++) {
        UIButton *btn = (UIButton *)[_sorView viewWithTag:i];
        
        [btn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    _typeFilterView = [[TypeFilterView alloc] initWithFrame:CGRectMake(0, 110, ScreenWidth, 350) setType:1];
    _typeFilterView.hidden = YES;
    
    _typeFilterView.backAction = ^(NSArray *datas){
        this.filterBgView.hidden = YES;

         [this resetBtns];
         this.sortBgView.hidden = YES;
         [this.tableView.header beginRefreshing];
    };
       [self.view insertSubview:_typeFilterView aboveSubview:_sortBgView];
    
    
    _bedsFilterView = [[BedsFilterView alloc] initWithFrame:CGRectMake(0, 110, ScreenWidth, 350)];
    _bedsFilterView.hidden = YES;
    
    _bedsFilterView.backAction = ^(NSDictionary *datas){
        this.filterBgView.hidden = YES;
        
        [this resetBtns];
        [this.tableView.header beginRefreshing];
    };
    [self.view insertSubview:_bedsFilterView aboveSubview:_sortBgView];
    
    
    
    
    _priceFilterView = [[PriceFilterView alloc] initWithFrame:CGRectMake(0, 110, ScreenWidth, 270) setType:3];
    
    if(_type && [_type isEqualToString:@"lease"] ){
     _priceFilterView.ptype = 2;
    }else{
     _priceFilterView.ptype = 1;
    
    }
   
    
    _priceFilterView.hidden = YES;
    
    _priceFilterView.backAction = ^(NSArray *datas){
        this.filterBgView.hidden = YES;
        
        [this resetBtns];
        [this.tableView.header beginRefreshing];
    };
    [self.view insertSubview:_priceFilterView aboveSubview:_sortBgView];
    
    
    
    
    
    _areaFilterView = [[PriceFilterView alloc] initWithFrame:CGRectMake(0, 110, ScreenWidth, 270) setType:4];
    _areaFilterView.hidden = YES;
    
    
    if(_type && [_type isEqualToString:@"lease"] ){
        _areaFilterView.ptype = 2;
    }else{
        _areaFilterView.ptype = 1;
        
    }
    
    _areaFilterView.backAction = ^(NSArray *datas){
        this.filterBgView.hidden = YES;
        
        [this resetBtns];
        [this.tableView.header beginRefreshing];
    };
    [self.view insertSubview:_areaFilterView aboveSubview:_sortBgView];
    
    
    
    
    _comTroller = [[CompleteViewController alloc] initWithNibName:@"CompleteViewController" bundle:nil];
    
    // __block UIView *cview =  self.comView;
    
    
    _comView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 200)];
    _comView.backgroundColor = [UIColor blueColor];
    _comView.hidden = YES;
    
    [_comView layoutIfNeeded];
    
    [_comView addSubview: _comTroller.view];
    _comTroller.view.frame = CGRectMake(0, 0, ScreenWidth, 200);
    
    [self.view insertSubview:_comView aboveSubview:_sortBgView];
    
    
    __block HouseListViewController * me = self;
    _comTroller.backAction = ^(Key *key){
        me.comView.hidden = YES;
        me.searchTextInput.text = key.cityCode;
        [me.searchTextInput resignFirstResponder];
        [me searchActionBycon];
    };
    


}

-(void)sortBtnClick:(id)sender{
    SortBtn *cubtn = (SortBtn *)sender;
    for (NSInteger i = 777771; i < 777777; i++) {
        UIButton *btn = (UIButton *)[_sorView viewWithTag:i];
        btn.selected = NO;
    }
    cubtn.selected = YES;
    _sortName = cubtn.sortName;
    _sortValue = cubtn.sortValue;
    [self hideSort];
    
    [self.tableView.header beginRefreshing];
}

-(void)searchActionBycon{
    _filerView.hidden = YES;
    _sortBgView.hidden = YES;
    _filterBgView.hidden = YES;
    [self resetBtns];
    [_typeFilterView setTypes:_filterController.typeDatas];
    
    [_priceFilterView setSelectedData:_filterController.priceData];
    
    [_areaFilterView setSelectedData:_filterController.areaData];
    
    [_bedsFilterView setData:_filterController.bedsData];
    
     [self.tableView.header beginRefreshing];

}

-(void)resetActionBycon{
    
    [_filterController setAction];
    
    [self  searchActionBycon];
}

-(void)goSort{

    _sortBgView.hidden = NO;
    _sorView.hidden  = NO;
   
    [UIView animateWithDuration:0.3 animations:^{
        _sorView.frame = CGRectMake(0, _sortOffset, ScreenWidth, 270);
    }];

}
-(void)resetBtns{
    [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_moreBtn setBackgroundColor:[UIColor clearColor]];
    
    [_priceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_priceBtn setBackgroundColor:[UIColor clearColor]];
    
    [_spaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_spaceBtn setBackgroundColor:[UIColor clearColor]];
    
    [_bedsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bedsBtn setBackgroundColor:[UIColor clearColor]];
    
    [_typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_typeBtn setBackgroundColor:[UIColor clearColor]];

}

-(void)hideFilter{
    

    _typeFilterView.hidden = YES;
    _bedsFilterView.hidden = YES;
    _filterBgView.hidden = YES;
    _filerView.hidden = YES;
    _areaFilterView.hidden = YES;
      _priceFilterView.hidden = YES;
    [self resetBtns];
    

}


-(void)hideSort{

    _sortBgView.hidden = YES;
      [UIView animateWithDuration:0.3 animations:^{
        _sorView.frame = CGRectMake(0, ScreenHight, ScreenWidth, 270);
    }];
    _sorView.hidden  = YES;
}

-(void)addClickAction{
    
   
      [_typeBtn addTarget:self action:@selector(filterClickType:) forControlEvents:UIControlEventTouchUpInside];
     [_priceBtn addTarget:self action:@selector(filterClickPrice:) forControlEvents:UIControlEventTouchUpInside];
     [_spaceBtn addTarget:self action:@selector(filterClickSpace:) forControlEvents:UIControlEventTouchUpInside];
     [_bedsBtn addTarget:self action:@selector(filterClickBeds:) forControlEvents:UIControlEventTouchUpInside];
     [_moreBtn addTarget:self action:@selector(filterClickmore:) forControlEvents:UIControlEventTouchUpInside];

}


-(void)filterClickType:(id)sender{
      _comView.hidden = YES;
    
    
    if(_type  && [_type isEqualToString:@"lease"]){
        return;
    }
    
    _typeFilterView.hidden = !_typeFilterView.hidden;
    
    if(_typeFilterView.hidden){
        
       // [_typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       // [_typeBtn setBackgroundColor:[UIColor clearColor]];
        _filterBgView.hidden = YES;
    }else{
       // [_typeBtn setTitleColor:GlobalTintColor forState:UIControlStateNormal];
       // [_typeBtn setBackgroundColor:[UIColor whiteColor]];
        _filterBgView.hidden = NO;
    }
    
    _bedsFilterView.hidden = YES;
    _filerView.hidden = YES;
    _priceFilterView.hidden = YES;
    _areaFilterView.hidden = YES;
    
    
    //[_typeFilterView setTypes:_filterController.typeDatas];
   
    
}

-(void)filterClickPrice:(id)sender{
    
      _comView.hidden = YES;
    
    _priceFilterView.hidden = !_priceFilterView.hidden;
    
    if(_priceFilterView.hidden){
        
      //  [_priceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      //  [_priceBtn setBackgroundColor:[UIColor clearColor]];
        _filterBgView.hidden = YES;
    }else{
       // [_priceBtn setTitleColor:GlobalTintColor forState:UIControlStateNormal];
       // [_priceBtn setBackgroundColor:[UIColor whiteColor]];
        _filterBgView.hidden = NO;
    }
    
    _typeFilterView.hidden  = YES;
    _filerView.hidden = YES;
    _bedsFilterView.hidden = YES;
     _areaFilterView.hidden = YES;
}

-(void)filterClickSpace:(id)sender{
   
      _comView.hidden = YES;
    
    _areaFilterView.hidden = !_areaFilterView.hidden;
    
    if(_areaFilterView.hidden){
        
       // [_spaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       // [_spaceBtn setBackgroundColor:[UIColor clearColor]];
        _filterBgView.hidden = YES;
    }else{
       // [_spaceBtn setTitleColor:GlobalTintColor forState:UIControlStateNormal];
       // [_spaceBtn setBackgroundColor:[UIColor whiteColor]];
        _filterBgView.hidden = NO;
    }
    
    _typeFilterView.hidden  = YES;
    _filerView.hidden = YES;
    _priceFilterView.hidden = YES;
    _bedsFilterView.hidden = YES;
    
    
    
}

-(void)filterClickBeds:(id)sender{
      _comView.hidden = YES;
    _bedsFilterView.hidden = !_bedsFilterView.hidden;
    
    if(_bedsFilterView.hidden){
        
       // [_bedsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       // [_bedsBtn setBackgroundColor:[UIColor clearColor]];
        _filterBgView.hidden = YES;
    }else{
      //  [_bedsBtn setTitleColor:GlobalTintColor forState:UIControlStateNormal];
      //  [_bedsBtn setBackgroundColor:[UIColor whiteColor]];
        _filterBgView.hidden = NO;
    }
    
    _typeFilterView.hidden  = YES;
    _filerView.hidden = YES;
    _priceFilterView.hidden = YES;
     _areaFilterView.hidden = YES;
    
}

-(void)filterClickmore:(id)sender{
    UIButton *btn = sender;
      _comView.hidden = YES;
    
    
   
   
    // [_filterController loadByType:(btn.tag - 888880)];
    
     _filerView.hidden = !_filerView.hidden;
    
    if(_filerView.hidden){
    
       // [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_moreBtn setBackgroundColor:GlobalTintColor];
        _filterBgView.hidden = YES;
    }else{
       // [_moreBtn setTitleColor:GlobalTintColor forState:UIControlStateNormal];
        //[_moreBtn setBackgroundColor:[UIColor whiteColor]];
         _filterBgView.hidden = NO;
    }
 
    _typeFilterView.hidden  = YES;
    _bedsFilterView.hidden = YES;
    _areaFilterView.hidden = YES;
    _priceFilterView.hidden = YES;
    
    
    
    
    
    
     [_filterController setTypes:_typeFilterView.selectedDatas];
    
     [_filterController setPrice:_priceFilterView.selectedData];
    
     [_filterController setBeds:_bedsFilterView.data];
    
     [_filterController setArea:_areaFilterView.selectedData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefreshHeaderView{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currentPage = 1;
        [self loadDataWithIndex];
    }];
    
    self.tableView.footer = [MJRefreshAutoGifFooter  footerWithRefreshingBlock:^{
       [self loadDataWithIndex];
        
    }];

    [self.tableView.header beginRefreshing];
    
}

- (void)loadDataWithIndex{
    
    BLOCK_OBJC(self,this);
    NSDictionary *pa = @{@"page_size":@(pageSize),@"page":@(currentPage)};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:pa];
  
   // [[ stringValue] uppercaseString]
    
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];

    
    if([_typeFilterView.selectedDatas count] >0){
        
        NSMutableArray *typedatas = [NSMutableArray array];
        
        for (NSDictionary *obj  in _typeFilterView.selectedDatas) {
             [typedatas addObject:[obj[@"value"] uppercaseString]];
        }
        
        
        [filters setObject:typedatas forKey:@"prop-type"];
    }

    if(_bedsFilterView.data){
        [filters setObject:_bedsFilterView.data[@"value"] forKey:@"beds"];
    }else{
        [filters setObject:@"2" forKey:@"beds"];
    }
    
    if(_priceFilterView.selectedData){
        [filters setObject:_priceFilterView.selectedData[@"value"] forKey:@"list_price"];
    }
    
    if(_areaFilterView.selectedData){
        [filters setObject:_areaFilterView.selectedData[@"value"] forKey:@"square"];
    }
    

  

    if(_filterController.bathData){
        [filters setObject:_filterController.bathData[@"value"] forKey:@"baths"];
    }
    
    if(_filterController.parkingData){
        [filters setObject:_filterController.parkingData[@"value"] forKey:@"parking"];
    }
    
    
    if(_filterController.daysData){
        [filters setObject:_filterController.daysData[@"value"] forKey:@"market-days"];
    }else{
    
    }
    
    
   
    
    if(_sortName && _sortValue){
    
     //[params setObject:_sortName forKey:@"sort[name]"];
     [params setObject:_sortValue forKey:@"order"];
    }
    
   
    
    if(_key){
    
        [filters setObject:_key forKey:@"city_code"];
    }else{
        if([[self.searchTextInput.text trim] length] >0){
            
            [params setObject:self.searchTextInput.text forKey:@"q"];
            
        }
    
    }
    
    if(_type && [_type isEqualToString:@"lease"]){
        
        [params setObject:_type forKey:@"type"];
        [filters removeObjectForKey:@"prop-type"];
    }
    
       [params setObject:filters forKey:@"filters"];
    
    [[HomeModel sharedInstance] getHouseList:params success:^(NSDictionary *operation) {
        [this.tableView.header endRefreshing];
        [this.tableView.footer endRefreshing];
        
        if([operation[@"code"] integerValue] == 200){
            NSArray *items  = [operation objectForKey:@"data"][@"items"];
            NSDictionary *meta = [operation objectForKey:@"data"];
            totalPage =  [[meta objectForKey:@"total"] integerValue];
            
            if(currentPage == 1){
                [_datas removeAllObjects];
            }
            [_datas addObjectsFromArray:items];
            [_tableView reloadData];
            
            currentPage++;
        
        }
       
    } failure:^(NSError *error) {
        [this.tableView.header endRefreshing];
        [this.tableView.footer endRefreshing];
    }];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     return 125;
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return [_datas count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    static NSString *identifierb=@"HomeHouseCell";
    HomeHouseCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
    if (cell==nil) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"HomeHouseCell" owner:nil options:nil] firstObject];
    }
    
    [cell setData:[_datas objectAtIndex:row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _filerView.hidden = YES;
    NSDictionary *data = [_datas objectAtIndex:indexPath.row];
    
    HouseDetailViewController *controller = [[HouseDetailViewController alloc] initWithNibName:@"HouseDetailViewController" bundle:nil];
    [controller setData:data];
    [controller setType:_type];
    [self.navigationController pushViewController:controller animated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *frustr = [self.searchTextInput.text changeCharactersInRange:range replacementString:string];
    
    if([frustr length] > 0){
        _comView.hidden = NO;
        NSArray *citys =   [[UPDao sharedInstance] getSearchKeys:frustr];
        [_comTroller reloadDatas:citys];
        _comView.hidden = NO;
        
    }else{
        _comView.hidden = YES;
    }
    return true;
}

@end
