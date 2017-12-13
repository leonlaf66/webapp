//
//  ProServiceDetailViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "ProServiceDetailViewController.h"
#import "HomeModel.h"
#import "MJRefresh.h"
#import "CommentsViewCell.h"
#import "ProDetailHeader.h"
#import "LoginViewController.h"
#import "AddCommentsViewController.h"
#import "AppDelegate.h"
@interface ProServiceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSInteger offset;
    NSInteger limit;
}
@property (weak, nonatomic) IBOutlet UIView *naView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *datas;
@property (strong, nonatomic) ProDetailHeader *proDetailHeader;

@property (strong, nonatomic) NSDictionary *allData;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;

@end

@implementation ProServiceDetailViewController

- (IBAction)weChatAction:(id)sender {
}
- (IBAction)phoneCallAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"9352144934"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    offset = 0;
    limit = 15;
    _datas = [NSMutableArray array];
     _callBtn.layer.cornerRadius = 2.5;
     _weChatBtn.layer.cornerRadius = 2.5;
    // Do any additional setup after loading the view from its nib.
 
    // Do any additional setup after loading the view from its nib.
    
    _naView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    
    
    [self setupRefreshHeaderView];
    
    [self loadDetailData];
}

-(void)addCommentsAction{
    NSMutableArray *users =  [[UPDao sharedInstance] getUsers];
    
    if([users count] >0){
        UserTime *user = [users objectAtIndex:0];
        //[newData setObject:user.token forKey:@"access-token"];
        AddCommentsViewController *controller = [[AddCommentsViewController alloc] initWithNibName:@"AddCommentsViewController" bundle:nil];
        controller.data = _allData;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        [self goLogin];
    }

}
-(void)goLogin{
    
    LoginViewController *lc =  [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.loginController = lc;
    
    
    
    [self.navigationController pushViewController:lc animated:YES];
    
}
-(void)addFAction{
    
    
    NSMutableArray *users =  [[UPDao sharedInstance] getUsers];
    
    if([users count] >0){
        UserTime *user = [users objectAtIndex:0];
        [self showLoading:@""];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:@(offset) forKey:@"page"];
        [params setObject:@(limit) forKey:@"page_size"];
        [[HomeModel sharedInstance] findNewsList:params success:^(id operation) {
            if([operation[@"code"] integerValue] == 200){
                
                [self hideLoading];
            }
            
            
        } failure:^(NSError *error) {
            [self hideLoading];
        }];

        
        
    }else{
        [self goLogin];
    }
    
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if([[self getMyLang] containsString:@"zh"]){
    
        self.ctitleLabel.text = @"服务详情";
    }else{
    
       self.ctitleLabel.text = @"Pro services details";
    }
    
     [self.tableView.header beginRefreshing];
}
-(void)setData:(NSDictionary *)data{

     _data = data;
}

- (void)setupRefreshHeaderView{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
     
        [self loadDataWithIndex];
    }];
    
    
   
    
}

