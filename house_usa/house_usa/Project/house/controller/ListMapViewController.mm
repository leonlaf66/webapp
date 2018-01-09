//
//  NearbyViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "ListMapViewController.h"

//
//  HomeMapViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HomeMapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "CustomOverlayView.h"
#import "CustomOverlay.h"
#import "MyAnimatedAnnotationView.h"
#import "MyBMKPinAnnotationView.h"
#import "MyBMKPointAnnotation.h"
#import "HomeModel.h"
#import "SelectView.h"
#import "HouseDetailViewController.h"
#import "MapItemView.h"
#import "HouseFilterViewController.h"

#import "FateMapAnnotationView.h"
#import "BMKClusterManager.h" //点聚合管理类，使用百度的点聚合算法
#import "FateModel.h"
#import "UIView+Extension.h"
#import "CompleteViewController.h"
#import "UPDao+Key.h"

@interface ListMapViewController ()<BMKMapViewDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>{
    BMKMapManager* _mapManager;
    BMKLocationService* _locService;
    // BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
    
    BMKCircle* circle;
    BMKPolygon* polygon;
    BMKPolygon* polygon2;
    BMKPolyline* polyline;
    BMKPolyline* colorfulPolyline;
    BMKArcline* arcline;
    BMKGroundOverlay* ground2;
    
    MyBMKPinAnnotationView *_currentAnnotationView ;
    
    NSInteger currentPage;
    NSInteger pageSize;
    NSInteger totalPage;
    
    
    BMKPointAnnotation* pointAnnotation;//表示一个点的annotation
    
    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
    
    NSArray *_allDatas;
    
    FateMapAnnotationView* _firstannotationView;
    
}
@property (strong, nonatomic)IBOutlet  BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *currentImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet SelectView *selectView;
@property (weak, nonatomic) IBOutlet UILabel *curentTypeLabel;


@property (weak, nonatomic) IBOutlet UILabel *houseInforLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *coutLabel;

@property(nonatomic,strong)  HouseFilterViewController *filterController;
@property(nonatomic,strong)  UIView *bgView;
@property(nonatomic,strong)  UIView *filerView;
@property(nonatomic,strong)  UIButton *sureBtn;
@property(nonatomic,strong)  UIButton *setBtn;

@property(nonatomic,strong)  NSDictionary *param;

@property(nonatomic,strong)  NSString *locationString;

@property(nonatomic,strong)  UIView *subwayView;

@property(nonatomic,strong)  UIPickerView *pickView;


@property(nonatomic,strong)  NSMutableArray *subwayDatas;
@property(nonatomic,strong)  NSMutableArray *subwayItemsDatas;


@property(nonatomic,strong)  UIButton *subwaySureBtn;
@property(nonatomic,strong)  UIButton *subwayCancelBtn;

@property(nonatomic,strong)  UIButton *subwayBtn;

@property(nonatomic,strong)  NSMutableDictionary *filters;

@property (weak, nonatomic) IBOutlet UIButton *selectTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextInput;

@property (strong, nonatomic)  NSString *type;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bntWidth;

@property (weak, nonatomic) IBOutlet UIView *pView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectViewheight;

@property (strong, nonatomic) CompleteViewController *comTroller;
@property(nonatomic,strong)  UIView *comView;


@end

@implementation ListMapViewController


- (IBAction)searchAction:(id)sender {
    
    [_searchTextInput resignFirstResponder];
    
    [self goAction];
    _comView.hidden = YES;
    
    
}
-(void)goAction{
    if([[_searchTextInput.text trim] length] > 0){
        NSLog(@"the text = %@",_searchTextInput.text);
        
        [self searchActionBycon];
         _comView.hidden = YES;
    }
    
}

- (IBAction)searchNewAc:(id)sender {
    [_searchTextInput resignFirstResponder];
     _comView.hidden = YES;
  
    [self goAction];
    
}


- (IBAction)selectTypeAction:(id)sender {
    
    if([[self getMyLang] containsString:@"zh"]){
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"类型选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"购房",@"租房", nil ];
        //actionSheet样式
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        //显示
        [sheet showInView:self.view];
        sheet.delegate = self;
        
    }else{
        
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Choose type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Purchase",@"Rental", nil ];
        //actionSheet样式
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        //显示
        [sheet showInView:self.view];
        sheet.delegate = self;
        
    }
    
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"点击确定");
        _type = @"purchase";
        
        if([[self getMyLang] containsString:@"zh"]){
            [_selectTypeBtn setTitle:@"买房" forState:UIControlStateNormal];
        }else{
            [_selectTypeBtn setTitle:@"Purchase" forState:UIControlStateNormal];
        }
        
    }else if (buttonIndex == 1) {
        NSLog(@"点击确定");
        _type = @"lease";
        
        if([[self getMyLang] containsString:@"zh"]){
            [_selectTypeBtn setTitle:@"租房" forState:UIControlStateNormal];
        }else{
            [_selectTypeBtn setTitle:@"Rental" forState:UIControlStateNormal];
        }
        
    }
}


#pragma mark UIPickerViewDataSource 数据源方法
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 2;
    
    
}

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return [_subwayDatas count];
    }else{
        return [_subwayItemsDatas count];
    }
    
    
}

