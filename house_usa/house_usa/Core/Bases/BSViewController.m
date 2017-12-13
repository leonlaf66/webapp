//
//  BSViewController.m
//  decoration
//
//  Created by 林 建军 on 04/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BSViewController.h"
#import "UIColor+XTExtension.h"
#import "DaoDefines.h"
#import "Precompile.h"
@interface BSViewController (){
    UIView *_bgView;

}

@end

@implementation BSViewController

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
    
    [btn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = left;

}

-(void)goBack{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
