//
//  CompleteViewController.m
//  house_usa
//
//  Created by 林 建军 on 13/09/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "CompleteViewController.h"

#import "HotAreaViewCell.h"
@interface CompleteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * datas;
@end

@implementation CompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = @[];
    // Do any additional setup after loading the view from its nib.
}
-(void)reloadDatas:(NSArray *)datas{
    _datas = datas;
    [_tableView reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}







- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    static NSString *identifierb=@"HotAreaViewCell";
    HotAreaViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
    if (cell==nil) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"HotAreaViewCell" owner:nil options:nil] firstObject];
    }
    Key *data = [_datas objectAtIndex:row];
    [cell setData:data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HotAreaViewCell *cell=  [_tableView cellForRowAtIndexPath:indexPath];
    _backAction(cell.data);
}
-(void)setBackAction:(KeySearchBackAction)backAction{

    _backAction = backAction;
}

@end
