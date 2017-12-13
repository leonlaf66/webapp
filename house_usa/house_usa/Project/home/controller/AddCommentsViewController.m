//
//  AddCommentsViewController.m
//  house_usa
//
//  Created by 林 建军 on 29/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "AddCommentsViewController.h"
#import "HomeModel.h"

#import "HCSStarRatingView.h"
@interface AddCommentsViewController ()
@property (weak, nonatomic) IBOutlet HCSStarRatingView *startView;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation AddCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _startView.maximumValue = 5;
    _startView.minimumValue = 0;
    _startView.value = 5.0f;
    _startView.tintColor = GlobalRedColor;
    _subBtn.layer.cornerRadius = 3;
    
    UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
    [atap addTarget:self action:@selector(resg)];
    [self.view addGestureRecognizer:atap];
    // Do any additional setup after loading the view from its nib.
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
    
   
    
    if([[self getMyLang] containsString:@"zh"]){
         self.ctitleLabel.text = @"评论";
          _inputField.placeholder = @"评论";
         [_subBtn setTitle:@"提交" forState:UIControlStateNormal];
    }else{
        self.ctitleLabel.text = @"Comment";
        _inputField.placeholder = @"Comment";
          [_subBtn setTitle:@"OK" forState:UIControlStateNormal];
    }
    
   
    
}

-(void)resg{
   [_inputField resignFirstResponder];
    //[_pwdTextInput resignFirstResponder];
    
}

- (IBAction)addAction:(id)sender {
    [self resg];
    
    NSString *emialMes = @"评论内容至少为10位";
    
   
    
    
    if([[self getMyLang] containsString:@"en"]){
        
        emialMes = @"Comments should contain at least 10 characters";
        
    
        
        
    }
    
    
    
  if([_inputField.text length] < 10){
        [self showMsg:emialMes];
        return;
   }
    
    
    [self showLoading:@""];
   
    NSDictionary *params = @{@"type":@"yellowpage",
                             @"id":_data[@"id"],
                             @"rating":@(_startView.value),
                             @"content":_inputField.text};
    [[HomeModel sharedInstance] addComments:params success:^(id operation) {
        [self hideLoading];
        if([operation[@"code"] integerValue] == 200){
           
            
            
            if([[self getMyLang] containsString:@"zh"]){
                
                
                [self showMsg:@"评论成功"];
                
            }else{
                
                [self showMsg:@"Comments successfully"];
                
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
    
    
    
}

- (IBAction)emailResg:(id)sender {
   [_inputField resignFirstResponder];
   // [_pwdTextInput resignFirstResponder];
    
}



-(void)setData:(NSDictionary *)data{
    _data = data;
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
