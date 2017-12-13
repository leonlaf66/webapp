//
//  ProServiceViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "ProServiceViewController.h"
#import "HomeBusinessCell.h"
#import "ProServiceFilterViewController.h"
#import "HomeModel.h"
#import "MJRefresh.h"
#import "ProViewCell.h"
#import "ProCategoryView.h"
#import "ProHeaderView.h"
#import "ProServiceDetailViewController.h"
@interface ProServiceViewController ()<UICollectionViewDelegate,UICollectionViewDelegate>{
    BOOL reloading;
    NSInteger offset;
    NSInteger limit;
}
@property(nonatomic,strong)IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)  NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@end

@implementation ProServiceViewController
- (IBAction)openOrCloseAction:(id)sender {
    
    
    _closeBtn.selected = !_closeBtn.selected;
    
    [self changeBtn];
}
-(void)changeBtn{
    if(_closeBtn.selected){
        _headerHeight.constant = ScreenHight - 64;
        
    }else{
        _headerHeight.constant = 130;
    }
    


}

-(void)setCurrentCategory:(NSDictionary *)currentCategory{
    _currentCategory = currentCategory;

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    limit = 15;
    offset = 1;
    UINib *nib  = [UINib nibWithNibName:@"ProViewCell" bundle: [NSBundle mainBundle]];
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"ProViewCell"];
    
    
     UINib *hnib  = [UINib nibWithNibName:@"ProHeaderView" bundle: [NSBundle mainBundle]];
    
    [_collectionView registerNib:hnib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProHeaderView"];
    
    [self setupRefreshHeaderView];
    _datas = [NSMutableArray array];
    [self loadType];
   
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
     self.ctitleLabel.text = self.lang[@"proServiceTitle"];
    
    if([[self getMyLang] containsString:@"zh"]){
     _typeTitleLabel.text = @"服务类型";
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
    }else{
      _typeTitleLabel.text = @"TYPES";
         [_allBtn setTitle:@"ALL" forState:UIControlStateNormal];
    }
   
}



- (void)setupRefreshHeaderView{
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offset = 1;
        [self loadData];
    }];
    
    self.collectionView.footer = [MJRefreshAutoGifFooter  footerWithRefreshingBlock:^{
        [self loadData];
        
    }];
    
    [self.collectionView.header beginRefreshing];
    
}

-(void)loadType{

    NSDictionary *params = @{};
    [[HomeModel sharedInstance] findYellowPageTypeList:params success:^(id operation) {
        
        if([operation[@"code"] integerValue] == 200){
           
            [self initCategory:operation[@"data"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];


}
-(void)initCategory:(NSArray *)categorys{
    
    NSInteger i = 0;
    CGFloat myY =  41;
    CGFloat width =  ScreenWidth / 4;
    CGFloat height =  90;
    for (NSDictionary *obj in categorys) {
        
        ProCategoryView *item = [[ProCategoryView alloc] initWithFrame:CGRectMake(width*i, myY, width, height) setData:obj];
        item.userInteractionEnabled = YES;
        UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
        [atap addTarget:self action:@selector(tapped:)];
        [item addGestureRecognizer:atap];
        [_categoryView addSubview:item];
        i++;
        if(i%4 == 0){
            i = 0;
            myY = myY + height;
        }
    }

}

- (void)tapped:(UITapGestureRecognizer *)t {
    ProCategoryView *item =  (ProCategoryView *)t.view;
    
    _currentCategory = item.data;
    _closeBtn.selected = NO;
    _headerHeight.constant = 130;

    [self.collectionView.header beginRefreshing];

}
-(void)loadData{
    NSDictionary *params = nil;
    //type_id
    if(_currentCategory != nil){
     params = @{@"page_size":@(limit),@"page":@(offset),@"type_id":_currentCategory[@"id"]};
    
    }else{
     params = @{@"page_size":@(limit),@"page":@(offset)};
    }
   
    
    
    [[HomeModel sharedInstance] findYellowPageList:params success:^(id operation) {
        
        if([operation[@"code"] integerValue] == 200){
            
            NSArray *objs = operation[@"data"][@"items"];
            
            if(offset == 1){
                [self.datas  removeAllObjects];
                [self.collectionView reloadData];
            }
            
            [self.datas addObjectsFromArray:objs];
            
            [self.collectionView reloadData];
            [self.collectionView.header endRefreshing];
            [self.collectionView.footer endRefreshing];
            offset++;

        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}





#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.datas count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ProViewCell";
    NSInteger row = [indexPath row];
    
   
    ProViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"ProViewCell" owner:nil options:nil] firstObject];
    }
    
    [cell setData:[_datas objectAtIndex:row]];
    
    return cell;

}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((collectionView.frame.size.width - 20)/2, 180);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    ProServiceDetailViewController *controller = [[ProServiceDetailViewController alloc] initWithNibName:@"ProServiceDetailViewController" bundle:nil];
    
    NSDictionary *data = [self.datas objectAtIndex:indexPath.row];
    
    controller.data = data;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 40);
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"ProHeaderView";
    //从缓存中获取 Headercell
    ProHeaderView *cell = (ProHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(_titleLabel){
        [_titleLabel removeFromSuperview];
    
    }
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 120, 15)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithString:@"#333333"];
    
    if(_currentCategory){
       _titleLabel.text = _currentCategory[@"name"];
    
    }else{
        if([[self getMyLang] containsString:@"zh"]){
         _titleLabel.text = @"特别推荐";
        }else{
         _titleLabel.text = @"Recommended";
        }
    
    }
    
    [cell addSubview:_titleLabel];

    
    return cell;
}





@end