#pragma mark UIPickerViewDelegate 代理方法

// 返回每行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component


{ if(component == 0){
    NSDictionary *obj = [_subwayDatas objectAtIndex:row];
    return obj[@"name"];
}else{
    NSDictionary *obj = [_subwayItemsDatas objectAtIndex:row];
    return obj[@"name"];
    
}
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    // 这里用label来展示要显示的文字, 然后可以用label的textAlignment来设置文字的对齐模式
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth/2  , 35)];
    myView.font = [UIFont systemFontOfSize:14];
    myView.backgroundColor = [UIColor whiteColor];
    myView.textAlignment = NSTextAlignmentCenter;
    
    if(component == 0){
        NSDictionary *obj = [_subwayDatas objectAtIndex:row];
        myView.text =  obj[@"name"];
        myView.textColor = [UIColor blackColor];
        // myView.backgroundColor = [UIColor colorWithString:obj[@"bgcolor"]];
    }else{
        NSDictionary *obj = [_subwayItemsDatas objectAtIndex:row];
        myView.text =  obj[@"name"];
           myView.textColor = [UIColor blackColor];
    }
    
    return myView;
}


// 选中行显示在label上
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{ if (component==0) {
    [_subwayItemsDatas removeAllObjects];
    
    NSDictionary *objs = [_subwayDatas objectAtIndex:row];
    
    [_subwayItemsDatas addObjectsFromArray:objs[@"stations"]];
    
    [_pickView reloadComponent:1];
}else{
    
    
}
    
}

