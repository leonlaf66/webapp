//
//  HouseDetailViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HouseDetailViewController.h"
#import "BMapUtil.h"
#import "MJRefresh.h"
#import "HomeModel.h"
#import "HouseDetailMapViewCell.h"
#import "HouseDetailDatasViewCell.h"
#import "HouseDetailBannerViewCell.h"
#import "ZYBannerView.h"

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
#import "HouseMoreDetailViewController.h"
#import "LXActivity.h"
#import "NearByViewCell.h"
#import "NearByItemViewCell.h"

#import "HouseDetailServiceView.h"
#import "CalcutorFrontViewController.h"
#import "LCCChatViewController.h"
#import "ScheduleViewController.h"
#import "NearbyViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface HouseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ZYBannerViewDataSource, ZYBannerViewDelegate,BMKMapViewDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,LXActivityDelegate>{

    BMKMapManager* _mapManager;
    BMKLocationService* _locService;
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
    
        BMKCircle* circle;
        BMKPolygon* polygon;
        BMKPolygon* polygon2;
        BMKPolyline* polyline;
        BMKPolyline* colorfulPolyline;
        BMKArcline* arcline;
        BMKGroundOverlay* ground2;
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZYBannerView *banner;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UILabel *imglabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSDictionary *datas;

@property (strong, nonatomic)  BMKMapView *mapView;

@property (strong, nonatomic) HouseDetailDatasViewCell   *datacell;

@property (strong, nonatomic) HouseDetailMapViewCell   *mapCell;
@property (strong, nonatomic) UILabel *likeLabel;
@property (strong, nonatomic) UILabel *shareLabel;
@property (strong, nonatomic)UIButton *mapbtn;

@property (strong, nonatomic) NearByViewCell   *nearByCell;

@property (weak, nonatomic) IBOutlet UILabel *dyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dyImage;

@property (weak, nonatomic) IBOutlet UILabel *fdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fdImage;

@property (weak, nonatomic) IBOutlet UILabel *kflabel;
@property (weak, nonatomic) IBOutlet UIImageView *kfimage;

@property (strong, nonatomic)UIView *favorieBtn;
@property (strong, nonatomic)UIView *shareBtn;


@property (strong, nonatomic) HouseDetailServiceView   *houseDetailServiceView;

@property (strong, nonatomic)  UIView *serviceView;

@property (strong, nonatomic)  UIView *bgView;


@property (nonatomic, strong) NSString *chatURL;


@property (strong, nonatomic) NSString *myPrice;
@property (strong, nonatomic) NSString *myTax;
@property (strong, nonatomic)UIImageView *likeImg;

@property (nonatomic)BOOL readed;

@end

@implementation HouseDetailViewController

-(void)hideaction{
    _bgView.hidden  = YES;
      _serviceView.hidden = YES;
    _shareBtn.hidden = NO;
    _favorieBtn.hidden = NO;
    _dyLabel.textColor = [UIColor colorWithString:@"#b2b2b2"];
    _dyImage.image = [UIImage imageNamed:@"icncontact"];

    _serviceView.frame = CGRectMake(0, ScreenHight, ScreenWidth, 200);
}
-(void)showService{
   _bgView.hidden  = NO;
    _serviceView.hidden = NO;
    _shareBtn.hidden = YES;
    _favorieBtn.hidden = YES;
    _dyLabel.textColor = GlobalTintColor;
    _dyImage.image = [UIImage imageNamed:@"icncontact1"];
    
    [UIView animateWithDuration:0.5 animations:^{
         _serviceView.frame = CGRectMake(0, ScreenHight - 200 - 44, ScreenWidth, 200);
    }];

}
-(void)gofd{
    
    if(_datas && ![@"Unknown" isEqualToString:_datas[@"list_price"]]){
        CalcutorFrontViewController *cv = [[CalcutorFrontViewController alloc] initWithNibName:@"CalcutorFrontViewController" bundle:nil];
        
          NSDictionary *data = @{@"price": _datas[@"list_price"],@"tax":_myTax};
        
        [cv setData:data];
        [self.navigationController pushViewController:cv animated:YES];
    
    }
   

}

