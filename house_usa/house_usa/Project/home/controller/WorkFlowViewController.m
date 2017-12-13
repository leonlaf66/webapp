//
//  WorkFlowViewController.m
//  house_usa
//
//  Created by 林 建军 on 28/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "WorkFlowViewController.h"

@interface WorkFlowViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WorkFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, 1800)];
    
    UIImageView *img =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1800)];
    
    img.image = [UIImage imageNamed:@"myflow"];
    
    [_scrollView addSubview:img];
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
    
      self.ctitleLabel.text = self.lang[@"workFlow"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