- (void)fangda {
    [_mapView setZoomLevel:_mapView.zoomLevel + 4];
    //_clusterZoom = (NSInteger)self.mapView.zoomLevel;
}
- (void)suoxiao{
    [_mapView setZoomLevel:_mapView.zoomLevel - 3];
   // _clusterZoom = (NSInteger)self.mapView.zoomLevel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectView.hidden = YES;
    
    _filters = [NSMutableDictionary dictionary];


    pageSize = 200;
    currentPage = 1;
    _subwayDatas = [NSMutableArray array];
    _subwayItemsDatas = [NSMutableArray array];
    _type = @"purchase";
     _pView.layer.cornerRadius = 3;
    [_mapView setTrafficEnabled:NO];
    [_mapView setBuildingsEnabled:YES];
    _mapView.delegate = self;
     CGFloat spacing = 3.0;
    if([[self getMyLang] containsString:@"zh"]){
      
        [_selectTypeBtn setTitle:@"买房" forState:UIControlStateNormal];
        _bntWidth.constant = 60;
        // 图片右移
        CGSize imageSize = _selectTypeBtn.imageView.frame.size;
        _selectTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
        
        // 文字左移
        CGSize titleSize = _selectTypeBtn.titleLabel.frame.size;
        _selectTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
        
    }else{
    
        [_selectTypeBtn setTitle:@"Purchase" forState:UIControlStateNormal];
        _bntWidth.constant = 90;
        // 图片右移
        CGSize imageSize = _selectTypeBtn.imageView.frame.size;
        _selectTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
        
        // 文字左移
        CGSize titleSize = _selectTypeBtn.titleLabel.frame.size;
        _selectTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
        
    }
    
    _comTroller = [[CompleteViewController alloc] initWithNibName:@"CompleteViewController" bundle:nil];
    
   // __block UIView *cview =  self.comView;
    
    
     __block ListMapViewController * me = self;
    _comTroller.backAction = ^(Key *key){
        me.comView.hidden = YES;
        me.searchTextInput.text = key.cityCode;
        [me.searchTextInput resignFirstResponder];
        [me searchActionBycon];
    };

    
    [_mapView setBaiduHeatMapEnabled:NO];
    
    
    
    
    // _tableView.tableFooterView = _mapView;
    _mapManager = [[BMKMapManager alloc]init];
    
    
    
   
    
    _selectView.hidden = YES;
    // [BMKLocationService setLocationDistanceFilter:1];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    
    
    
    
    _houseStatusLabel.layer.cornerRadius = 2;
    _houseStatusLabel.layer.borderColor = [UIColor colorWithString:@"#F05E4B"].CGColor;
    _houseStatusLabel.layer.borderWidth = 0.5;
    
    
    _houseDayLabel.layer.cornerRadius = 2;
    _houseDayLabel.layer.borderColor = GlobalTintColor.CGColor;
    _houseDayLabel.layer.borderWidth = 0.5;
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
    [atap addTarget:self action:@selector(tapped)];
    [_selectView addGestureRecognizer:atap];
    
    
    
    self.searchTextInput.delegate = self;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHight -20)];
    
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _bgView.hidden = YES;
    UITapGestureRecognizer *backtapGra = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(hideSort)];
    _bgView.userInteractionEnabled = YES;
    
    [_bgView addGestureRecognizer:backtapGra];
    
    [self.view addSubview:_bgView];
    
    
    
    
    BLOCK_OBJC(self,weakSelf);
    _filterController = [[HouseFilterViewController alloc] initWithNibName:@"HouseFilterViewController" bundle:nil];
    
    
    
    //_filterController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHight- 40);
    _filterController.map = YES;
    _filterController.getBackAction = ^(id sdata){
        weakSelf.filerView.hidden = YES;
        NSLog(@"selected data is %@",sdata[@"title"]);
        weakSelf.bgView.hidden = YES;
        
        
    };
    CGFloat height = ScreenHight;
    
    
    _filerView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth, 20, ScreenWidth-50, height)];
    _filerView.backgroundColor = [UIColor whiteColor];
    _filerView.hidden = YES;
    
    [_filerView layoutIfNeeded];
    
    [_filerView addSubview: _filterController.view];
    _filterController.width.constant = ScreenWidth-40;
    [self.view addSubview:_filerView];
    
   
    
    
    
    
    
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHight - 64, ScreenWidth-40, 44)];
    bottonView.backgroundColor = [UIColor colorWithString:@"#f7f7f7"];
    [_filerView addSubview:bottonView];
    
    _setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, (ScreenWidth-40)/2, 42)];
    
    [_setBtn setTitle:@"Reset" forState:UIControlStateNormal];
    [_setBtn  setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    [_setBtn setBackgroundColor:[UIColor whiteColor]];
    
    
    [_setBtn addTarget:self action:@selector(resetActionBycon) forControlEvents:UIControlEventTouchUpInside];
    
    [bottonView addSubview:_setBtn];
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-40)/2, 2,  (ScreenWidth-40)/2, 42)];
    
    [_sureBtn setTitle:@"Search" forState:UIControlStateNormal];
    [_sureBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn setBackgroundColor:GlobalTintColor];
    [_sureBtn addTarget:self action:@selector(searchActionBycon) forControlEvents:UIControlEventTouchUpInside];
    [bottonView addSubview:_sureBtn];
    
    
    UIView *mapBtn = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 45, ScreenHight/2, 44, 88)];
    mapBtn.backgroundColor = [UIColor whiteColor];
    mapBtn.layer.cornerRadius = 2.5;
    
    [self.view insertSubview:mapBtn belowSubview:_bgView];
    
    UIButton *fangdabutn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    
    [fangdabutn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [fangdabutn  setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    
    
    
    [fangdabutn addTarget:self action:@selector(fangda) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //[self.view insertSubview:fangdabutn aboveSubview:_mapView];
    [mapBtn addSubview:fangdabutn];
    
    
    UIButton *suoxiao = [[UIButton alloc] initWithFrame:CGRectMake(0, 45, 44, 44)];
    
    [suoxiao setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    //[suoxiao setTitle:@"缩小" forState:UIControlStateNormal];
    [suoxiao  setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    
    
    
    [suoxiao addTarget:self action:@selector(suoxiao) forControlEvents:UIControlEventTouchUpInside];
    
    
    [mapBtn addSubview:suoxiao];
    
    
    
    
    _subwayBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 90 ,ScreenHight - 200,80, 30)];
    
    [_subwayBtn setImage:[UIImage imageNamed:@"subway"] forState:UIControlStateNormal];
    //[suoxiao setTitle:@"缩小" forState:UIControlStateNormal];
    [_subwayBtn  setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    _subwayBtn.backgroundColor = [UIColor whiteColor];
    _subwayBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _subwayBtn.layer.cornerRadius = 1.5;
    [_subwayBtn  setTitle:@"地图搜房" forState:UIControlStateNormal];
    
    [_subwayBtn addTarget:self action:@selector(showSubway) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view insertSubview:_subwayBtn belowSubview:_bgView];
    
    _subwayView = [[UIView alloc]initWithFrame: CGRectMake(0, ScreenHight, ScreenWidth, 200)];
    _subwayView.backgroundColor = [UIColor whiteColor];
    
    _pickView =  [[UIPickerView alloc]initWithFrame: CGRectMake(0,44, ScreenWidth, 156)];
    
    _pickView.showsSelectionIndicator = YES;
    //在iOS 7之后可以自定义选择器视图的背景颜色改变其backgroundColor
    
    // _pickView.backgroundColor = [UIColor grayColor];
    _pickView.delegate = self;
    //设置pickVIew的透明度
    
    _pickView.alpha = 0.7;
    
    
    
    [_subwayView addSubview:_pickView];
    [self.view insertSubview:_subwayView belowSubview:_bgView];
    
    
    _subwaySureBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 5, 44, 30)];
    _subwayCancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 5, 44, 30)];
    
    
    _subwaySureBtn.backgroundColor = [UIColor whiteColor];
    _subwaySureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    _subwayCancelBtn.backgroundColor = [UIColor whiteColor];
    _subwayCancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_subwayCancelBtn  setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    
    [_subwaySureBtn  setTitleColor:GlobalTintColor forState:UIControlStateNormal];
    
    
    
    [_subwayCancelBtn addTarget:self action:@selector(hideSubway) forControlEvents:UIControlEventTouchUpInside];
    
    [_subwaySureBtn addTarget:self action:@selector(subwaySearch) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_subwayView addSubview:_subwaySureBtn];
    [_subwayView addSubview:_subwayCancelBtn];
    [self getSubWay];
    
    
    
    _comView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 200)];
    _comView.backgroundColor = [UIColor blueColor];
    _comView.hidden = YES;
    
    [_comView layoutIfNeeded];
    
    [_comView addSubview: _comTroller.view];
    _comTroller.view.frame = CGRectMake(0, 0, ScreenWidth, 200);
    
    [self.view insertSubview:_comView aboveSubview:_bgView];

     [_filterController setTypes:@[@{@"value":@"sf"},@{@"value":@"mf"},@{@"value":@"cc"}]];
    
    if(_fromHome){
        
          [self customLocationAccuracyCircle];
        
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
        
    
        [_locService startUserLocationService];
    
    }else{
        CLLocationCoordinate2D coor;
        coor.latitude = 42.38184;
        coor.longitude = -71.07108;
        
        [self.mapView setCenterCoordinate:coor animated:YES];
        
         NSString *area_id = [HomeModel sharedInstance].area;
        
        if([[area_id uppercaseString] isEqualToString:@"MA"]){
            
            
            if([[self getMyLang] containsString:@"zh"]){
                
                _searchTextInput.text = @"波士顿";
            }else{
              
                 _searchTextInput.text = @"Boston";
            }
            
            
            
        }else  if([[area_id uppercaseString] isEqualToString:@"GA"]){
            if([[self getMyLang] containsString:@"zh"]){
                
                _searchTextInput.text = @"亚特兰大";
            }else{
                
                _searchTextInput.text = @"Atlanta";
            }
            
            
        }else  if([[area_id uppercaseString] isEqualToString:@"IL"]){
            
            if([[self getMyLang] containsString:@"zh"]){
                
                _searchTextInput.text = @"芝加哥";
            }else{
                
                _searchTextInput.text = @"Chicago";
            }
            
        }else  if([[area_id uppercaseString] isEqualToString:@"CA"]){
            
            if([[self getMyLang] containsString:@"zh"]){
                
                _searchTextInput.text = @"洛杉矶";
            }else{
                
                _searchTextInput.text = @"Los Angeles";
            }
            
        }else  if([[area_id uppercaseString] isEqualToString:@"NY"]){
            if([[self getMyLang] containsString:@"zh"]){
                
                _searchTextInput.text = @"格雷特内克";
            }else{
                
                _searchTextInput.text = @"Great Neck";
            }
        }
        

       [self searchActionBycon];
    }
    
 
    
    
}