-(void)dialogChinese{

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"8572054318"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)dialogEnglish{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"13167111930"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}


#pragma mark -
#pragma mark Tasks

- (void)requestUrl
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@LC_URL];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    NSError *jsonError;
                    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingAllowFragments
                                                                           error:&jsonError];
                    
                    if ([JSON isKindOfClass:[NSDictionary class]] && [JSON valueForKey:@"chat_url"] != nil) {
                        self.chatURL = [self prepareUrl:JSON[@"chat_url"]];
                    } else if (jsonError) {
                        NSLog(@"%@", jsonError);
                    }
                } else {
                    NSLog(@"%@", error);
                }
            }] resume];
}

#pragma mark -
#pragma mark Helper functions

- (NSString *)prepareUrl:(NSString *)url
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"https://%@", url];
    
    [string replaceOccurrencesOfString:@"{%license%}"
                            withString:@LC_LICENSE
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    
    [string replaceOccurrencesOfString:@"{%group%}"
                            withString:@LC_CHAT_GROUP
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    
    return string;
}

#pragma mark -
#pragma mark Actions

- (void)goChat {
    
    
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[LCCChatViewController alloc] initWithChatUrl:self.chatURL]] animated:YES completion:nil];
    
    
}
-(void)goSchedule{

    ScheduleViewController *controller = [[ScheduleViewController alloc] initWithNibName:@"ScheduleViewController" bundle:nil];
    controller.data = _data;
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ctitleLabel.text = self.lang[@"houseDetail"];
    // Do any additional setup after loading the view from its nib.
   
    [self setupBanner];
    
    [self initMyViews];
    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, 1090)];
    
    
    _houseDetailServiceView= [[[NSBundle mainBundle]loadNibNamed:@"HouseDetailServiceView" owner:nil options:nil] firstObject];
   
    
    _serviceView =  [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHight, ScreenWidth, 200)];
    _serviceView.backgroundColor = [UIColor whiteColor];
    _serviceView.hidden = YES;
    [_serviceView addSubview:_houseDetailServiceView.contentView];
    
    
    UIButton *sbtn = [_serviceView viewWithTag:6662];
    
    [sbtn addTarget:self action:@selector(dialogChinese) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sabtn = [_serviceView viewWithTag:6662];
    
    [sabtn addTarget:self action:@selector(dialogEnglish) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton *ssabtn = [_serviceView viewWithTag:6666];
    
    [ssabtn addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *serBtn = [self.view viewWithTag:777771];
    
    
    UITapGestureRecognizer *servtapGra = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(showService)];
    serBtn.userInteractionEnabled = YES;
    
    [serBtn addGestureRecognizer:servtapGra];
    
    ///
    UIView *cerBtn = [self.view viewWithTag:777772];
    
    
    UITapGestureRecognizer *cerBtntapGra = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(gofd)];
    cerBtn.userInteractionEnabled = YES;
    
    [cerBtn addGestureRecognizer:cerBtntapGra];
    
    ///
    
    UIView *schedulecerBtn = [self.view viewWithTag:777773];
    
    
    UITapGestureRecognizer *schecerBtntapGra = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(goSchedule)];
    schedulecerBtn.userInteractionEnabled = YES;
    
    [schedulecerBtn addGestureRecognizer:schecerBtntapGra];
    
    ///

    
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHight)];
    
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _bgView.hidden = YES;
    UITapGestureRecognizer *backtapGra = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(hideaction)];
    _bgView.userInteractionEnabled = YES;
    
    [_bgView addGestureRecognizer:backtapGra];
    
    [self.view insertSubview:_bgView aboveSubview:_scrollView];

      [self.view insertSubview:_serviceView aboveSubview:_bgView];

        
     _datacell= [[[NSBundle mainBundle]loadNibNamed:@"HouseDetailDatasViewCell" owner:nil options:nil] firstObject];
    _datacell.contentView.frame = CGRectMake(0, 200, ScreenWidth, 330);
    [_scrollView addSubview:_datacell.contentView];
    _datacell.roiLabel.text = self.lang[@"roi"];

   
    
    [_datacell.moreBtn addTarget:self action:@selector(goMore) forControlEvents:UIControlEventTouchUpInside];
    //

          _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 530, ScreenWidth, 300)];
           [_mapView setTrafficEnabled:NO];
           [_mapView setBuildingsEnabled:YES];
        _mapView.delegate = self;

        [_mapView setBaiduHeatMapEnabled:NO];
    
    [_scrollView addSubview:_mapView];
    
    _mapbtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 780, 60, 35)];
    
    [_mapbtn setTitle:@"地图" forState:UIControlStateNormal];
    
    _mapbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_mapbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_mapbtn setBackgroundColor:GlobalTintColor];
    
    _mapbtn.layer.cornerRadius = 2;

   // [_scrollView addSubview:_mapbtn];
    
    
    _nearByCell= [[[NSBundle mainBundle]loadNibNamed:@"NearByViewCell" owner:nil options:nil] firstObject];
    _nearByCell.contentView.frame = CGRectMake(0, 831, ScreenWidth, 291);
    UIButton *nbtn = (UIButton *)[_nearByCell viewWithTag:666666];
    nbtn.userInteractionEnabled = YES;
    [nbtn addTarget:self action:@selector(goNearBy) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_nearByCell.contentView];
    
  

