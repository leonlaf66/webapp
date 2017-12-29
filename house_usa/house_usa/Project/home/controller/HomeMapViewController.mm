//
//  NearbyViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HomeMapViewController.h"

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
@interface HomeMapViewController ()<BMKMapViewDelegate,BMKGeneralDelegate>{
    BMKMapManager* _mapManager;
   
    BMKPointAnnotation* pointAnnotation;
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

@implementation HomeMapViewController


- (void)fangda {
    [_mapView setZoomLevel:_mapView.zoomLevel + 1];
}
- (void)suoxiao{
    [_mapView setZoomLevel:_mapView.zoomLevel - 1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_mapView setTrafficEnabled:NO];
    [_mapView setBuildingsEnabled:YES];
    _mapView.delegate = self;
    
    [_mapView setBaiduHeatMapEnabled:NO];
    
    
    // _tableView.tableFooterView = _mapView;
    _mapManager = [[BMKMapManager alloc]init];
    
    [self customLocationAccuracyCircle];
    
    _selectView.hidden = YES;
   
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
    _filterController.scrollView.frame = CGRectMake(0, 0, ScreenWidth, 250);
    _filterController.getBackAction = ^(id sdata){
        weakSelf.filerView.hidden = YES;
        NSLog(@"selected data is %@",sdata[@"title"]);
        weakSelf.bgView.hidden = YES;
        
    };
   
    CGFloat height = ScreenHight;
    
    
    _filerView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth, 20, ScreenWidth-50, height-20)];
    _filerView.backgroundColor = [UIColor redColor];
    _filerView.hidden = YES;
    _filterController.view.frame =CGRectMake(0, 0, ScreenWidth - 50, height - 44);
    [_filerView addSubview: _filterController.view];
    [self.view addSubview:_filerView];
    
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
    
    
    
    UIView *mapBtn = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 60, ScreenHight/2, 44, 88)];
    mapBtn.backgroundColor = [UIColor whiteColor];
    mapBtn.layer.cornerRadius = 2.5;
    
    [self.view addSubview:mapBtn];
    
    
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


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.ctitleLabel.text = self.lang[@"nearbyTitle"];
    
    
    CLLocationCoordinate2D  coor ;
    coor.latitude = _lat;
    coor.longitude = _lon;
    [self.mapView setCenterCoordinate:coor animated:YES];
    
  
    
    [self addAnimatedAnnotation:_area_houses];
    //
    
    NSArray *lines = _currentData[@"polygons"];
    
   
    
    for (NSArray *objs in lines) {
         [self addLine:objs];
    }
   
    
}


- (void)customLocationAccuracyCircle {
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.accuracyCircleStrokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    param.accuracyCircleFillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0];
    [_mapView updateLocationViewWithParam:param];
    [_mapView setZoomLevel:15];
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