- (void)customLocationAccuracyCircle {
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.accuracyCircleStrokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0];
    param.accuracyCircleFillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0];
    [_mapView updateLocationViewWithParam:param];
    [_mapView setZoomLevel:15];
    _clusterZoom = 15;
    
    
    
   
    
}

-(void)showSubway{
    _subwayView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _subwayView.frame = CGRectMake(0, ScreenHight - 200, ScreenWidth, 200);
    }];
    
}

-(void)subwaySearch{
    [UIView animateWithDuration:0.5 animations:^{
        _subwayView.frame = CGRectMake(0, ScreenHight, ScreenWidth, 200);
    }];
    
    _subwayView.hidden = YES;
    
    NSInteger row =[_pickView selectedRowInComponent:1];
    
    NSDictionary *selectSubway = [_subwayItemsDatas objectAtIndex:row];
    
    NSArray *stations = @[selectSubway[@"id"]];
    //subway_stations
    
      NSInteger rowa =[_pickView selectedRowInComponent:0];
    
    NSDictionary *tselectSubway = [_subwayDatas objectAtIndex:rowa];
    
    
    [_filters setObject:tselectSubway[@"id"] forKey:@"subway_line"];
    [_filters setObject:stations forKey:@"subway_stations"];
   // _searchTextInput.text = @"";
    //[self searchActionBycon];
    
    _filerView.hidden = YES;
    
    _bgView.hidden = YES;
    // [self resetBtns];
    
    
    
    
    if(self.currentData != nil){
        
        [_filters setObject:[NSString stringWithFormat:@"%@,%@",_currentData[@"latitude"],_currentData[@"longitude"]] forKey:@"latlon"];
        
    }else{
        //[filters setObject:@"42.674821,-70.99442" forKey:@"latlon"];
    }
    
    //  //coor.latitude = 42.674821;
    //coor.longitude = -70.99442;
    //NSDictionary *pa = @{@"pagination[size]":@(pageSize),@"pagination[page]":@(currentPage)};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_param];
    
    if([_filterController.typeDatas count]>0  && ![@"lease" isEqualToString:_type]){
        
        NSMutableArray *typedatas = [NSMutableArray array];
        for (NSDictionary *obj  in _filterController.typeDatas) {
            [typedatas addObject:[obj[@"value"] uppercaseString]];
            
        }
        
        
        
        [_filters setObject:typedatas forKey:@"prop-type"];
    }
    
    
    
    
    if(_filterController.bathData){
        [_filters setObject:_filterController.bathData[@"value"] forKey:@"baths"];
    }
    
    if(_filterController.parkingData){
        [_filters setObject:_filterController.parkingData[@"value"] forKey:@"parking"];
    }
    
    
    if(_filterController.daysData){
        [_filters setObject:_filterController.daysData[@"value"] forKey:@"market-days"];
    }else{
        
        //[filters setObject:@"1" forKey:@"market-days"];
    }
    
    if(_filterController.bedsData){
        [_filters setObject:_filterController.bedsData[@"value"] forKey:@"beds"];
    }else{
        //  [_filters setObject:@"2" forKey:@"beds"];
    }
    
    if(_filterController.priceData)
        [_filters setObject:_filterController.priceData[@"value"] forKey:@"list_price"];
    
    
    
    
    
    [params setObject:_filters forKey:@"filters"];
    
    [params setObject:_type forKey:@"type"];
    
    _searchTextInput.text = @"";
    
   [_filters removeObjectForKey:@"latlon"];
  
    [self loadData:params];

}