// _tableView.tableFooterView = _mapView;
_mapManager = [[BMKMapManager alloc]init];

[self customLocationAccuracyCircle];

if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
    NSLog(@"经纬度类型设置成功");
} else {
    NSLog(@"经纬度类型设置失败");
}

BOOL ret = [_mapManager start:BMKEY generalDelegate:self];
if (!ret) {
    NSLog(@"manager start failed!");
}

// [BMKLocationService setLocationDistanceFilter:1];
_locService = [[BMKLocationService alloc]init];
_locService.delegate = self;
_mapView.userInteractionEnabled = YES;
_mapView.showsUserLocation = NO;
_mapView.userTrackingMode = BMKUserTrackingModeFollow;
_mapView.showsUserLocation = YES;
    
    _readed = NO;

    [self loadData];
    
    
    [self requestUrl];

}
-(void)goNearBy{
    
    if(_datas){
        NearbyViewController *nc = [[NearbyViewController alloc] initWithNibName:@"NearbyViewController" bundle:nil];
         nc.lat = [_datas[@"latitude"] doubleValue];
         nc.lon = [_datas[@"longitude"] doubleValue];
         nc.currentData = _datas;
        [self.navigationController pushViewController:nc animated:YES];
    
    }

  
}

-(void)shareacton{
    LXActivity *share = [[LXActivity alloc] initWithTitle:@"share" delegate:self cancelButtonTitle:@"Cancel" ShareButtonTitles:nil withShareButtonImagesName:nil];
    

    [share share:_datas inView:self.view success:^{
        if([[self getMyLang] containsString:@"zh"]){
            [self showMsg:@"分享成功"];
        }else{
          [self showMsg:@"Share successfully"];
        }
       // [self showMsg:self.lang[@"shareSuccess"]];
    } failure:^(NSError *error) {
       // [self showMsg:self.lang[@"shareFailed"]];
    }];


}
-(void)initMyViews{
    
    _shareBtn = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 70, ScreenHight - 130, 50, 50)];
    _shareBtn.backgroundColor =   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _shareBtn.layer.cornerRadius = 25;
    UIImageView *shareImg =  [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    shareImg.image = [UIImage imageNamed:@"share"];
    _shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 50, 20)];
    _shareLabel.textColor = [UIColor whiteColor];
    _shareLabel.text = @"分享";
    _shareLabel.font = [UIFont systemFontOfSize:10];
    _shareLabel.textAlignment = NSTextAlignmentCenter;
    [_shareBtn addSubview:shareImg];
     [_shareBtn addSubview:_shareLabel];
    
    UITapGestureRecognizer *backtapGra = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(shareacton)];
    _shareBtn.userInteractionEnabled = YES;
    
    [_shareBtn addGestureRecognizer:backtapGra];
    
    [self.view insertSubview:_shareBtn aboveSubview:_scrollView];
    
    
    
    
    
    _favorieBtn = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 70, ScreenHight - 200, 50, 50)];
    _favorieBtn.backgroundColor =   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _favorieBtn.layer.cornerRadius = 25;
    
    
    _likeImg =  [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    _likeImg.image = [UIImage imageNamed:@"like"];
    _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 50, 20)];
    _likeLabel.textColor = [UIColor whiteColor];
    _likeLabel.text = @"收藏";
    _likeLabel.font = [UIFont systemFontOfSize:10];
    _likeLabel.textAlignment = NSTextAlignmentCenter;
    [_favorieBtn addSubview:_likeImg];
    [_favorieBtn addSubview:_likeLabel];
    
    
    
    UITapGestureRecognizer *fabacktapGra = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(addFavAction)];
    _shareBtn.userInteractionEnabled = YES;
    
    [_favorieBtn addGestureRecognizer:fabacktapGra];

    
    [self.view insertSubview:_favorieBtn aboveSubview:_scrollView];
    
   



}

