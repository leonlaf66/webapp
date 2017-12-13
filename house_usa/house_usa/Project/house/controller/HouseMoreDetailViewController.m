//
//  HouseMoreDetailViewController.m
//  house_usa
//
//  Created by 林 建军 on 28/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HouseMoreDetailViewController.h"

@interface HouseMoreDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
  
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HouseMoreDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
   

}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     self.ctitleLabel.text = self.lang[@"moreInformation"];
    self.navigationController.navigationBarHidden = YES;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [_datas count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;

    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
   NSDictionary *ds =   [_datas objectAtIndex:section];
    
    return [[ds[@"items"] allKeys] count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    static NSString *identifier=@"HouseMoreInforViewCell";
    HouseMoreInforViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        // cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell= [[[NSBundle mainBundle]loadNibNamed:@"HouseMoreInforViewCell" owner:nil options:nil] firstObject];
    }
     NSDictionary *ds =   [_datas objectAtIndex:indexPath.section];
     NSArray *data = [ds[@"items"] allKeys];
     NSString *key = [data objectAtIndex:row];
    
    NSDictionary *o = ds[@"items"][key];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@:",o[@"title"]];
    
    cell.valueLabel.text = [NSString stringWithFormat:@"%@",o[@"value"]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;

    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UILabel *title= [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 30)];
    title.font = [UIFont systemFontOfSize:14];
  NSDictionary *headata =   [_datas objectAtIndex:section];
    title.text = headata[@"title"];
    vh.backgroundColor = [UIColor colorWithString:@"#f7f7f7"];
    [vh addSubview:title];
    
    return vh;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
        UIView *vh = [[UIView alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth - 8, 1)];
        vh.backgroundColor = [UIColor colorWithString:@"#dedede"];
        return vh;
        

    
}


@end
