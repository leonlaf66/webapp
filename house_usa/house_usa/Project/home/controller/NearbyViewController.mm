//
//  NearbyViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "NearbyViewController.h"

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

@interface NearbyViewController ()<BMKMapViewDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate>{
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

@end

@implementation NearbyViewController

- (void)fangda {
     [_mapView setZoomLevel:_mapView.zoomLevel + 4];
   
}
- (void)suoxiao{
     [_mapView setZoomLevel:_mapView.zoomLevel - 4];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageSize = 200;
    currentPage = 1;
    
    [_mapView setTrafficEnabled:NO];
    [_mapView setBuildingsEnabled:YES];
    _mapView.delegate = self;
    
    [_mapView setBaiduHeatMapEnabled:NO];
    
    
    
    
    // _tableView.tableFooterView = _mapView;
    _mapManager = [[BMKMapManager alloc]init];
    
    [self customLocationAccuracyCircle];
    
    _selectView.hidden = YES;
    // [BMKLocationService setLocationDistanceFilter:1];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _mapView.userInteractionEnabled = YES;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
   
    
    
   
    
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
    
    [_filterController setTypes:@[@{@"value":@"sf"},@{@"value":@"mf"},@{@"value":@"cc"}]];
    
    [self searchActionBycon];
    

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


-(void)searchActionBycon{
    _filerView.hidden = YES;
  
    _bgView.hidden = YES;
   // [self resetBtns];
  
    
      NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if(self.currentData != nil){
      
        
     [filters setObject:[NSString stringWithFormat:@"%@,%@",_currentData[@"latitude"],_currentData[@"longitude"]] forKey:@"latlon"];
    
    }else{
        // [filters setObject:@"42.674821,-70.99442" forKey:@"latlon"];
    }
   
   
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_param];
    
    if([_filterController.typeDatas count]>0 ){
        
        NSMutableArray *typedatas = [NSMutableArray array];
        for (NSDictionary *obj  in _filterController.typeDatas) {
            [typedatas addObject:[obj[@"value"] uppercaseString]];
            
        }
        
        
        
        [filters setObject:typedatas forKey:@"prop-type"];
    }
    
    
    if(_filterController.bedsData){
        [filters setObject:_filterController.bedsData[@"value"] forKey:@"beds"];
    }else{
        [filters setObject:@"2" forKey:@"beds"];
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
        
        //[filters setObject:@"1" forKey:@"market-days"];
    }
    
    

        if(_filterController.priceData)
            [filters setObject:_filterController.priceData[@"value"] forKey:@"list_price"];
        
    
    

    
    [params setObject:filters forKey:@"filters"];
      //[params setObject:@"200" forKey:@"limit"];
    
    [self loadData:params];
    
}



-(void)resetActionBycon{
    
    [_filterController setAction];
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
 
    [_mapView removeAnnotations:_mapView.annotations];
    
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
               // _selectView.hidden = NO;
                NSMutableArray *allDatas = [NSMutableArray array];
                
                NSInteger i = 0;
        
                for (NSString *obj in ds[@"items"]) {
                  
                    
                    NSArray *os = [obj componentsSeparatedByString:@"|"];
                    
                    NSString *price = os[1];
                     NSString *newprice = @"";
                    
                    if([[self getMyLang] containsString:@"zh"]){
                    
                       newprice =  [NSString stringWithFormat:@"%@万美元",price ];
                    
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
                            
                        }

                    }
                    if(i == 0){
                       // [self loadDetailData:@{@"id":model.hid}];
                    
                    }
                    i++;
                                       [allDatas addObject:model];
                    
                  //  [allDatas addObject:@{@"id":os[0],@"type":os[2],@"price":newprice,
                              //            @"longitude":os[4],
                                      //     @"latitude":os[3]}];
                }
               // [self addAnimatedAnnotation:allDatas];
                
                _allDatas = allDatas;
                 [self addPointJuheWithCoorArray:allDatas];
                [self addLine:[ds objectForKey:@"polygons"]];
            }else{
                
                
            }
        }
        
      
    } failure:^(NSError *error) {
         [self hideLoading];
    }];

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
       self.ctitleLabel.text = self.lang[@"nearbyTitle"];
  

}


- (void)customLocationAccuracyCircle {
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.accuracyCircleStrokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    param.accuracyCircleFillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0];
    [_mapView updateLocationViewWithParam:param];
    [_mapView setZoomLevel:13];
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
        cutomView.lineWidth = 5.0;
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
    
    //polygons
    NSInteger count = [points count];
    int i = 0;
    
    BMKMapPoint *temppoints = new BMKMapPoint[count];
    
    for (NSArray *obj in points) {
        
     
        double longt = [[obj objectAtIndex:0] doubleValue];
        double  lant= [[obj objectAtIndex:1] doubleValue];
        CLLocationCoordinate2D coor1;
        coor1.latitude = lant;
        coor1.longitude = longt;
        BMKMapPoint pt1 = BMKMapPointForCoordinate(coor1);
        
        temppoints[i].x = pt1.x;
        temppoints[i].y = pt1.y;
        i++;
        //////
        
    }
    
    
    
    
    CustomOverlay* custom = [[CustomOverlay alloc] initWithPoints:temppoints count:  [points count]];
    [_mapView addOverlay:custom];
    delete[] temppoints;
    
}




//添加模型数组
- (void)addPointJuheWithCoorArray:(NSArray *)array {
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < array.count; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    //点聚合管理类
    _clusterManager = [[BMKClusterManager alloc] init];
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
        if(idx == 1){
         [self.mapView setCenterCoordinate:coor animated:YES];
        }
       
        
    }];
    [self updateClusters];
}

//更新聚合状态
- (void)updateClusters {
    _clusterZoom = (NSInteger)self.mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 4)];
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
   
    
    if(_clusterZoom != self.mapView.zoomLevel && _allDatas != nil && _allDatas.count > 0){
        
        
    
     [self addPointJuheWithCoorArray:_allDatas];
        
    }else{
        
    
    }
   
    _clusterZoom = (NSInteger)self.mapView.zoomLevel;
    //[self.mapView setCenterCoordinate:leftBottom animated:YES];
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
        if(_firstannotationView != nil){
        
            _firstannotationView.selected = NO;
        }
        _firstannotationView = annotationView;
        _selectView.hidden = NO;
    
    }else{
       // [mapView setCenterCoordinate:view.annotation.coordinate];
       // [mapView zoomIn];
        self.mapView.zoomLevel = self.mapView.zoomLevel + 4;
        _clusterZoom = (NSInteger)self.mapView.zoomLevel;
        CLLocationCoordinate2D coor;
        coor.latitude = annotationView.model.lat;
        coor.longitude = annotationView.model.lon;
       // [self.mapView setCenterCoordinate:coor animated:YES];
    
    }
}



@end

