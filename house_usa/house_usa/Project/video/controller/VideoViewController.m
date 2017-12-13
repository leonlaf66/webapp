#import "VideoViewController.h"
#import "BMapUtil.h"
#import "VideoViewCell.h"
#import "MJRefresh.h"
#import "VideoModel.h"
@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL reloading;
    NSInteger offset;
    NSInteger limit;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)  NSMutableArray *datas;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    offset = 0;
    limit = 15;
    _datas = [NSMutableArray array];
    
    [self setupRefreshHeaderView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupRefreshHeaderView{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offset = 0;
        [self loadDataWithIndex:offset];
    }];
    self.tableView.footer =
    [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithIndex:offset + 1];
    }];
    
    [self.tableView.header beginRefreshing];
    
}

- (void)loadDataWithIndex:(NSInteger)index{
    [[VideoModel sharedInstance] findVideoList:@{@"start":@(offset),@"pageSize":@(limit)} success:^(id operation) {
        NSArray *datas = operation[@"result"];
        if(index == 1){
            [self.datas  removeAllObjects];
            [self.tableView reloadData];
        }
        
        [self.datas addObjectsFromArray:datas];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
        [self.tableView.footer endRefreshing];
        offset++;
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}




// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSString *CustomCellIdentifier = @"VideoViewCell";
    
    
    NSDictionary * data = [self.datas objectAtIndex:row];
    VideoViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    [cell setData:data];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
    
    
    
}
@end
