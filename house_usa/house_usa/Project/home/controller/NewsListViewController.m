//
//  NewsListViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "NewsListViewController.h"
#import "HomeNewsCell.h"
#import "BMapUtil.h"
#import "MJRefresh.h"
#import "HomeModel.h"
#import "ZYBannerView.h"
#import "NewsDetailsViewController.h"
@interface NewsListViewController ()<UITableViewDataSource,UITableViewDelegate,ZYBannerViewDataSource, ZYBannerViewDelegate>{
    BOOL reloading;
    NSInteger offset;
    NSInteger limit;
    NSInteger typeId;
}
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)  NSMutableArray *newsdatas;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (nonatomic, strong) ZYBannerView *banner;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UILabel *imglabel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong)UIButton *sbtn;

@property (nonatomic, strong) NSArray *categoryKeyArray;

@end

@implementation NewsListViewController

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    offset = 0;
    limit = 15;
    _newsdatas = [NSMutableArray array];
    _inputView.layer.cornerRadius = 3;
    [self setupRefreshHeaderView];
   
   _headerView =   [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 260)];
    _headerView.backgroundColor = GlobalGrayColor;
    _tableView.tableHeaderView = _headerView;
    
    
    
    UILabel *calabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 200, 120, 30)];
    calabel.textColor = GlobalTintColor;
    calabel.font = [UIFont systemFontOfSize:12];
    calabel.textAlignment =NSTextAlignmentLeft ;
    calabel.text = @"切换分类";
    [_headerView addSubview:calabel];
    
    
    
    _sbtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 44, 200, 44, 30)];
    _sbtn.selected = YES;
    
    [_sbtn addTarget:self action:@selector(changState:) forControlEvents:UIControlEventTouchUpInside];
    
    [_sbtn setImage:[UIImage imageNamed:@"proserviceall"] forState:UIControlStateNormal];
    [_headerView addSubview:_sbtn];

    
    [self setupBanner];
    [self loadBannerData];
    [self loadCategoryData];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
     self.ctitleLabel.text = self.lang[@"latestNewsTitle"];
}
-(void)changState:(id)sender{
   
    _sbtn.selected = !_sbtn.selected;
    
    if(_sbtn.selected){
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 260);
        
        [_tableView reloadData];
    }else{
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 300);
        
        [_tableView reloadData];
    
    }
    
   
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
    
    _imglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, ScreenWidth, 30)];
    _imglabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

    _imglabel.textColor = [UIColor whiteColor];
    _imglabel.font = [UIFont systemFontOfSize:12];
    _imglabel.textAlignment =NSTextAlignmentCenter ;
    [self.banner addSubview:_imglabel];
    
    [_tableView.tableHeaderView addSubview:self.banner];
}


