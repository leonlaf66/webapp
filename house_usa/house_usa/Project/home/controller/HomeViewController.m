//
//  HomeViewController.m
//  house_usa
//
//  Created by 林 建军 on 26/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HomeViewController.h"
#import "BMapUtil.h"
#import "HomeViewCell.h"
#import "MJRefresh.h"
#import "HomeModel.h"
#import "HomeHeaderCell.h"
#import "HomeNewsCell.h"
#import "HomeBusinessCell.h"
#import "HomeHouseCell.h"
#import "HouseListViewController.h"
#import "NewsListViewController.h"
#import "ProServiceViewController.h"
#import "HomeMapViewController.h"
//#import "NearbyViewController.h"
#import "NewsDetailsViewController.h"
#import "HouseDetailViewController.h"
#import "ProServiceDetailViewController.h"
#import "AppDelegate.h"
#import "SearchFilterViewController.h"
#import "WorkFlowViewController.h"
#import "HotAreaViewController.h"
#import "ListMapViewController.h"

#import "UPDao+Key.h"
#import "HomeModel.h"
#import "NSString+XTExtension.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL reloading;
    NSInteger offset;
    NSInteger limit;
     BMKLocationService* _locService;
    BMKGeoCodeSearch  *_geoCodeSearch;
    
    HomeHeaderCell *_headercell;

}

@property (weak, nonatomic) IBOutlet UISegmentedControl *langChooseLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *searchTextInput;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)  NSMutableArray *datas;

@property(nonatomic,strong)  NSArray *newsDatas;

@property(nonatomic,strong)  NSArray *houseDatas;

@property(nonatomic,strong)  NSArray *yellowDatas;
@property(nonatomic,strong)  NSString *yellowTitle;
@property (weak, nonatomic) IBOutlet UIView *segView;

@property(nonatomic,strong)  UIButton *addressBtn;

@property(nonatomic,strong)  NSDictionary *hotAreaDatas;

@property(nonatomic,strong)  NSString *hotAreaCode;
@property(nonatomic,strong)  NSString *hotAreaName;
@end

@implementation HomeViewController