- (void)loadDataWithIndex{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    
    [params setObject:@(offset) forKey:@"page"];
    [params setObject:@(limit) forKey:@"page_size"];
    
    [params setObject:@"yellowpage" forKey:@"type"];
     [params setObject:_data[@"id"] forKey:@"id"];

    [[HomeModel sharedInstance] findCommentsList:params success:^(id operation) {
        if([operation[@"code"] integerValue] == 200){
            
            NSDictionary *data =operation[@"data"];
            
            
            NSArray *datas = data[@"items"];
           
                [self.datas  removeAllObjects];
                [self.tableView reloadData];
            
            
            if(datas != nil ){
             [self.datas addObjectsFromArray:datas];
            }
            
            
           
            
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

- (void)loadDetailData{
    
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_data[@"id"] forKey:@"id"];
       [[HomeModel sharedInstance] findYellowPageDetail:params success:^(id operation) {
        if([operation[@"code"] integerValue] == 200){
            _allData = operation[@"data"];
            [self initProData];
        }
        
        
    } failure:^(NSError *error) {
       
    }];
    
}
-(void)initProData{
    _proDetailHeader = [[[NSBundle mainBundle]loadNibNamed:@"ProDetailHeader" owner:nil options:nil] firstObject];
  
    
    UIButton *addFarivateBtn = (UIButton *)[_proDetailHeader viewWithTag:9991];
    addFarivateBtn.userInteractionEnabled = YES;
    [addFarivateBtn addTarget:self action:@selector(addFAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *addComentsBtn = (UIButton *)[_proDetailHeader viewWithTag:9992];
    addComentsBtn.userInteractionEnabled = YES;
    [addComentsBtn addTarget:self action:@selector(addCommentsAction) forControlEvents:UIControlEventTouchUpInside];

  _tableView.tableHeaderView = _proDetailHeader;
  [_proDetailHeader.headerimgView sd_setImageWithURL:[NSURL URLWithString:_allData[@"photo_url"]] placeholderImage:nil];
    _proDetailHeader.nameLabel.text = _allData[@"name"];
    _proDetailHeader.startView.pentacleScore = [_allData[@"rating"] doubleValue];
    
    if([[self getMyLang] containsString:@"zh"]){
        
      _proDetailHeader.contactLabel.text =   [NSString stringWithFormat:@"联  系  人:%@ ",_allData[@"contact"]];
        
         _proDetailHeader.phoneLabel.text =   [NSString stringWithFormat:@"电       话:%@ ",_allData[@"phone"]];
    
         _proDetailHeader.addressLabel.text =   [NSString stringWithFormat:@"地       址:%@ ",_allData[@"address"]];
        
         _proDetailHeader.websiteLabel.text =   [NSString stringWithFormat:@"网       址:%@ ",_allData[@"website"]];
        
           _proDetailHeader.emailLabel.text =   [NSString stringWithFormat:@"邮       箱:%@ ",_allData[@"email"]];
        
         _proDetailHeader.profLabel.text =   [NSString stringWithFormat:@"专业资质:%@ ",_allData[@"license"]];
        
          _proDetailHeader.dtitleLabel.text =   [NSString stringWithFormat:@"服务类型:%@ ",_allData[@"business"]];
        
         _proDetailHeader.descLabel.text =   [NSString stringWithFormat:@"简介:%@ ",_allData[@"intro"]];
    
    }else{
    
        _proDetailHeader.contactLabel.text =   [NSString stringWithFormat:@"Contact:%@ ",_allData[@"contact"]];
        
        _proDetailHeader.phoneLabel.text =   [NSString stringWithFormat:@"Phone:%@ ",_allData[@"phone"]];
        
        _proDetailHeader.addressLabel.text =   [NSString stringWithFormat:@"Address:%@ ",_allData[@"address"]];
        
        _proDetailHeader.websiteLabel.text =   [NSString stringWithFormat:@"Website:%@ ",_allData[@"website"]];
        
        _proDetailHeader.emailLabel.text =   [NSString stringWithFormat:@"Email:%@ ",_allData[@"email"]];
        
        _proDetailHeader.profLabel.text =   [NSString stringWithFormat:@"License:%@ ",_allData[@"license"]];
        
        _proDetailHeader.dtitleLabel.text =   [NSString stringWithFormat:@"Type:%@ ",_allData[@"business"]];
        
        _proDetailHeader.descLabel.text =   [NSString stringWithFormat:@"Description:%@ ",_allData[@"intro"]];
    
    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95;
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datas count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    static NSString *identifierb=@"CommentsViewCell";
    CommentsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
    if (cell==nil) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"CommentsViewCell" owner:nil options:nil] firstObject];
    }
    NSDictionary *obj = [_datas objectAtIndex:row];
    [cell setData:obj];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


@end
