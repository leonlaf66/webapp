//
//  BSTableViewController.m
//  house_usa
//
//  Created by 林 建军 on 13/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BSTableViewController.h"

@interface BSTableViewController (){
    UIView *_bgView;
    
}

@end

@implementation BSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.navigationController){
        _myNavBar = (MyNavigationBar *)self.navigationController.navigationBar;
    }
    
    NSDictionary *navTitleArr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIColor whiteColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = navTitleArr;
    self.navigationController.navigationBar.barTintColor = GlobalTintColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"keyboardWillShow" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"keyboardWillHide" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _lang = [self getMyLocal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat height = keyboardFrame.origin.y;
    
    //CGFloat textField_maxY = (_currentTF.tag + 1) * 50;
    
    // CGFloat space = - self.tableView.contentOffset.y + textField_maxY;
    CGFloat space = 44;
    
    CGFloat transformY = height - space;
    
    if (transformY < 0) {
        
        CGRect frame = self.view.frame;
        
        frame.origin.y = transformY ;
        
        self.view.frame = frame;
        
    }
    
}
- (void)keyboardWillHide:(NSNotification *)info
{
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = 0;
    
    self.view.frame = frame;
}

-(void)setLeftBar{
    
    UIButton *btn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = left;
    
}

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)showLoading:(NSString *)msg{
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((ScreenWidth - 60) /2, (ScreenHight - 60) /2, 60, 60)];
    
    indicator.color = GlobalTintColor;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHight)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.4;
    
    [_bgView addSubview:indicator];
    
    [indicator startAnimating];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
}

-(void)hideLoading{
    
    [_bgView removeFromSuperview];
    
    
}


-(void)showMsg:(NSString *)msg{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:msg];
    
}

@end