-(void)loadBannerData{
    
    NSDictionary *params = @{@"area_id":@"ma"};
    [[HomeModel sharedInstance] findNewsBannerList:params success:^(id operation) {
        
        if([operation[@"code"] integerValue] == 200){
            
            _dataArray = operation[@"data"];
            NSDictionary *obj = self.dataArray[0];
            _imglabel.text = obj[@"title"];
            [_banner reloadData];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


-(void)loadCategoryData{
    
    NSDictionary *params = @{};
    [[HomeModel sharedInstance] findNewsCategoryList:params success:^(id operation) {
        
        if([operation[@"code"] integerValue] == 200){
           
            [self initCategoryData:operation[@"data"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)selectType:(id)sender{
    UIButton *label = sender;
    for (NSString *key in _categoryKeyArray) {
        UIButton *allBtn  = ( UIButton *)[_headerView viewWithTag:(100000+[key integerValue])];
        
        allBtn.layer.borderColor = [UIColor colorWithString:@"#dedede"].CGColor;
        [allBtn setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    }
    
    
    label.layer.borderColor = GlobalTintColor.CGColor;
    [label setTitleColor:GlobalTintColor forState:UIControlStateNormal];
    typeId = label.tag - 100000;
      [self.tableView.header beginRefreshing];
    
}
-(void)initCategoryData:(NSDictionary *)data{
    _categoryKeyArray = data.allKeys;
    CGFloat myY = _sbtn.frame.origin.y + 30;
    
    CGFloat width = (ScreenWidth - 6*5) / 5;
    NSInteger i = 0;
    
    for (NSString *key in _categoryKeyArray) {
        
        UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(i*width+(i+1)*5, myY, width, 20)];
        [label setTitle:data[key] forState:UIControlStateNormal];
        label.layer.cornerRadius = 5;
        label.layer.borderWidth = 1;

        label.tag = 100000 + [key integerValue];
     
        label.titleLabel.font = [UIFont systemFontOfSize:12];
        [label addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            label.layer.borderColor = GlobalTintColor.CGColor;
            [label setTitleColor:GlobalTintColor forState:UIControlStateNormal];
            typeId = [key integerValue];
          [self.tableView.header beginRefreshing];
        }else{
            label.layer.borderColor = [UIColor colorWithString:@"#dedede"].CGColor;
                          [label setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
        }
        [_headerView addSubview:label];

        
        i++;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefreshHeaderView{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offset = 1;
        [self loadDataWithIndex];
    }];
    
    self.tableView.footer = [MJRefreshAutoGifFooter  footerWithRefreshingBlock:^{
        [self loadDataWithIndex];
        
    }];
    
  
    
}

- (void)loadDataWithIndex{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(typeId){
    
        [params setObject:@(typeId) forKey:@"type_id"];
    }
    
      [params setObject:@(offset) forKey:@"page"];
      [params setObject:@(limit) forKey:@"page_size"];
    [[HomeModel sharedInstance] findNewsList:params success:^(id operation) {
        if([operation[@"code"] integerValue] == 200){
            NSArray *datas = operation[@"data"][@"items"];
            if(offset == 1){
                [self.newsdatas  removeAllObjects];
                [self.tableView reloadData];
            }
            
            [self.newsdatas addObjectsFromArray:datas];
            
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            offset++;
        
        }
        
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsdatas count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    static NSString *identifierb=@"HomeNewsCell";
    HomeNewsCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
    if (cell==nil) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"HomeNewsCell" owner:nil options:nil] firstObject];
    }
    NSDictionary *data = [_newsdatas objectAtIndex:row];
    [cell setData:data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - ZYBannerViewDataSource

// 返回 Banner 需要显示 Item(View) 的个数
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner
{
   
    return self.dataArray.count;
}

// 返回 Banner 在不同的 index 所要显示的 View (可以是完全自定义的v iew, 且无需设置 frame)
- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    NSDictionary *obj = self.dataArray[index];
    // 取出数据
    NSString *imageName = obj[@"image"];
    
    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
    // imageView.image = [UIImage imageNamed:imageName];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
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
    NSLog(@"点击了第%ld个项目", (long)index);
    
    NewsDetailsViewController *controller = [[NewsDetailsViewController alloc] initWithNibName:@"NewsDetailsViewController" bundle:nil];
    NSDictionary *sData = [_dataArray objectAtIndex:index];
    NSMutableDictionary *nowdata = [[NSMutableDictionary alloc] initWithDictionary:sData];
    [nowdata setObject:sData[@"news_id"] forKey:@"id"];
    [controller setData:nowdata];
    
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)banner:(ZYBannerView *)banner didScrollToItemAtIndex:(NSInteger)index
{
    NSLog(@"滚动到第%ld个项目", (long)index);
    NSInteger current = index +1;
      NSDictionary *obj = self.dataArray[index];
    _imglabel.text = obj[@"title"];
}

// 在这里实现拖动 Footer 后的事件处理
- (void)bannerFooterDidTrigger:(ZYBannerView *)banner
{
    NSLog(@"触发了footer");
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsDetailsViewController *controller = [[NewsDetailsViewController alloc] initWithNibName:@"NewsDetailsViewController" bundle:nil];
    NSDictionary *sData = [_newsdatas objectAtIndex:indexPath.row];
    [controller setData:sData];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}


@end
