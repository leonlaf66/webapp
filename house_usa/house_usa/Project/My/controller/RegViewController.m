//
//  RegViewController.m
//  house_usa
//
//  Created by 林 建军 on 21/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "RegViewController.h"
#import "HomeModel.h"

// 电子邮件
#define Regex_Email         @"^[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]\\.[a-zA-Z][a-zA-Z\\.]*[a-zA-Z]$"
@interface RegViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *nackNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfirmLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UILabel *aggLabel;

@end

@implementation RegViewController

- (IBAction)regAction:(id)sender {
    
    [self resg];
}

- (IBAction)loginAction:(id)sender {
    
     [self resg];
    
     NSString *emialMes = @"请输入正确的邮箱地址";
     NSString *nickMes = @"请输入昵称";
     NSString *pwdMes = @"请输入6-12位密码";
     NSString *pwdconMes = @"请输入6-12位密码确认";
     NSString *eqMes = @"密码和密码确认不同";
    
    if([[self getMyLang] containsString:@"en"]){
    
        emialMes = @"the email is invalid";
        nickMes = @"the nickname is blank";
        pwdMes = @"the password is invalid";
        pwdconMes = @"the password confirm is invalid";
        eqMes = @"the password don't equals password confirm";

    }
    
    
    
    if(![self isEmail:_emailLabel.text]){
        [self showMsg:emialMes];
        return;
    }else  if([_nackNameLabel.text length] == 0){
        [self showMsg:nickMes];
        return;
    }else  if([_pwdLabel.text length] < 6||[_pwdLabel.text length] > 12){
        [self showMsg:pwdMes];
        return;
    }else  if([_pwdConfirmLabel.text length] < 6||[_pwdConfirmLabel.text length] > 12){
        [self showMsg:pwdconMes];
        return;
    }else  if(![_pwdConfirmLabel.text isEqualToString:_pwdLabel.text]){
        [self showMsg:eqMes];
        return;
    }
    
    
     [self showLoading:@""];
    
   NSDictionary *params = @{@"username":_nackNameLabel.text,@"password":_pwdLabel.text,@"email":_emailLabel.text};
    [[HomeModel sharedInstance] registerAccount:params success:^(id operation) {
        [self hideLoading];
        if([operation[@"code"] integerValue] == 200){
            
            
            if([[self getMyLang] containsString:@"zh"]){
                
                
                [self showMsg:[NSString stringWithFormat:@"注册成功,请到邮箱%@确认后登录",_emailLabel.text]];
                
            }else{
                
                 [self showMsg:[NSString stringWithFormat:@"Create account successfully,please confirm %@,and than login ",_emailLabel.text]];
            
             
            }
            
             [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } failure:^(NSError *error) {
        [self hideLoading];
    }];

    
    
}

- (BOOL)isEmail:(NSString *)mail{
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_Email];
    return [pred evaluateWithObject:mail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _loginBtn.layer.cornerRadius = 3;
    
    UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
    [atap addTarget:self action:@selector(resg)];
    [self.view addGestureRecognizer:atap];
}
-(void)resg{
     [_emailLabel resignFirstResponder];
     [_nackNameLabel resignFirstResponder];
     [_pwdLabel resignFirstResponder];
     [_pwdConfirmLabel resignFirstResponder];
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if([[self getMyLang] containsString:@"zh"]){
      self.ctitleLabel.text = @"注册";
      _titleLabel.text = @"创建账号";
         _nackNameLabel.placeholder = @"请输入昵称";
         _emailLabel.placeholder = @"请输入邮箱";
         _pwdLabel.placeholder = @"请输入6-12位密码";
         _pwdConfirmLabel.placeholder = @"密码确认";
         [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
         _aggLabel.text = @"注册/登录代表接手米乐居使用条款";
    }else{
      self.ctitleLabel.text = @"Need an Account";
        
        _titleLabel.text = @"Create Account";
        _nackNameLabel.placeholder = @"Enter nickname";
        _emailLabel.placeholder = @"Enter email";
        _pwdLabel.placeholder = @"Enter password";
        _pwdConfirmLabel.placeholder = @"Password confirm";
         [_loginBtn setTitle:@"OK" forState:UIControlStateNormal];
        
          _aggLabel.text = @"By signing in you agreed to the USLEJU";
    }
  
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