-(void)loadFavAction{
    NSMutableArray *users =  [[UPDao sharedInstance] getUsers];
    
    if([users count] >0){
        
        
        NSDictionary *params = @{@"page":@(1),@"page_size":@(100)};
        
        [[HomeModel sharedInstance] getFovaritesHouse:params success:^(id operation) {
           
            if([operation[@"code"] integerValue] == 200){
                
                NSArray *items = operation[@"data"][@"items"];
                
                for (NSDictionary *obj in items) {
                    
                    NSDictionary *house = obj[@"house"];
                    
                    if([house[@"id"] integerValue] == [_data[@"id"] integerValue] ){
                    
                      _likeImg.image = [UIImage imageNamed:@"alike"];
                        _readed = YES;
                    }
                    
                }
              
                
            }
            
            
        } failure:^(NSError *error) {
           
        }];
        
        
    }else{
       
        
        
    }
    


}

-(void)addFavAction{
    
    
    NSMutableArray *users =  [[UPDao sharedInstance] getUsers];
    
    if([users count] >0){
        
        if(!_readed){
            [self showLoading:@""];
            
            NSDictionary *params = @{@"id":_data[@"id"]};
            
            [[HomeModel sharedInstance] addFovaritesHouse:params success:^(id operation) {
                [self hideLoading];
                if([operation[@"code"] integerValue] == 200){
                    
                    
                    
                    if([[self getMyLang] containsString:@"zh"]){
                        
                        
                        [self showMsg:@"收藏成功"];
                        
                    }else{
                        
                        [self showMsg:@"Bookmark successfully"];
                        
                        
                    }
                    
                    //   [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
                
            } failure:^(NSError *error) {
                [self hideLoading];
            }];

        
        }else{
            if([[self getMyLang] containsString:@"zh"]){
                
                
                [self showMsg:@"你已经收藏过该房源"];
                
            }else{
                
                [self showMsg:@"Bookmark successfully"];
                
                
            }

        
        }
        

    }else{
        [self goLogina];
    
    }
    
    

}


-(void)goLogina{
    
    LoginViewController *lc =  [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.loginController = lc;
    
    
    
    [self.navigationController pushViewController:lc animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [_datacell.moreBtn setTitle:self.lang[@"moreInformation"] forState:UIControlStateNormal];
    
     _likeLabel.text = self.lang[@"like"];
        _shareLabel.text =self.lang[@"share"];
    _nearByCell.titleLabel.text = self.lang[@"nearbyLabel"];
    [_nearByCell.nearByBtn setTitle:self.lang[@"nearbyLabel"] forState:UIControlStateNormal];
    
      [_mapbtn setTitle:self.lang[@"map"] forState:UIControlStateNormal];
    
    //"contactInfo" = "CONTACT INFO";
    //"mortgage" = "MORTGAGE CALC";
   // "scheduleTour" = "SCHEDULE TOUR";
    
      _dyLabel.text = self.lang[@"contactInfo"];
      _fdLabel.text = self.lang[@"mortgage"];
      _kflabel.text = self.lang[@"scheduleTour"];
    
    ////
    
    
    UILabel *titleLabel = [_serviceView viewWithTag:6661];
    titleLabel.text = self.lang[@"serviceTtile"];
    
    UILabel *emailLabel = [_serviceView viewWithTag:6664];
    emailLabel.text = self.lang[@"emailLabel"];
    
    UILabel *wxLabel = [_serviceView viewWithTag:6665];
    wxLabel.text = self.lang[@"wxLabel"];
    
    
    UIButton *sbtn = [_serviceView viewWithTag:6666];
    wxLabel.text = self.lang[@"wxLabel"];
    
    [sbtn setTitle:self.lang[@"onlineServiceLabel"] forState:UIControlStateNormal];

    
}
-(void)goMore{
    
    HouseMoreDetailViewController *controller = [[HouseMoreDetailViewController alloc] initWithNibName:@"HouseMoreDetailViewController" bundle:nil];
    controller.datas = _datas[@"details"];
    [self.navigationController pushViewController:controller animated:YES];


}

-(void)setData:(NSDictionary *)data{

    _data = data;
}

-(void)loadData{
    [self showLoading:@""];
  
    NSDictionary *param = @{@"id":_data[@"id"]};
    [[HomeModel sharedInstance] getHouseDetail:param success:^(NSDictionary *operation) {
        
          _datas = operation[@"data"];
        
        [self setdatas];
       [self setAreaHouse];
        [self hideLoading];
         [self loadFavAction];
    } failure:^(NSError *error) {
        // [_indicator stopAnimating];
         [self hideLoading];
    }];
    
}
-(void)setAreaHouse{
    NSArray *items =_datas[@"recommend_houses"];
    
    _nearByCell.scrollView.backgroundColor = [UIColor colorWithString:@"#dedede"];
     [_nearByCell.scrollView setContentSize:CGSizeMake(150*items.count + (items.count+1)*12, 160)];

    NSInteger i = 0;

    for (NSDictionary *obj in items) {
      NearByItemViewCell    *cell = [[[NSBundle mainBundle]loadNibNamed:@"NearByItemViewCell" owner:nil options:nil] firstObject];
        cell.frame = CGRectMake(i*150+(i+1)*12, 5, 150, 151);
        cell.layer.cornerRadius = 1.5;
        [cell setData:obj];
        
        UITapGestureRecognizer *backtapGra = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapped:)];
        cell.userInteractionEnabled = YES;
        
        [cell addGestureRecognizer:backtapGra];

        [_nearByCell.scrollView addSubview:cell];
        i++;
    }
    
    
}

- (void)tapped:(UITapGestureRecognizer *)t {
    
    NearByItemViewCell *cell = ( NearByItemViewCell *)t.view;
    NSDictionary*obj = cell.data;
    // _listNo = _data[@"list_no"][@"value"];
  
    
    HouseDetailViewController *controller = [[HouseDetailViewController alloc] initWithNibName:@"HouseDetailViewController" bundle:nil];
    [controller setData:obj];
    [controller setType:_type];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)setupBanner
{
    // 初始化
    self.banner = [[ZYBannerView alloc] init];
    self.banner.dataSource = self;
    self.banner.delegate = self;
    self.banner.autoScroll = YES;
   // [self.view addSubview:self.banner];
    self.banner.pageControl.hidden = YES;
    self.banner.shouldLoop = YES;
    // 设置frame
    self.banner.frame = CGRectMake(0,
                                   0,
                                   ScreenWidth,
                                   200);
    
    _imglabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 180, 40, 15)];
    _imglabel.backgroundColor = [UIColor darkGrayColor];
    _imglabel.layer.cornerRadius = 6;
    _imglabel.clipsToBounds = YES;
    _imglabel.textColor = [UIColor whiteColor];
    _imglabel.font = [UIFont systemFontOfSize:10];
    _imglabel.textAlignment =NSTextAlignmentCenter ;
    [self.banner addSubview:_imglabel];
    
    [_scrollView addSubview:self.banner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupRefreshHeaderView{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self loadData];
    }];
    
    
    [self.tableView.header beginRefreshing];
    
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    if(row == 0){
       
        return 200;
    }else  if(row == 1){
        
        return 330;
    }else  if(row == 2){
       
        return 400;
    }else {
        
        return 10;
    }
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if(row == 0){
        static NSString *identifierb=@"HouseDetailBannerViewCell";
        HouseDetailBannerViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
        if (cell==nil) {
            
            cell= [[[NSBundle mainBundle]loadNibNamed:@"HouseDetailBannerViewCell" owner:nil options:nil] firstObject];
        }
        [cell.contentView addSubview:_banner];
         UIButton *shareBtn =  [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40, 25, 30, 30)];
        [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [cell.contentView addSubview:shareBtn];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else  if(row == 1){
        static NSString *identifier=@"HouseDetailDatasViewCell";
        HouseDetailDatasViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            
            cell= [[[NSBundle mainBundle]loadNibNamed:@"HouseDetailDatasViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else  if(row == 2){
        static NSString *identifierc=@"HouseDetailMapViewCell";
        HouseDetailMapViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierc];
        if (cell==nil) {
            
            cell= [[[NSBundle mainBundle]loadNibNamed:@"HouseDetailMapViewCell" owner:nil options:nil] firstObject];
        }
         _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 400)];
        [_mapView setTrafficEnabled:NO];
        [_mapView setBuildingsEnabled:YES];
        _mapView.delegate = self;
        
        [_mapView setBaiduHeatMapEnabled:NO];
        
       // _tableView.tableFooterView = _mapView;
        _mapManager = [[BMKMapManager alloc]init];
        
        [self customLocationAccuracyCircle];
        
        if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
            NSLog(@"经纬度类型设置成功");
        } else {
            NSLog(@"经纬度类型设置失败");
        }
        
        BOOL ret = [_mapManager start:BMKEY generalDelegate:self];
        if (!ret) {
            NSLog(@"manager start failed!");
        }
        
        // [BMKLocationService setLocationDistanceFilter:1];
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        _mapView.userInteractionEnabled = YES;
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
        cell.userInteractionEnabled = YES;
        [cell addSubview:_mapView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
    
        return nil;
    }
   
    
}

