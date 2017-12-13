//
//  SubscribeViewController.m
//  house_usa
//
//  Created by 林 建军 on 22/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "SubscribeViewController.h"
#import "BMapUtil.h"
#import "MJRefresh.h"
#import "HomeModel.h"
#import "SubscribeViewCell.h"
@interface SubscribeViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL reloading;
    NSInteger offset;
    NSInteger limit;
}
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)  NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UIView *inputView;


@end

@implementation SubscribeViewController

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    offset = 0;
    limit = 15;
    _datas = [NSMutableArray array];
    _inputView.layer.cornerRadius = 3;
    [self setupRefreshHeaderView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.ctitleLabel.text = @"我的订阅";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefreshHeaderView{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offset = 1;
        [self loadDataWithIndex:offset];
    }];
    
    self.tableView.footer = [MJRefreshAutoGifFooter  footerWithRefreshingBlock:^{
        [self loadDataWithIndex:offset];
        
    }];
    
    [self.tableView.header beginRefreshing];
    
}

- (void)loadDataWithIndex:(NSInteger)index{
    [[HomeModel sharedInstance] findHomeList:@{@"start":@(offset),@"pageSize":@(limit)} success:^(id operation) {
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
    
    return 193;
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    static NSString *identifierb=@"SubscribeViewCell";
    SubscribeViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
    if (cell==nil) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"SubscribeViewCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
@end