- (IBAction)searchAction:(id)sender {
    
    [self goSeach];
    
}
-(void)goSeach{
    SearchFilterViewController *sc = [[SearchFilterViewController alloc] initWithNibName:@"SearchFilterViewController" bundle:nil];
    
    [self.navigationController pushViewController:sc animated:YES];

}
- (IBAction)didSeachActino:(id)sender {
   
    
}
-(void)goHotAreaList{
    HotAreaViewController *con = [[HotAreaViewController alloc] initWithNibName:@"HotAreaViewController" bundle:nil];
    
    con.datas = _hotAreaDatas;
    
    [con setGetBackAction:^(id data){
    _hotAreaCode = data[@"code"];
         [HomeModel sharedInstance].area = _hotAreaCode;
        _hotAreaName = data[@"address"];
      [_headercell.locationBtn setTitle: [NSString stringWithFormat:@" %@",data[@"address"]] forState:UIControlStateNormal];
        [self.tableView.header beginRefreshing];
    }];
    [self.navigationController pushViewController:con animated:YES];

}
-(void)geHotArea{
    
    [self showLoading:@""];

    NSDictionary *params = @{};
    [[HomeModel sharedInstance] getAreaData:params success:^(id operation) {
        [self hideLoading];
        if([operation[@"code"] integerValue] == 200){
            //   _newsDatas =   operation[@"data"];
           // [self initHotDatas:];
            NSDictionary *obj = operation[@"data"];
            _hotAreaDatas  = obj;
                       // _headercell
            
        }
        [self.tableView.header beginRefreshing];
        
    } failure:^(NSError *error) {
         [self hideLoading];
         [self.tableView.header beginRefreshing];
    }];


}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    offset = 0;
    limit = 15;
    _datas = [NSMutableArray array];
    _newsDatas = [NSMutableArray array];
     _houseDatas = [NSMutableArray array];
    _yellowDatas = @[];
    [self setupRefreshHeaderView];
    
       [self geHotArea];
  
   [_langChooseLabel setBackgroundColor:[UIColor whiteColor]];
    _langChooseLabel.layer.cornerRadius = 2;
    [_langChooseLabel setImage:[[UIImage imageNamed:@"china"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    [_langChooseLabel setImage:[[UIImage imageNamed:@"usa"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
    
    
    
   
   
    
    _langChooseLabel.tintColor = ColorWithString(@"#d9d9d9");
    _headView.layer.cornerRadius = 3;
    _segView.clipsToBounds = YES;
    _segView.layer.cornerRadius = 4;
 
    
    [_langChooseLabel addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    _searchTextInput.userInteractionEnabled = YES;
    UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
    [atap addTarget:self action:@selector(goSeach)];
    [_searchTextInput addGestureRecognizer:atap];
    
    
    if ([[self getSystemLang] containsString:@"en"]) {
        _langChooseLabel.selectedSegmentIndex = 0;
        
       
        _hotAreaCode = @"ma";
        _hotAreaName = @"Boston";
        [HomeModel sharedInstance].area = @"ma";
        

        [self setLangs:@"en"];
        [self loadEn];
    }else if([[self getSystemLang] containsString:@"zh"]){
        _hotAreaCode = @"ma";
        _hotAreaName = @"波士顿";
          [HomeModel sharedInstance].area = @"ma";
        [self setLangs:@"zh-Hans"];
        _langChooseLabel.selectedSegmentIndex = 1;
        [self loadCn];
    }
    
   
    [self getVersion];
}



-(void)loadEn{
    [self setLangs:@"en"];
      self.lang = [self getMyLocal];
     _searchTextInput.text = self.lang[@"homeSearchPlaceHolder"];
  

   
    _setLangAction();
}

-(void)loadCn{
    [self setLangs:@"zh-Hans"];
      self.lang = [self getMyLocal];
     _searchTextInput.text = self.lang[@"homeSearchPlaceHolder"];
   

    
     _setLangAction();
}
-(void)segmentAction:(UISegmentedControl *)Seg{
   
    
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:{
              [self loadEn];
          [self.tableView.header beginRefreshing];
        }
          
            break;
            
        case 1:{
          [self loadCn];
        [self.tableView.header beginRefreshing];
        }
          
            
            
            break;
            
            
        default:
            
            break;
    }
}


-(void)setLangs:(NSString *)langs{
    AppDelegate *delegate =  (AppDelegate *) [UIApplication sharedApplication].delegate;
    delegate.lang = langs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
   
}

-(void)setSetLangAction:(SetLangAction)setLangAction{
    _setLangAction = setLangAction;

}
- (void)setupRefreshHeaderView{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
    }];
   
    
   // [self.tableView.header beginRefreshing];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if([_yellowDatas count]> 0 &&
       [_houseDatas count]> 0 &&
       [_newsDatas count]> 0){
        return 4;
        
    }else{
        return 0;
    }

   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
       return 230;
    }else if(indexPath.section == 1){
           return 70;
    }else if(indexPath.section == 2){
           return 125;
    }else{
           return 140 * [_yellowDatas count];
    }
 
}

-(void)loadData{
    
    [self loadHomeNewsData];
    [self loadHomeHouseData];
    [self loadHomeYellowData];
    
  
    

}
-(void)dealData{
  if([_yellowDatas count]> 0 &&
      [_houseDatas count]> 0 &&
      [_newsDatas count]> 0){
      [_tableView.header endRefreshing];
      [_tableView reloadData];
   
  
  }

}

-(void)loadHomeNewsData{
    
    NSDictionary *params = @{};
    [[HomeModel sharedInstance] findHomeNewsList:params success:^(id operation) {
        
        if([operation[@"code"] integerValue] == 200){
            _newsDatas =   operation[@"data"];
            [self dealData];
        }
      
        
    } failure:^(NSError *error) {
        
    }];


}


-(void)loadHomeHouseData{
    
    NSDictionary *params = @{@"area_id":_hotAreaCode};
    [[HomeModel sharedInstance] findHomeHouseList:params success:^(id operation) {
        
        if([operation[@"code"] integerValue] == 200){
            _houseDatas =   operation[@"data"];
             [self dealData];
        }
       

    } failure:^(NSError *error) {
        
    }];
    
    
}


-(void)loadHomeYellowData{
    
    NSDictionary *params = @{};
    [[HomeModel sharedInstance] findHomeYellowList:params success:^(id operation) {
        
        if([operation[@"code"] integerValue] == 200){
            _yellowDatas =   operation[@"data"];
          //  _yellowTitle = [operation[@"data"] objectAtIndex:0][@"name"];
             [self dealData];
             [self loadKeys];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else if(section == 1){
        return [_newsDatas count];
    }else if(section == 2){
        return [_houseDatas count];
    }else{
        return 1;
    }
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    
    if(indexPath.section == 0){
          static NSString *identifier=@"HomeHeaderCell";
         _headercell =[tableView dequeueReusableCellWithIdentifier:identifier];
           if (_headercell==nil) {
                 // cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            _headercell= [[[NSBundle mainBundle]loadNibNamed:@"HomeHeaderCell" owner:nil options:nil] firstObject];
       }
        _headercell.locationBtn.userInteractionEnabled = YES;
          [_headercell.locationBtn addTarget:self action:@selector(goHotAreaList) forControlEvents:UIControlEventTouchUpInside];
        _headercell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [_headercell.locationBtn setTitle: [NSString stringWithFormat:@" %@",_hotAreaName] forState:UIControlStateNormal];
        
        for (NSInteger i = 99991; i<99995;i++) {
            
            UIView *vt =   [_headercell viewWithTag:i];
            
            UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
            [atap addTarget:self action:@selector(tapped:)];
            [vt addGestureRecognizer:atap];
        }
        
      
        return _headercell;
       
    }else if(indexPath.section == 1){
        
        static NSString *identifiera=@"HomeNewsCell";
        HomeNewsCell *cell=[tableView dequeueReusableCellWithIdentifier:identifiera];
        if (cell==nil) {
            
            cell= [[[NSBundle mainBundle]loadNibNamed:@"HomeNewsCell" owner:nil options:nil] firstObject];
        }
        
        NSDictionary *newsdata = [_newsDatas objectAtIndex:indexPath.row];
        [cell setData:newsdata];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

       
    }else if(indexPath.section == 2){
        
        static NSString *identifierb=@"HomeHouseCell";
        HomeHouseCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
        if (cell==nil) {
            
            cell= [[[NSBundle mainBundle]loadNibNamed:@"HomeHouseCell" owner:nil options:nil] firstObject];
        }
        NSDictionary *houseData = [_houseDatas objectAtIndex:indexPath.row];
        [cell setData:houseData];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
       
    }else{
        
        static NSString *identifierc=@"HomeBusinessCell";
        HomeBusinessCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierc];
        if (cell==nil) {
            
            cell= [[[NSBundle mainBundle]loadNibNamed:@"HomeBusinessCell" owner:nil options:nil] firstObject];
        }
        
       // NSDictionary *yellowData = [_yellowDatas objectAtIndex:indexPath.row];
        
        cell.getBack = ^(NSInteger tag){
            ProServiceDetailViewController *controller = [[ProServiceDetailViewController alloc] initWithNibName:@"ProServiceDetailViewController" bundle:nil];
            
            NSDictionary *data = @{@"id":@(tag)};
            
            controller.data = data;
            
            [self.navigationController pushViewController:controller animated:YES];
        
        };
        [cell setData:_yellowDatas];
        
        
        
      
       
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
       
    }
    return nil;
    
    
    
}
-(void)goToHouseList{
    
    HouseListViewController *controller = [[HouseListViewController alloc] initWithNibName:@"HouseListViewController" bundle:nil];
    
    [self.navigationController pushViewController:controller animated:YES];


}

-(void)goToNewsList{
    
    NewsListViewController *controller = [[NewsListViewController alloc] initWithNibName:@"NewsListViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

-(void)goToProServiceList{
    
    ProServiceViewController *controller = [[ProServiceViewController alloc] initWithNibName:@"ProServiceViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    if(section == 0){
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        vh.backgroundColor = GlobalGrayColor;
        return vh;
    }else if(section == 1){
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        UILabel *title= [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
        title.text = self.lang[@"Latestnews"];
        [vh addSubview:title];
        
        UIButton *tnb = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 0, 100, 30)];
        tnb.titleLabel.font = [UIFont systemFontOfSize:12];
        [tnb setTitleColor:GlobalTintColor forState:UIControlStateNormal];
        [tnb setTitle:self.lang[@"more"] forState:UIControlStateNormal];
        [tnb setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
        
        [tnb setImageEdgeInsets:UIEdgeInsetsMake(5, 0,0,0)];
        [tnb addTarget:self action:@selector(goToNewsList) forControlEvents:UIControlEventTouchUpInside];

        [vh addSubview:tnb];
        vh.backgroundColor = GlobalGrayColor;
        return vh;

    }else if(section == 2){
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        
        UILabel *title= [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
        title.text = self.lang[@"houseRecommended"];
        [vh addSubview:title];
        
        vh.backgroundColor = GlobalGrayColor;
        
        
        UIButton *tnb = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 0, 100, 30)];
        tnb.titleLabel.font = [UIFont systemFontOfSize:12];
        [tnb setTitleColor:GlobalTintColor forState:UIControlStateNormal];
        [tnb setTitle:self.lang[@"more"] forState:UIControlStateNormal];
        [tnb setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
         [tnb setImageEdgeInsets:UIEdgeInsetsMake(5, 0,0,0)];
        [tnb addTarget:self action:@selector(goToHouseList) forControlEvents:UIControlEventTouchUpInside];
         [vh addSubview:tnb];

        
        return vh;

    }else{
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        
        UILabel *title= [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
        title.text = self.lang[@"businessRecommended"];
        [vh addSubview:title];
        
        
        UIButton *tnb = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 0, 100, 30)];
        tnb.titleLabel.font = [UIFont systemFontOfSize:12];
        [tnb setTitleColor:GlobalTintColor forState:UIControlStateNormal];
        [tnb setTitle:self.lang[@"more"] forState:UIControlStateNormal];
        [tnb setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
         [tnb setImageEdgeInsets:UIEdgeInsetsMake(5, 0,0,0)];
        
        [tnb addTarget:self action:@selector(goToProServiceList) forControlEvents:UIControlEventTouchUpInside];
        [vh addSubview:tnb];

        vh.backgroundColor = GlobalGrayColor;
        return vh;

    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if(section == 0){
        return 1;
    }else if(section == 1){
        return 30;
    }else if(section == 2){
        return 30;
    }else{
        return 30;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(section == 0){
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        vh.backgroundColor = GlobalGrayColor;
        return vh;
    }else if(section == 1){
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
      
        vh.backgroundColor = GlobalGrayColor;
        return vh;
        
    }else if(section == 2){
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        vh.backgroundColor = GlobalGrayColor;
        return vh;
        
    }else{
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        vh.backgroundColor = GlobalGrayColor;
        return vh;
        
    }
    
}

- (void)tapped:(UITapGestureRecognizer *)t {
   
    NSInteger tag  = t.view.tag;
    switch (tag) {
        case 99991:
        {
            ListMapViewController *controller = [[ListMapViewController alloc] initWithNibName:@"ListMapViewController" bundle:nil];
            controller.fromHome = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 99992:
        {
            
            [self goToNewsList];
        }
            break;
        case 99993:
        {
             [self goToProServiceList];
        }
            break;
        case 99994:
        {
            WorkFlowViewController *controller = [[WorkFlowViewController alloc] initWithNibName:@"WorkFlowViewController" bundle:nil];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == 1){
        NewsDetailsViewController *controller = [[NewsDetailsViewController alloc] initWithNibName:@"NewsDetailsViewController" bundle:nil];
        NSDictionary *sData = [_newsDatas objectAtIndex:indexPath.row];
        [controller setData:sData];
        
        [self.navigationController pushViewController:controller animated:YES];
    
    }else if(indexPath.section == 2){
        HouseDetailViewController *controller = [[HouseDetailViewController alloc] initWithNibName:@"HouseDetailViewController" bundle:nil];
        
        NSDictionary *sData = [_houseDatas objectAtIndex:indexPath.row];
        [controller setData:sData];
        
        [self.navigationController pushViewController:controller animated:YES];
    
    }else if(indexPath.section == 3){
        
      //  [self goToProServiceList];
    }

}



-(void)loadKeys{
    
    NSMutableArray *datas = [[UPDao sharedInstance]  getSearchKeys:@"波士"];
    
    if([datas count] > 0){
        return;
    }else{
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSDictionary *params = @{};
            [[HomeModel sharedInstance] findKeyWordsList:params success:^(id operation) {
                
                if([operation[@"code"] integerValue] == 200){
                    
                    for (NSDictionary *obj  in operation[@"data"]) {
                        
                        Key *key = [[Key alloc] init];
                        key.cityName = obj[@"desc"];
                        key.cityCode = obj[@"title"];
                        [[UPDao sharedInstance] createSearchKey:key];
                    }
                    
                    NSLog(@"");
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        });
        
    }
    
    
    
}



-(void)getVersion{
    
    
    [[HomeModel sharedInstance] getCfg:@{@"app_id":@"iphone",@"config_id":@"iosVersion"} success:^(id operation) {
        
        if([operation[@"code"] integerValue] == 200 && operation[@"data"]){
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            CGFloat  versionCode = [operation[@"data"] floatValue];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
           
            if(versionCode >  [app_Version floatValue]){
                
                NSString *title = @"New version update?";
                NSString *ca = @"Cancel";
                NSString *ok = @"Update";
                
                if([[self getMyLang] containsString:@"zh"]){
                
                  title = @"有新版本需要更新，是否更新？";
                    ca = @"取消";
                    ok = @"更新";
                }
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ca style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                   
                    
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/usleju/id1164743659?l=zh&ls=1&mt=8" ]];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                
               [self presentViewController:alertController animated:YES completion:nil];
        
            }
        
        }
        
       
        
        
    } failure:^(NSError *error) {
        
    }];
    
}



@end