-(void)hideSubway{
    _filters = [NSMutableDictionary dictionary];
    [UIView animateWithDuration:0.5 animations:^{
        _subwayView.frame = CGRectMake(0, ScreenHight, ScreenWidth, 200);
    }];
    
    _subwayView.hidden = YES;
}

-(void)getSubWay{
    //[self showLoading:@""];
    [[HomeModel sharedInstance] getSubwayList:@{} success:^(id operation) {
        [self hideLoading];
        if([operation[@"code"] integerValue] == 200 ){
            
            
            NSDictionary *cdata =      operation[@"data"];
            
            NSArray *vs = [cdata allValues];
            NSInteger i = 0;
            
            for (NSDictionary *obj  in vs) {
                
                NSMutableDictionary *newobj = [[NSMutableDictionary alloc] init];
                
                [newobj setObject:obj[@"id"] forKey:@"id"];
                [newobj setObject:obj[@"name"] forKey:@"name"];
                [newobj setObject:obj[@"font_color"] forKey:@"font_color"];
                [newobj setObject:obj[@"bgcolor"] forKey:@"bgcolor"];
                [newobj setObject: obj[@"stations"] forKey:@"stations"];
                
                
                [_subwayDatas addObject:newobj];
                
                if(i == 0){
                    [_subwayItemsDatas addObjectsFromArray:newobj[@"stations"]];
                    
                }
                i++;
            }
            
            [_pickView reloadAllComponents];
            [_pickView selectRow:4 inComponent:0 animated:YES];
            
        }
        
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
    
}

-(void)setArea_houses:(NSArray *)area_houses{
    _area_houses = area_houses;
    
}

- (IBAction)goFilter:(id)sender {
    _filerView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _filerView.frame  =  CGRectMake(50, 20, ScreenWidth-50, ScreenHight-20);
    }];
    
    _bgView.hidden = NO;
    
    
    
    
    
    
}
-(void)hideSort{
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _filerView.frame  =  CGRectMake(ScreenWidth, 20, ScreenWidth-50, ScreenHight-20);
        // _filerView.hidden = YES;
    }];
    
    _bgView.hidden = YES;
    
    
}

-(void)searchActionnewlat{
    _filerView.hidden = YES;
    
       _bgView.hidden = YES;

       _mapView.showsUserLocation = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_param];
    
    
    
    [params setObject:_type forKey:@"type"];
    
    if([[_searchTextInput.text trim] length] > 0){
        [params setObject:_searchTextInput.text forKey:@"q"];
        
        _mapView.showsUserLocation = NO;
        
        [_filters removeObjectForKey:@"latlon"];
        
    }else{
        
     
    
        
    }

    
    
   
    
    [params setObject:_filters forKey:@"filters"];
    
    [self loadData:params];

}


-(void)searchActionBycon{
    _filerView.hidden = YES;
    
    _bgView.hidden = YES;
    // [self resetBtns];
   
    
   
    
    if(self.currentData != nil){
        
        [_filters setObject:[NSString stringWithFormat:@"%@,%@",_currentData[@"latitude"],_currentData[@"longitude"]] forKey:@"latlon"];
        
    }else{
        //[filters setObject:@"42.674821,-70.99442" forKey:@"latlon"];
    }
    
    //  //coor.latitude = 42.674821;
    //coor.longitude = -70.99442;
    //NSDictionary *pa = @{@"pagination[size]":@(pageSize),@"pagination[page]":@(currentPage)};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_param];
    
    if([_filterController.typeDatas count]>0 && ![@"lease" isEqualToString:_type]){
        
        NSMutableArray *typedatas = [NSMutableArray array];
        for (NSDictionary *obj  in _filterController.typeDatas) {
            [typedatas addObject:[obj[@"value"] uppercaseString]];
            
        }
        
        
        
        [_filters setObject:typedatas forKey:@"prop-type"];
    }
    
    
   
    
    if(_filterController.bathData){
        [_filters setObject:_filterController.bathData[@"value"] forKey:@"baths"];
    }
    
    if(_filterController.parkingData){
        [_filters setObject:_filterController.parkingData[@"value"] forKey:@"parking"];
    }
    
    
    if(_filterController.daysData){
        [_filters setObject:_filterController.daysData[@"value"] forKey:@"market-days"];
    }else{
        
        //[filters setObject:@"1" forKey:@"market-days"];
    }
    
    if(_filterController.bedsData){
        [_filters setObject:_filterController.bedsData[@"value"] forKey:@"beds"];
    }else{
      //  [_filters setObject:@"2" forKey:@"beds"];
    }
    
    if(_filterController.priceData)
        [_filters setObject:_filterController.priceData[@"value"] forKey:@"list_price"];
    
    
    
    
       _mapView.showsUserLocation = NO;
   
    // [_filters removeObjectForKey:@"latlon"];
    
     [params setObject:_type forKey:@"type"];
    
    if([[_searchTextInput.text trim] length] > 0){
        [params setObject:_searchTextInput.text forKey:@"q"];
        
        _mapView.showsUserLocation = NO;
        
        [_filters removeObjectForKey:@"latlon"];
        
    }else{
        
        
        
        
    }
    
     //[params setObject:@"200" forKey:@"limit"];
    
    [_filters removeObjectForKey:@"subway_line"];
     [_filters removeObjectForKey:@"subway_stations"];
    
   [params setObject:_filters forKey:@"filters"];
    
    [self loadData:params];
    
}



