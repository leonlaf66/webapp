//
//  SettingViewController.m
//  house_usa
//
//  Created by 林 建军 on 22/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "SettingViewController.h"

#import "SettingViewCell.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL reloading;
    NSInteger offset;
    NSInteger limit;
}
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)  NSArray *datas;
@property (weak, nonatomic) IBOutlet UIView *inputView;


@end

@implementation SettingViewController

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    offset = 0;
    limit = 15;
    _datas = @[@{},@{}];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if([[self getMyLang] containsString:@"zh"]){
       
        self.ctitleLabel.text = @"设置";

    }else{
        self.ctitleLabel.text = @"Setting";

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    static NSString *identifierb=@"SettingViewCell";
    SettingViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
    if (cell==nil) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"SettingViewCell" owner:nil options:nil] firstObject];
    }
    
    if([[self getMyLang] containsString:@"zh"]){
        if(row == 0){
           cell.titleLabel.text = @"内存清理";
          cell.headImageView.image = [UIImage imageNamed:@"clean"];
          
        }else if(row == 1){
        
          cell.titleLabel.text = @"退出登录";
            cell.headImageView.image = [UIImage imageNamed:@"logout"];
        }
    }else{
        
        if(row == 0){
            cell.titleLabel.text = @"Clean memory";
              cell.headImageView.image = [UIImage imageNamed:@"clean"];
        }else if(row == 1){
            
            cell.titleLabel.text = @"LOG OUT";
            cell.headImageView.image = [UIImage imageNamed:@"logout"];
        }
    
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if(indexPath.row == 0){
        if([[self getMyLang] containsString:@"zh"]){
            
            [self showMsg:@"清理完成"];
        }else{
              [self showMsg:@"Clean completed"];
            
        }

    
    }else {
    
        [[UPDao sharedInstance] deleteUser];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
