//
//  LoginViewController.m
//  house_usa
//
//  Created by 林 建军 on 21/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"
#import "HomeModel.h"
#import "UPDao+UserTime.h"
//微信SDK头文件
#import "WXApi.h"
#define Regex_Email         @"^[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]\\.[a-zA-Z][a-zA-Z\\.]*[a-zA-Z]$"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextInput;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextInput;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *aggLabel;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;

@end

@implementation LoginViewController
- (IBAction)regAction:(id)sender {
    
    RegViewController *controller = [[RegViewController alloc] initWithNibName:@"RegViewController" bundle:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (BOOL)isEmail:(NSString *)mail{
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_Email];
    return [pred evaluateWithObject:mail];
}

- (IBAction)loginAction:(id)sender {
    [self resg];
    
    NSString *emialMes = @"请输入正确的邮箱地址";
   
    NSString *pwdMes = @"请输入6-12位密码";
   
    
    if([[self getMyLang] containsString:@"en"]){
        
        emialMes = @"the email is invalid";
     
        pwdMes = @"the password is invalid";
      
        
    }
    
    
    
    if(![self isEmail:_emailTextInput.text]){
        [self showMsg:emialMes];
        return;
    }else  if([_pwdTextInput.text length] < 6||[_pwdTextInput.text length] > 12){
        [self showMsg:pwdMes];
        return;
    }
    
    
    [self showLoading:@""];
    [[UPDao sharedInstance] deleteUser];
    NSDictionary *params = @{@"username":_emailTextInput.text,@"password":_pwdTextInput.text};
    [[HomeModel sharedInstance] login:params success:^(id operation) {
        [self hideLoading];
        if([operation[@"code"] integerValue] == 200){
           [[UPDao sharedInstance] deleteUser];
            UserTime *user = [[UserTime alloc] init];
            user.token = operation[@"data"][@"access_token"];
            user.email = _emailTextInput.text;
            user.ID = operation[@"data"][@"user_id"];
            user.name = _emailTextInput.text;;
            [[UPDao sharedInstance] createUser:user];
            
            
            if([[self getMyLang] containsString:@"zh"]){
                
                
                [self showMsg:@"登录成功"];
                
            }else{
                
               [self showMsg:@"Login in successfully"];
                
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [self showMsg:operation[@"message"]];

        
        }
        
        
    } failure:^(NSError *error) {
          [self hideLoading];
    }];
    

    
}
- (IBAction)wxLogin:(id)sender {
    
    SendAuthReq* req = [[SendAuthReq alloc ] init  ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
    
}
- (IBAction)emailResg:(id)sender {
    [_emailTextInput resignFirstResponder];
    [_pwdTextInput resignFirstResponder];
    
}
- (IBAction)pwdResg:(id)sender {
    [_emailTextInput resignFirstResponder];
    [_pwdTextInput resignFirstResponder];
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
    [_emailTextInput resignFirstResponder];
    [_pwdTextInput resignFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.ctitleLabel.text = self.lang[@"loginin"];
    
    if([[self getMyLang] containsString:@"zh"]){
    
        _titleLabel.text = @"账号密码登录";
        _emailTextInput.placeholder = @"请输入邮箱";
        _pwdTextInput.placeholder = @"请输入密码";
        _thirdLabel.text = @"社交账号直接登录";
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            [_regBtn setTitle:@"注册" forState:UIControlStateNormal];
        _aggLabel.text = @"注册/登录代表接手米乐居使用条款";
    }else{
    
        _titleLabel.text = @"Account and password ";
        _emailTextInput.placeholder = @"Enter the email";
        _pwdTextInput.placeholder = @"Enter the password";
        _thirdLabel.text = @"Others";
        [_loginBtn setTitle:@"LOGIN IN" forState:UIControlStateNormal];
        
        _aggLabel.text = @"By signing in you agreed to the USLEJU";
         [_regBtn setTitle:@"Need an Account?" forState:UIControlStateNormal];
    }
}

- (IBAction)needAccount:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)loginWXAction:(NSString *)openid access:(NSString *)accessToken{
    [self resg];
    
    
    
    [self showLoading:@""];
    [[UPDao sharedInstance] deleteUser];
    NSDictionary *params = @{@"open_id":openid};
    [[HomeModel sharedInstance] loginSer:params success:^(id operation) {
        [self hideLoading];
        if([operation[@"code"] integerValue] == 200){
              NSString *token = operation[@"data"][@"access_token"];
            
            [self wxUserINfor:openid access:accessToken myaccess:token];
            
        }else{
            [self showMsg:operation[@"message"]];
            
            
        }
        
        
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
    
    
}

- (void)getWxWXAction:(NSString *)code{
    
    NSString *url =  [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAppKey,kWXAppSecret,code];
    
    
    [[HomeModel sharedInstance] wxLogin:url success:^(id operation) {
        
        NSString *openid = operation[@"openid"];
        
        [self loginWXAction:openid access:operation[@"access_token"]];
        
    } failure:^(NSError *error) {
        
    }];


}


- (void)wxUserINfor:(NSString *)openId access:(NSString *)accessToken myaccess:(NSString *)myToken{
    
    NSString *url =  [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    
    [[HomeModel sharedInstance] wxUserINfor:url success:^(id operation) {
        
        [[UPDao sharedInstance] deleteUser];
        UserTime *user = [[UserTime alloc] init];
        user.token = myToken;
        user.email = operation[@"nickname"];
        user.ID = @"wx_users";;
        user.name = operation[@"headimgurl"];
        [[UPDao sharedInstance] createUser:user];
        
        
        if([[self getMyLang] containsString:@"zh"]){
            
            
            [self showMsg:@"登录成功"];
            
        }else{
            
            [self showMsg:@"Login in successfully"];
            
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

@end