-(void)resetActionBycon{
    _filters = [[NSMutableDictionary alloc] init];
    
    [_filterController setAction];
    
    if(_fromHome){
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
    
_searchTextInput.text = @"";
          [_locService startUserLocationService];
    
    }else{
      [self searchActionBycon];
    }
    
    
    
  
}

-(void)tapped{
    
    if(_selectView.data){
        NSDictionary *data = _selectView.data;
        
        HouseDetailViewController *controller = [[HouseDetailViewController alloc] initWithNibName:@"HouseDetailViewController" bundle:nil];
        [controller setData:data];
        [controller setType:@"purchase"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

-(void)loadData:(NSDictionary *)param{
    
    [self showLoading:@""];
    
    [_mapView removeAnnotations: _mapView.annotations];
    
    [_mapView removeOverlays:_mapView.overlays];
    _clusterCaches = [NSMutableArray array];
    _allDatas = [NSMutableArray array];
    
    [[HomeModel sharedInstance] getNearByData:param success:^(NSDictionary *operation) {
        NSLog(@"%@",operation);
        
        [self hideLoading];
        
        if([operation[@"code"] integerValue] == 200){
            NSDictionary *ds = operation[@"data"];
            
            if([[self getMyLang] containsString:@"zh"]){
                
                self.coutLabel.text =   [NSString stringWithFormat:@"共%ld套房源",[ds[@"items"] count]];
            }else{
                self.coutLabel.text =   [NSString stringWithFormat:@"There are %ld houses ",[ds[@"items"] count]];
                
            }
            
            
            if ([[ds objectForKey:@"items"] count] > 0) {
               
                NSMutableArray *allDatas = [NSMutableArray array];
                
                NSInteger i = 0;
                
                for (NSString *obj in ds[@"items"]) {
                    
                    
                    NSArray *os = [obj componentsSeparatedByString:@"|"];
                    
                    NSString *price = os[1];
                    NSString *newprice = @"";
                    
                    if([[self getMyLang] containsString:@"zh"]){
                        
                        if([_type isEqualToString:@"lease"]){
                            
                            NSNumber *number =[[NSNumber alloc] initWithDouble:[price doubleValue]*10000];
                            
                          
                          newprice =  [NSString stringWithFormat:@"%ld美元", (long)[number integerValue]];
                        }else{
                          newprice =  [NSString stringWithFormat:@"%@万美元",price ];
                        }
                        
                      
                        
                    }else{
                        //
                        
                        newprice  =  [NSString stringWithFormat:@"$%ld", [@([price doubleValue] *10000 ) integerValue]];
                    }
                    
                    FateModel *model = [FateModel new];
                    model.lon = [os[4] doubleValue];
                    model.lat = [os[3] doubleValue];
                    model.price = newprice;
                    model.hid = os[0];
                    //model.type = @"独栋别墅";
                    
                    if([[self getMyLang] containsString:@"zh"]){
                        
                        if( [os[2] isEqualToString:@"SF"]){
                            model.type = @"独栋别墅";
                            
                        }else if( [os[2] isEqualToString:@"MF"]){
                            model.type = @"多家庭";
                            
                        }else if( [os[2] isEqualToString:@"CC"]){
                            model.type = @"公寓";
                            
                        }else if( [os[2] isEqualToString:@"CI"]){
                            model.type = @"商业用房";
                            
                        }else if( [os[2] isEqualToString:@"BU"]){
                            model.type = @"营业用房";
                            
                        }else if( [os[2] isEqualToString:@"LD"]){
                            model.type = @"土地";
                            
                        }else if( [os[2] isEqualToString:@"RN"]){
                            model.type = @"租房";
                            
                        }
                        
                        
                    }else{
                        
                        if( [os[2] isEqualToString:@"SF"]){
                            model.type = @"Single Family";
                            
                        }else if( [os[2] isEqualToString:@"MF"]){
                            model.type = @"Multi Family";
                            
                        }else if( [os[2] isEqualToString:@"CC"]){
                            model.type = @"Condominium";
                            
                        }else if( [os[2] isEqualToString:@"CI"]){
                            model.type = @"Commercial";
                            
                        }else if( [os[2] isEqualToString:@"BU"]){
                            model.type = @"Business Opportunity";
                            
                        }else if( [os[2] isEqualToString:@"LD"]){
                            model.type = @"Land";
                            
                        }else if( [os[2] isEqualToString:@"RN"]){
                            model.type = @"Rental";
                            
                        }
                        
                    }
                    if(i == 0){
                        
                        CLLocationCoordinate2D coords;
                        coords.latitude = model.lat;
                        coords.longitude = model.lon;
                         [self.mapView setCenterCoordinate:coords animated:YES];

                        
                    }
                    i++;
                    [allDatas addObject:model];
                    
                    //  [allDatas addObject:@{@"id":os[0],@"type":os[2],@"price":newprice,
                    //            @"longitude":os[4],
                    //     @"latitude":os[3]}];
                }
                // [self addAnimatedAnnotation:allDatas];
                
                _allDatas = allDatas;
                [self addPointJuheWithCoorArray:_allDatas];
                
                [self addLine:[ds objectForKey:@"polygons"]];
              //  [self addLine:[ds objectForKey:@"polygons"]];
            }else{
                
                
            }
        }
        
        
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     _searchTextInput.placeholder = self.lang[@"homeSearchPlaceHolder"];
    
    if([[self getMyLang] containsString:@"zh"]){
       

        [_subwaySureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_subwayCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
         [_subwayBtn  setTitle:@"地铁搜房" forState:UIControlStateNormal];
       
    }else{
        [_subwaySureBtn setTitle:@"OK" forState:UIControlStateNormal];
        [_subwayCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        
      [_subwayBtn  setTitle:@"Subway" forState:UIControlStateNormal];
        
        
    }
}




- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initlines{
    
    NSArray * points  = _currentData[@"polygons"];
    
    
    //polygons
    const NSInteger count = [points count];
    int i = 0;
    
    BMKMapPoint *temppoints = new BMKMapPoint[count];
    
    CLLocationCoordinate2D coords[count] ;
    
    for (NSString *obj in points) {
        
        NSArray *my = [obj componentsSeparatedByString:@","];
        double  lant= [[my objectAtIndex:0] doubleValue];
        double  longt= [[my objectAtIndex:1] doubleValue];
        
        CLLocationCoordinate2D coor1;
        coords[i].latitude = longt;
        coords[i].longitude = lant;
        BMKMapPoint pt1 = BMKMapPointForCoordinate(coor1);
        
        temppoints[i].x = pt1.x;
        temppoints[i].y = pt1.y;
        i++;
        //////
        
    }
    
    
    BMKPolygon * polygona = [BMKPolygon polygonWithCoordinates:coords count:count];
    
    [_mapView addOverlay:polygona];
    
    
    
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[CustomOverlay class]])
    {
        CustomOverlayView* cutomView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        cutomView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        cutomView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0];
        cutomView.lineWidth = 1.0;
        return cutomView;
        
        
    }else   if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        // polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth = 1.0;
        
        return polygonView;
    }
    
    return nil;
    
}






-(void)loadDetailData:(NSDictionary *)data{
    [self showLoading:@""];
    
    NSDictionary *param = @{@"id":data[@"id"]};
   
  
    
    [[HomeModel sharedInstance] getHouseDetail:param success:^(NSDictionary *operation) {
        
        if([operation[@"code"] integerValue] == 200){
            NSDictionary *obj = operation[@"data"];
            
            
            [_currentImageView sd_setImageWithURL:[NSURL URLWithString: [obj[@"images"] objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"home_business_default"]];
            
            _currentLocationLabel.text = obj[@"location"];
            //  "prop_type" = SF;
            _curentTypeLabel.text = obj[@"prop_type_name"];
            if([[self getLang] containsString:@"zh"]){
                _priceLabel.text =  [NSString stringWithFormat:@"售价：%@",obj[@"list_price"]];
            }else{
                _priceLabel.text =  [NSString stringWithFormat:@"Price:%@",obj[@"list_price"]];
            }
            if([[self getMyLang] containsString:@"zh"]){
                
                
                
                
                _houseInforLabel.text =  [NSString stringWithFormat:@"卧室 %@| 全卫 %@ 半卫 %@ | 居住面积 %@",obj[@"no_bedrooms"],obj[@"no_full_baths"],obj[@"no_half_baths"],obj[@"square_feet"]];
                
            }else{
                
                
                _houseInforLabel.text =  [NSString stringWithFormat:@"%@beds %@.%@baths %@",obj[@"no_bedrooms"],obj[@"no_full_baths"],obj[@"no_half_baths"],obj[@"square_feet"]];
                
                
            }
            
            
            _houseDayLabel.text = obj[@"list_days_description"];
            _houseStatusLabel.text = obj[@"status_name"];
            _selectView.data = obj;
            
        }
        
        
        [self hideLoading];
    } failure:^(NSError *error) {
        // [_indicator stopAnimating];
        [self hideLoading];
    }];
    
}


-(void)addLine:(NSArray *)points{
    
    for(NSArray *newpoints in points){
        //polygons
        NSInteger count = [newpoints count];
        int i = 0;
        
        BMKMapPoint *temppoints = new BMKMapPoint[count];
        CLLocationCoordinate2D coords[count] ;
        for (NSArray *my in newpoints) {
            
            
            double  longt= [[my objectAtIndex:0] doubleValue];
            double  lant= [[my objectAtIndex:1] doubleValue];
            
            CLLocationCoordinate2D coor1;
            coords[i].latitude = lant;
            coords[i].longitude = longt;
            BMKMapPoint pt1 = BMKMapPointForCoordinate(coor1);
            
            temppoints[i].x = pt1.x;
            temppoints[i].y = pt1.y;
            i++;
            
            
        }
        
        
        
        BMKPolygon * polygona = [BMKPolygon polygonWithCoordinates:coords count:count];
        
        [_mapView addOverlay:polygona];
    }
    
  
    
  
    
    
}





//添加模型数组
- (void)addPointJuheWithCoorArray:(NSArray *)array {
      _clusterZoom = (NSInteger)self.mapView.zoomLevel+2;
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < array.count; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    //点聚合管理类
    _clusterManager = [[BMKClusterManager alloc] init];
    
    NSInteger center = [array count] / 2;

    
    [array enumerateObjectsUsingBlock:^(FateModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // coor.latitude = [obj[@"latitude"] doubleValue];
        // coor.longitude = [obj[@"longitude"] doubleValue];
        
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        clusterItem.coor = CLLocationCoordinate2DMake(obj.lat, obj.lon);
        clusterItem.model = obj;
        
        [_clusterManager addClusterItem:clusterItem];
        
        
        
        CLLocationCoordinate2D coor;
        coor.latitude = obj.lat;
        coor.longitude =obj.lon;
        if(idx == center){
            //[self.mapView setCenterCoordinate:coor animated:YES];
        }
        
        
    }];
    [self updateClusters];
}

//更新聚合状态
- (void)updateClusters {
    
    if(_clusterCaches.count == 0) {
        return;
    }
    _clusterZoom = (NSInteger)self.mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        
        NSInteger  incount = _clusterCaches.count / 2;
        
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:incount];
        if (clusters.count > 0) {
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //聚合后的数组
                    for (BMKCluster *item in array) {
                        FateMapAnnotation *annotation = [[FateMapAnnotation alloc] init];
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.cluster = item;
                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
                        [clusters addObject:annotation];
                    }
                    [self.mapView removeAnnotations:self.mapView.annotations];
                    [self.mapView addAnnotations:clusters];
                    
                    BMKCluster *item  = [array lastObject];
                    
                    CLLocationCoordinate2D coor;
                    coor.latitude = item.model.lat;
                    coor.longitude = item.model.lon;
                    
                    //[self.mapView setCenterCoordinate:coor animated:YES];
                });
            });
        }
    }
}


