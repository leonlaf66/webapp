//
//  MainViewController.m
//  house_usa
//
//  Created by 林 建军 on 26/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "PicViewController.h"
#import "VideoViewController.h"
#import "HouseListViewController.h"
#import "LCCChatViewController.h"
@interface MainViewController (){
    UITabBarItem*  _homeInfoItem;
    UITabBarItem*  _picInfoItem;
    UITabBarItem*  _videoInfoItem ;
    UITabBarItem*  _myInfoItem;
}
@property (nonatomic, strong) NSString *chatURL;
@end

@implementation MainViewController


#pragma mark -
#pragma mark Tasks

- (void)requestUrl
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@LC_URL];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    NSError *jsonError;
                    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingAllowFragments
                                                                           error:&jsonError];
                    
                    if ([JSON isKindOfClass:[NSDictionary class]] && [JSON valueForKey:@"chat_url"] != nil) {
                        self.chatURL = [self prepareUrl:JSON[@"chat_url"]];
                    } else if (jsonError) {
                        NSLog(@"%@", jsonError);
                    }
                } else {
                    NSLog(@"%@", error);
                }
            }] resume];
}

#pragma mark -
#pragma mark Helper functions

- (NSString *)prepareUrl:(NSString *)url
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"https://%@", url];
    
    [string replaceOccurrencesOfString:@"{%license%}"
                            withString:@LC_LICENSE
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    
    [string replaceOccurrencesOfString:@"{%group%}"
                            withString:@LC_CHAT_GROUP
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    
    return string;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *lang = [self getMyLocal];
    [self requestUrl];
    
    
    [UITabBar appearance].tintColor = GlobalTintColor;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11.5]};
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:(UIControlStateNormal)];
    //
    
    
    
    NSDictionary *attributess = @{NSFontAttributeName:[UIFont systemFontOfSize:11.5],NSForegroundColorAttributeName:[UIColor colorWithString:@"#c8cbdd"]};
    
    [[UITabBarItem appearance] setTitleTextAttributes:attributess forState:(UIControlStateHighlighted)];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    // Do any additional setup after loading the view.
    
    UIStoryboard *HomeSB = [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
    
    HomeViewController *homeController = [HomeSB instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    MyUINavigationController *_homeNav = [[MyUINavigationController alloc] initWithRootViewController:homeController];
    
    homeController.setLangAction = ^(){
    
        [self setLangdata];
    
    };
    
       _homeInfoItem = [[UITabBarItem alloc]initWithTitle:lang[@"tab_home"]
                                                              image:[[UIImage imageNamed:@"sy_house_gray"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                                      selectedImage:[[UIImage imageNamed:@"sy_house_red"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    _homeNav.tabBarItem = _homeInfoItem;
    

    //////
    
    
    
    
    HouseListViewController *picController = [[HouseListViewController alloc] initWithNibName:@"HouseListViewController" bundle:nil];
    picController.hideBackBtn = YES;
    MyUINavigationController *_picNav = [[MyUINavigationController alloc] initWithRootViewController:picController];
    
    
    
    _picInfoItem = [[UITabBarItem alloc]initWithTitle:lang[@"tab_search"]
                                                                image:[[UIImage imageNamed:@"sy_ruanmeibi_gray"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                                        selectedImage:[[UIImage imageNamed:@"sy_ruanmeibi_red"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    _picNav.tabBarItem = _picInfoItem;

    
    
    
    
    ////////////////
   // UIStoryboard *videoSB = [UIStoryboard storyboardWithName:@"Video" bundle:[NSBundle mainBundle]];
   
    
 
    
    
   LCCChatViewController* videoController = [[LCCChatViewController alloc] initWithChatUrl:self.chatURL];
    videoController.isHome = YES;
    MyUINavigationController *_videoNav = [[MyUINavigationController alloc] initWithRootViewController:videoController];
    
   
    
   _videoInfoItem = [[UITabBarItem alloc]initWithTitle:lang[@"tab_service"]
                                                               image:[[UIImage imageNamed:@"sy_police_gray"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                                       selectedImage:[[UIImage imageNamed:@"sy_police_red"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    _videoNav.tabBarItem = _videoInfoItem;
    
    //////////////
    
    
    UIStoryboard *MYSB = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
    
    MyViewController *myController = [MYSB instantiateViewControllerWithIdentifier:@"MyViewController"];
    
     MyUINavigationController *_myNav = [[MyUINavigationController alloc] initWithRootViewController:myController];
    
   
    
      _myInfoItem = [[UITabBarItem alloc]initWithTitle:lang[@"tab_me"]
                                               image:[[UIImage imageNamed:@"sy_me_gray"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                       selectedImage:[[UIImage imageNamed:@"sy_me_red"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    _myNav.tabBarItem = _myInfoItem;

    
    
    self.viewControllers = @[_homeNav, _picNav,_videoNav,_myNav];
}
-(void)setLangdata{
    NSDictionary *lang = [self getMyLocal];
    [_myInfoItem setTitle:lang[@"tab_me"]];
    [_videoInfoItem setTitle:lang[@"tab_service"]];
     [_picInfoItem setTitle:lang[@"tab_search"]];
     [_homeInfoItem setTitle:lang[@"tab_home"]];
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

@end