// 添加动画Annotation
- (void)addAnimatedAnnotation:(NSArray *)points{
  
      _selectView.hidden = NO;
    for (NSDictionary *obj in points) {
        
        MyBMKPointAnnotation      * pointAnnotationa = [[MyBMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [obj[@"latitude"] doubleValue];
        coor.longitude = [obj[@"longitude"] doubleValue];
        pointAnnotationa.coordinate = coor;
        
        NSMutableDictionary *newobj = [NSMutableDictionary dictionaryWithDictionary:obj];
        
        if([[self getMyLang] containsString:@"zh"]){
            
            CGFloat price = [obj[@"list_price"] doubleValue] /10000;
            
           
            
        [newobj setObject: [NSString stringWithFormat:@"%ld万美元",[ @(price) integerValue] ] forKey:@"list_price"];
        
        }else{
            
           
        
            [newobj setObject: [NSString stringWithFormat:@"$%@",obj[@"list_price"] ] forKey:@"list_price"];
        }
        
        pointAnnotationa.data = newobj;
        pointAnnotationa.aselected = NO;
        
        [_mapView addAnnotation:pointAnnotationa];
        
        
    }
    
    
    
    MyBMKPointAnnotation      * pointAnnotationa = [[MyBMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [_currentData[@"latitude"] doubleValue];
    coor.longitude = [_currentData[@"longitude"] doubleValue];
    pointAnnotationa.coordinate = coor;
    
    
    pointAnnotationa.data = _currentData;
    pointAnnotationa.aselected = YES;
    
    [_mapView addAnnotation:pointAnnotationa];
    
      [self initDetailsView:_currentData];
    
    
}

-(void)initDetailsView:(NSDictionary *)obj{

    
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
        
        
        _houseInforLabel.text =  [NSString stringWithFormat:@"卧室 %@|全卫 %@ 半卫 %@|居住面积 %@",obj[@"no_bedrooms"],obj[@"no_full_baths"],obj[@"no_half_baths"],obj[@"square_feet"]];
    }else{
        
        _houseInforLabel.text =  [NSString stringWithFormat:@"beds %@|full_baths %@ half_baths %@|square_feet %@",obj[@"no_bedrooms"],obj[@"no_full_baths"],obj[@"no_half_baths"],obj[@"square_feet"]];
        
    }
    
    
    _houseDayLabel.text = obj[@"list_days_description"];
    _houseStatusLabel.text = obj[@"status_name"];
    _selectView.data = obj;
}


-(void)loadDetailData:(NSDictionary *)data{
    [self showLoading:@""];
    
    NSDictionary *param = @{@"id":data[@"id"]};
    [[HomeModel sharedInstance] getHouseDetail:param success:^(NSDictionary *operation) {
        
        if([operation[@"code"] integerValue] == 200){
            NSDictionary *obj = operation[@"data"];
            
            
            [self initDetailsView:obj];
        }
        
        
        [self hideLoading];
    } failure:^(NSError *error) {
        // [_indicator stopAnimating];
        [self hideLoading];
    }];
    
}


-(void)addLine:(NSArray *)points{
    
    
    if([points count] == 0){
        return;
    }
    
    NSArray *newpoints = points;
    
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


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    // if (annotation == pointAnnotation) {
    NSString *AnnotationViewID = @"renameMark";
    MyBMKPinAnnotationView *annotationView = nil;
    
    if (annotationView == nil) {
        annotationView = [[MyBMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorRed;
        // 从天上掉下效果
        annotationView.animatesDrop = NO;
        // 设置可拖拽
        annotationView.draggable = NO;
        MyBMKPointAnnotation  * pointAnnotationa = annotation;
        
        annotationView.image = [UIImage imageNamed:@"downs"];
        MapItemView *v =  [[MapItemView alloc] initWithFrame:CGRectMake(-30, 0, 120, 15)];
       // v.data = pointAnnotationa.data;
        annotationView.mapItemView = v;
        if(pointAnnotationa.aselected){
            _currentAnnotationView = annotationView;
            _currentAnnotationView.aselected = YES;
            
        }
        // annotationView.backgroundColor = [UIColor blueColor];
        UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
        [atap addTarget:self action:@selector(tappea:)];
        [annotationView addGestureRecognizer:atap];
    }
    return annotationView;
    
    
}

- (void)tappea:(UITapGestureRecognizer *)t {
    MyBMKPinAnnotationView *annotationView = ( MyBMKPinAnnotationView *)t.view;
    
    _currentAnnotationView.aselected = NO;
    
    _currentAnnotationView = annotationView;
    
    _currentAnnotationView.aselected = YES;
    
    annotationView.aselected = YES;
    
    MyBMKPointAnnotation  * pointAnnotationa =(MyBMKPointAnnotation *) annotationView.annotation;
    NSDictionary *obj = pointAnnotationa.data;
    //home_business_default
    
    [self loadDetailData:obj];
    
    
}




- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    MyBMKPinAnnotationView *annotationView = (MyBMKPinAnnotationView *)view;
    
    _currentAnnotationView.aselected = NO;
    
    _currentAnnotationView = annotationView;
    
    _currentAnnotationView.aselected = YES;
    
    annotationView.aselected = YES;
    
    MyBMKPointAnnotation  * pointAnnotationa =(MyBMKPointAnnotation *) view.annotation;
    NSDictionary *obj = pointAnnotationa.data;
    //home_business_default
    
    
    [self loadDetailData:obj];
    _selectView.data = obj;
    
    
    
}


@end

