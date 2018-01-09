//
//  NewsDetailsViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import "HomeModel.h"
#import "LXActivity.h"
@interface NewsDetailsViewController ()<LXActivityDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *sBtn;

@end

@implementation NewsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.ctitleLabel.text = self.lang[@"nearbyTitle"];
    // Do any additional setup after loading the view from its nib.
    self.ctitleLabel.text = _data[@"title"];
    
    if([WXApi isWXAppInstalled]){
        
        
    }else{
        _sBtn.hidden = YES;
    }
}
- (IBAction)shareActions:(id)sender {
    
    LXActivity *share = [[LXActivity alloc] initWithTitle:@"share" delegate:self cancelButtonTitle:@"Cancel" ShareButtonTitles:nil withShareButtonImagesName:nil];
   // artical
    
  NSMutableDictionary*dic =   [[NSMutableDictionary alloc] initWithDictionary:_data];
    [dic setObject:@"artical" forKey:@"atype"];
    
    [share share:dic inView:self.view success:^{
        if([[self getMyLang] containsString:@"zh"]){
            [self showMsg:@"分享成功"];
        }else{
            [self showMsg:@"Share successfully"];
        }
        // [self showMsg:self.lang[@"shareSuccess"]];
    } failure:^(NSError *error) {
        // [self showMsg:self.lang[@"shareFailed"]];
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setData:(NSDictionary *)data{
    _data = data;
}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [self loadData];
}
-(void)loadData{
    
    [self showLoading:@""];
    
   

    NSDictionary *params = @{@"id":_data[@"id"]};
    [[HomeModel sharedInstance] findNewsDetail:params success:^(id operation) {
        [self hideLoading];
        //created_at
        if([operation[@"code"] integerValue] == 200){
             NSString *html = [NSString stringWithFormat:@"<html><head><meta charset='UTF-8'><title></title><meta http-equiv='Access-Control-Allow-Origin' content='*'><meta http-equiv='content-security-policy'><meta name='viewport' content='width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no'></head><body><h2>%@</h2><br/><center><img src='%@' style='width:%fpx'><br/></center>%@&nbsp;&nbsp;米乐居",_data[@"title"],_data[@"image"],(ScreenWidth - 100),operation[@"data"][@"created_at"]];
            
            
            
            NSString *htmla = operation[@"data"][@"content"];
            
            
             NSString *htmewn =   [htmla stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img  style='width:%fpx'",(ScreenWidth - 100)]];
            
            
               NSString *newhtml = [NSString stringWithFormat:@"%@<br/>%@</body></html>",html,htmewn];
            [_webView loadHTMLString:newhtml baseURL:nil];
        }
        
    } failure:^(NSError *error) {
         [self hideLoading];
    }];
    


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
