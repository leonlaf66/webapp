//
//  MyViewController.m
//  house_usa
//
//  Created by 林 建军 on 26/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "MyViewController.h"
#import "MyTableViewCell.h"
#import "FavoritesViewController.h"
#import "LoginViewController.h"
#import "SubscribeViewController.h"
#import "OrderViewController.h"
#import "ArticleViewController.h"
#import "SettingViewController.h"
#import "CommentsViewController.h"
#import "AboutViewController.h"
#import "UPDao+UserTime.h"
#import "AppDelegate.h"
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSArray *_datas;
}
@property (weak, nonatomic) IBOutlet UIButton *myHeaderImg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = @[];

   
   }
- (IBAction)goLogin:(id)sender {
    
    
    NSMutableArray *users =  [[UPDao sharedInstance] getUsers];
    
    if([users count] >0){
        
       
       
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   //_myNavBar.bgView.backgroundColor =  kHXColorHex(0x4995fe, 0);
   // _myNavBar.bgView.alpha = 0;
    self.navigationController.navigationBarHidden = YES;
    
   NSMutableArray *users =  [[UPDao sharedInstance] getUsers];
    
    if([users count] >0){
      
        
        UserTime *user = [users objectAtIndex:0];
        _myNameLabel.text = user.email;
        
        
        if([user.name length] > 20){
        
           
            
            
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *imgUrl = user.name;//;//[_data objectForKey:@"imgUrl"];
                
                
                NSData *nsd = [[NSData alloc]initWithContentsOfURL:[[NSURL alloc] initWithString:imgUrl]];
                UIImage *img =  [UIImage imageWithData:nsd];
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_myHeaderImg setImage:img forState:UIControlStateNormal];
                });
            });
            
        }
    
    }else{
        
         [_myHeaderImg setImage:[UIImage imageNamed:@"myheader"] forState:UIControlStateNormal];
        if([[self getMyLang] containsString:@"zh"]){
            
            
            _myNameLabel.text = @"未登录";
            
        }else{
            
            _myNameLabel.text = @"NO LOGIN";
            
            
        }
    }
    
    
    if([[self getMyLang] containsString:@"zh"]){
        
        _datas = @[@[@{@"img":@"shoucang",@"title":@"我的收藏"},
                    
                     @{@"img":@"yuyue",@"title":@"我的预约"}],@[@{@"img":@"shezhi",@"title":@"设置"}],
                   @[@{@"img":@"about",@"title":@"关于我们"}]];
        
    }else{
        
        _datas = @[@[@{@"img":@"shoucang",@"title":@"My favorites"},
                    
                     @{@"img":@"yuyue",@"title":@"My schedules"}],@[@{@"img":@"shezhi",@"title":@"Setting"}]
                   ,
                   @[@{@"img":@"about",@"title":@"About us"}]];
        
    }
    
    [_tableView reloadData];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = [_datas objectAtIndex:section];
    return items.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _datas.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSInteger section = [indexPath section];
      NSInteger row = [indexPath row];
    
    NSDictionary *data = [[_datas objectAtIndex:section] objectAtIndex:row];
    
    static NSString *identifierb=@"MyTableViewCell";
    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = data[@"title"];
    cell.myImageView.image = [UIImage imageNamed:data[@"img"]];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        NSMutableArray *users =  [[UPDao sharedInstance] getUsers];
        
        if([users count] >0){
            if(indexPath.row == 0){
                
                
                FavoritesViewController *fc = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
                
                [self.navigationController pushViewController:fc animated:YES];
                
            }else if(indexPath.row == 2){
                SubscribeViewController *sc = [[SubscribeViewController alloc] initWithNibName:@"SubscribeViewController" bundle:nil];
                [self.navigationController pushViewController:sc animated:YES];
                
            }else if(indexPath.row == 1){
                
                OrderViewController *oc = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
                
                [self.navigationController pushViewController:oc animated:YES];
            }
            
            
        }else{
            [self goLogina];
        
        }
    
       
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            SettingViewController *ac = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
            
            [self.navigationController pushViewController:ac animated:YES];
            
        }
        
        
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            AboutViewController *ac = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            
            [self.navigationController pushViewController:ac animated:YES];
            
        }
        
        
    }

}

@end