- (void)customLocationAccuracyCircle {
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.accuracyCircleStrokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    param.accuracyCircleFillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0];
    [_mapView updateLocationViewWithParam:param];
    [_mapView setZoomLevel:14];
}


#pragma mark - ZYBannerViewDataSource

// 返回 Banner 需要显示 Item(View) 的个数
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner
{
    if(self.dataArray.count >0){
         _imglabel.hidden = NO;
         _imglabel.text = [NSString stringWithFormat:@"1/%ld",[_dataArray count]];
    }else{
        _imglabel.hidden = YES;
    }
    return self.dataArray.count;
}

// 返回 Banner 在不同的 index 所要显示的 View (可以是完全自定义的v iew, 且无需设置 frame)
- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    // 取出数据
    NSString *imageName = self.dataArray[index];
    
    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
   // imageView.image = [UIImage imageNamed:imageName];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return imageView;
}

// 返回 Footer 在不同状态时要显示的文字
- (NSString *)banner:(ZYBannerView *)banner titleForFooterWithState:(ZYBannerFooterState)footerState
{
    if (footerState == ZYBannerFooterStateIdle) {
        return @"拖动进入下一页";
    } else if (footerState == ZYBannerFooterStateTrigger) {
        return @"释放进入下一页";
    }
    return nil;
}

