//
//  FavoritesViewController.m
//  house_usa
//
//  Created by 林 建军 on 21/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "FavoritesViewController.h"
#import "HomeHouseCell.h"
#import "BMapUtil.h"
#import "MJRefresh.h"
#import "HomeModel.h"
#import "HouseDetailViewController.h"
@interface FavoritesViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL reloading;
    NSInteger offset;
    NSInteger limit;
}
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)  NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UIView *inputView;


@end

@implementation FavoritesViewController

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    offset = 1;
    limit = 15;
    _datas = [NSMutableArray array];
    _inputView.layer.cornerRadius = 3;
    [self setupRefreshHeaderView];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if([[self getMyLang] containsString:@"zh"]){
        self.ctitleLabel.text = @"我的收藏";
    }else{
        self.ctitleLabel.text = @"My favorites";
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
    [[HomeModel sharedInstance] getFovaritesHouse:@{@"page":@(offset),@"page_size":@(50)} success:^(id operation) {
        
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
    NSDictionary *data = [_datas objectAtIndex:row];
    [cell setSdata:data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
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
        
        NSDictionary *obj =[_datas objectAtIndex:indexPath.row];
        
        [self deleteFav:obj];
        
        [_datas removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

-(void)deleteFav:(NSDictionary *)obj{

    [[HomeModel sharedInstance] deleteFovaritesHouse:@{@"id":obj[@"id"]} success:^(id operation) {
        
        if([operation[@"code"] integerValue] == 200 ){
            
        }
        
    } failure:^(NSError *error) {
        
    }];

}
@end