#pragma mark - BMKMapViewDelegate

//地图改变的时候发送请求
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
   
  
    
    NSNumber *level = [NSNumber numberWithFloat:self.mapView.zoomLevel];

    if(_clusterZoom != level.integerValue && _allDatas != nil && _allDatas.count > 0){
        

        
        [self addPointJuheWithCoorArray:_allDatas];
        
    }else{
        
        
    }
    
    _clusterZoom = (NSInteger)self.mapView.zoomLevel;
  
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存  MapItemView *v =  [[MapItemView alloc] initWithFrame:CGRectMake(0, 0, 120, 15)];
    
    FateMapAnnotationView* annotationView = (FateMapAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[FateMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.paopaoView = nil;
        
    }
    FateMapAnnotation *cluster = (FateMapAnnotation*)annotation;
    annotationView.size = cluster.size;
    annotationView.cluster = cluster.cluster;
    annotationView.model = cluster.cluster.model;
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = NO;
    
    return annotationView;
    
    
}




- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    FateMapAnnotationView* annotationView =( FateMapAnnotationView*) view;
    NSLog(@"the size is %@",[NSString stringWithFormat:@"%ld",annotationView.size]);
    if(annotationView.size == 1){
        [self loadDetailData:@{@"id":annotationView.model.hid}];
        
        _selectView.hidden = NO;
        
        
        if(_firstannotationView != nil){
            
            _firstannotationView.selected = NO;
        }
        _firstannotationView = annotationView;
        
    }else{
        // [mapView setCenterCoordinate:view.annotation.coordinate];
        // [mapView zoomIn];
        self.mapView.zoomLevel = self.mapView.zoomLevel + 3;
        _clusterZoom = (NSInteger)self.mapView.zoomLevel;
        CLLocationCoordinate2D coor;
        coor.latitude = annotationView.model.lat;
        coor.longitude = annotationView.model.lon;
        
        // [self.mapView setCenterCoordinate:coor animated:YES];
        
    }
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
-(void)setFromHome:(BOOL)fromHome{
    _fromHome = fromHome;
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    [_locService stopUserLocationService];
    
    
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    
   // [self.mapView setCenterCoordinate:coor animated:YES];

    [self.mapView updateLocationData:userLocation];
  
    
     [_filters setObject:[NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude] forKey:@"latlon"];
      [self searchActionnewlat];
    
   
    
}

@end