#pragma mark - ZYBannerViewDelegate

// 在这里实现点击事件的处理
- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
  //  NSLog(@"点击了第%ld个项目", (long)index);
}

- (void)banner:(ZYBannerView *)banner didScrollToItemAtIndex:(NSInteger)index
{
  //  NSLog(@"滚动到第%ld个项目", (long)index);
    NSInteger current = index +1;
     _imglabel.text = [NSString stringWithFormat:@"%ld/%ld",current,[_dataArray count]];
}

// 在这里实现拖动 Footer 后的事件处理
- (void)bannerFooterDidTrigger:(ZYBannerView *)banner
{
    NSLog(@"触发了footer");
    
}

#


#pragma mark Getter

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[];
    }
   
    return _dataArray;
}

- (void)addCurrentAnnotation:(NSDictionary *)obj{
    MyBMKPointAnnotation      * pointAnnotationa = [[MyBMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    // coor1.latitude = [obj[@"latitude"] doubleValue];
    // coor1.longitude = [obj[@"longitude"] doubleValue];
    coor.latitude = [obj[@"latitude"] doubleValue];
    coor.longitude = [obj[@"longitude"] doubleValue];
    pointAnnotationa.coordinate = coor;
    pointAnnotationa.title = obj[@"location"];
    
    
    NSMutableDictionary *ok = [[NSMutableDictionary alloc] initWithDictionary:obj];
    [ok setObject:@"currentMap" forKey:@"icon"];
    pointAnnotationa.data = ok;
    [self.mapView setCenterCoordinate:coor animated:YES];
   [_mapView addAnnotation:pointAnnotationa];
}

// 添加动画Annotation
- (void)addAnimatedAnnotation:(NSArray *)points{
    for (NSDictionary *obj in points) {
        
        MyBMKPointAnnotation      * pointAnnotationa = [[MyBMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        // coor1.latitude = [obj[@"latitude"] doubleValue];
        // coor1.longitude = [obj[@"longitude"] doubleValue];
        coor.latitude = [obj[@"latitude"] doubleValue];
        coor.longitude = [obj[@"longitude"] doubleValue];
        pointAnnotationa.coordinate = coor;
        pointAnnotationa.title = obj[@"location"];
       [self.mapView setCenterCoordinate:coor animated:YES];

        
        
        if([obj[@"id"] isEqualToString:_listNo]){
            NSMutableDictionary *ok = [[NSMutableDictionary alloc] initWithDictionary:obj];
            [ok setObject:@"currentMap" forKey:@"icon"];
          pointAnnotationa.data = ok;
              [self.mapView setCenterCoordinate:coor animated:YES];
        }else{
        
          pointAnnotationa.data = obj;
        
        }
        
              //pointAnnotation.subtitle = @"此Annotation可拖拽!";
        
        [_mapView addAnnotation:pointAnnotationa];
      
        
      
    }
    
    
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


-(void)addLine:(NSArray *)points{
    
    if([points count] == 0){
        return;
    }
    
    NSArray *newpoints = [points objectAtIndex:0];
    
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

-(void)startBDLocation
{
    [_locService startUserLocationService];
}


-(void)stopBDLocation
{
    [_locService stopUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];
   
    
    //   BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    //  reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    
    // [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    // if (annotation == pointAnnotation) {
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[MyBMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorRed;
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        // 设置可拖拽
        annotationView.draggable = NO;
        MyBMKPointAnnotation      * pointAnnotationa = annotation;
        annotationView.image = [UIImage imageNamed:pointAnnotationa.data[@"icon"]];
    
        
    }
    return annotationView;
    
    
}

-(void)initOtherMap:(NSDictionary *) map{
    NSArray *datas = map[@"items"];
    
    
    for (NSDictionary *data in datas) {
        
       [UIImage imageNamed:data[@"icon"]];
    }
    
    
    
    
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}


-(void)setdatas{
    _dataArray = self.datas[@"images"];
    [self.banner reloadData];
   
      [self addCurrentAnnotation:_datas];
    
    ///roi
    NSDictionary *roi = _datas[@"roi"];
    
    if([[self getMyLang] containsString:@"zh"]){
    
        _datacell.typeLabel.text =  [NSString stringWithFormat:@"%@:",@"类        型"];
        _datacell.typeValueLabel.text = _datas[@"prop_type_name"];
        
        _datacell.bedsLabel.text =  [NSString stringWithFormat:@"%@:",@"卧  室  数"];
        _datacell.bedsValueLabel.text =  [NSString stringWithFormat:@"%@",_datas[@"no_bedrooms"]];
        
        
        _datacell.areaLabel.text =  [NSString stringWithFormat:@"%@:",@"面        积"];
        _datacell.areaValueLabel.text =  [NSString stringWithFormat:@"%@",_datas[@"square_feet"]];
        
        
        _datacell.allBathRoomLabel.text =  [NSString stringWithFormat:@"%@:",@"卫生间数"];
        _datacell.allBathRoomValueLabel.text =  [NSString stringWithFormat:@"%@",_datas[@"no_full_baths"]];
        
        _datacell.halfBathRoomLabel.text =  [NSString stringWithFormat:@"%@:",@"区        域"];
        
        _datacell.halfBathRoomValueLabel.text =  [NSString stringWithFormat:@"%@",_datas[@"area"]];
        
        
        _datacell.a2label.text =@"投资回报（全款）" ;
        
        _datacell.b2label.text =  @"周边投资回报（全款）";
        _datacell.c2label.text = @"年净收入预期（全款）";
        
        _datacell.d2label.text =@"区域平均年净收入（全款）";
        
    }else{
        _datacell.typeLabel.text =  [NSString stringWithFormat:@"%@:",@"Property Type"];
        _datacell.typeValueLabel.text = _datas[@"prop_type_name"];
        
        _datacell.bedsLabel.text =  [NSString stringWithFormat:@"%@:",@"Beds"];
        _datacell.bedsValueLabel.text =  [NSString stringWithFormat:@"%@",_datas[@"no_bedrooms"]];
        
        
        _datacell.areaLabel.text =  [NSString stringWithFormat:@"%@:",@"Living Area"];
        _datacell.areaValueLabel.text =  [NSString stringWithFormat:@"%@",_datas[@"square_feet"]];
        
        
        _datacell.allBathRoomLabel.text =  [NSString stringWithFormat:@"%@:",@"Baths"];
        _datacell.allBathRoomValueLabel.text =  [NSString stringWithFormat:@"%@",_datas[@"no_full_baths"]];
        
        _datacell.halfBathRoomLabel.text =  [NSString stringWithFormat:@"%@:",@"Area"];
        
        _datacell.halfBathRoomValueLabel.text =  [NSString stringWithFormat:@"%@",_datas[@"area"]];
        
        
        _datacell.a2label.text =@"Westimated ROI(Cash)" ;
        
        _datacell.b2label.text =  @"Area ROI(Cash)";
        _datacell.c2label.text = @"Area Avg.Net Income(Cash)";
        
        _datacell.d2label.text =@"Net Income(Cash)";
    
    }
    
    
    
    
    
    
     _datacell.a1label.text = [NSString stringWithFormat:@"%@",roi[@"est_roi_cash"]];
    
    ///
    _datacell.b1label.text =[NSString stringWithFormat:@"%@",roi[@"ave_roi_cash"]];

   
    
    _datacell.c1label.text =[NSString stringWithFormat:@"%@",roi[@"est_annual_income_cash"]];
   
    ///
    _datacell.d1label.text =[NSString stringWithFormat:@"%@",roi[@"ave_annual_income_cash"]];
   

    
   // [self addAnimatedAnnotation:self.datas[@"area_houses"][@"items"]];
    NSArray *polygons = self.datas[@"polygons"];
    
  
    
    
    [self addLine: polygons];
    
    
    
    _datacell.titleLabel.text = _datas[@"location"];
    
    
    
  
    
    
    NSDictionary *df = _datas[@"taxes"];
    
    _myTax = df[@"rawValue"];

    
   
    _datacell.priceLabel.textColor =GlobalRedColor;
    
       _datacell.priceLabel.text = [_datas objectForKey:@"list_price"];
  
   // _myPrice = price[@"origin_value"]?price[@"origin_value"]:price[@"value"];
    
   
    

}


@end
