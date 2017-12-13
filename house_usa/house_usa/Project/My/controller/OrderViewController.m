//
//  OrderViewController.m
//  house_usa
//
//  Created by 林 建军 on 22/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderViewCell.h"
#import "BMapUtil.h"
#import "MJRefresh.h"
#import "HomeModel.h"
#import "SubscribeViewCell.h"
#import "HouseDetailViewController.h"
@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL reloading;
    NSInteger offset;
    NSInteger limit;
}
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)  NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UIView *inputView;


@end

@implementation OrderViewController

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
   
    
    if([[self getMyLang] containsString:@"zh"]){
     self.ctitleLabel.text = @"我的预约";
    }else{
     self.ctitleLabel.text = @"My schedules";
    }
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
    [[HomeModel sharedInstance] findScheduleList:@{@"page":@(offset),@"page_size":@(50)} success:^(id operation) {
        if([operation[@"code"] integerValue] == 200 ){
            NSArray *datas = operation[@"data"][@"items"];
            if(offset == 1){
                [self.datas  removeAllObjects];
                [self.tableView reloadData];
            }
            
            [self.datas addObjectsFromArray:datas];
            
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            offset++;
            
            [self.tableView.footer endRefreshingWithNoMoreData];
            
        }
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 153;
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.datas count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
   
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        vh.backgroundColor = [UIColor colorWithString:@"#f7f7f7"];
        return vh;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    vh.backgroundColor = [UIColor colorWithString:@"#f7f7f7"];
    return vh;
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    static NSString *identifierb=@"OrderViewCell";
    OrderViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
    if (cell==nil) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"OrderViewCell" owner:nil options:nil] firstObject];
    }
    cell.data =  [_datas objectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSDictionary *data = [_datas objectAtIndex:indexPath.row];
    
    HouseDetailViewController *controller = [[HouseDetailViewController alloc] initWithNibName:@"HouseDetailViewController" bundle:nil];
    [controller setData:data[@"house"]];
   
    [self.navigationController pushViewController:controller animated:YES];
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if([[self getMyLang] containsString:@"zh"]){
        return @"删除";
    }else{
        return @"DELETE";
    }
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{       return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *obj =[_datas objectAtIndex:indexPath.section];
        
        [self deleteFav:obj];
        
    
    }
}

-(void)deleteFav:(NSDictionary *)obj{
   
    
    if([[self getMyLang] containsString:@"zh"]){
        [self showLoading:@"正在删除"];
    }else{
         [self showLoading:@"deleting"];
    }

    
    [[HomeModel sharedInstance] deleteSchedule:@{@"id":obj[@"id"]} success:^(id operation) {
        
        [self hideLoading];
        if([operation[@"code"] integerValue] == 200 ){
            [self.tableView.header beginRefreshing];
        }
        
    } failure:^(NSError *error) {
         [self hideLoading];
    }];
    
}


@end
