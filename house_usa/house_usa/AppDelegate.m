//
//  AppDelegate.m
//  house_usa
//
//  Created by 林 建军 on 26/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "AppDelegate.h"
#import "BMapUtil.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "UPDao+Key.h"
#import "HomeModel.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [BMapUtil sharedInstance];
    [self initShareData];
    
   // [self loadKeys];
    
  // [self addVersion];
   

    return YES;
}

-(void)addVersion{
    
    
    [[HomeModel sharedInstance] addCfg:@{@"config_id":@"iosVersion",
                                         @"config_content":@"5.8"} success:^(id operation) {
        
       
        
    } failure:^(NSError *error) {
        
    }];

}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initShareData{
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeTencentWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeFacebook),
                            @(SSDKPlatformTypeTwitter),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:kWeiboAppKey
                                                appSecret:kWeiboAppSecret
                                              redirectUri:kWeiboredirectUri
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeTencentWeibo:
                      //设置腾讯微博应用信息
                      [appInfo SSDKSetupTencentWeiboByAppKey:kTencentWeiboAppKey
                                                   appSecret:kTencentWeiboAppSecret
                                                 redirectUri:kTencentWeibodirectUri];
                      break;
                  case SSDKPlatformTypeWechat:
                      //设置微信应用信息
                      [appInfo SSDKSetupWeChatByAppId:kWXAppKey
                                            appSecret:kWXAppSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:kQQAppKey
                                           appKey:kQQAppSecret
                                         authType:SSDKAuthTypeSSO];
                      break;
                  case SSDKPlatformTypeFacebook:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权SSDKPlatformTypeFacebook
                      [appInfo SSDKSetupFacebookByAppKey:@"298277300517640" appSecret:@"30a55b5bd9df1ee361f5d4a8a9db3761" authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
    
    
}


#pragma -mark ApplicationThirdSerice Delegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
     return [WXApi handleOpenURL:url delegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
     return [WXApi handleOpenURL:url delegate:self];
    
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
     return [WXApi handleOpenURL:url delegate:self];
    
}


-(void)onResp:(BaseResp*)resp
{
    
    if([resp isKindOfClass:SendAuthResp.class]){
    
        SendAuthResp *rs = (SendAuthResp *)resp;
        
        NSString *code = rs.code;
    
        [_loginController getWxWXAction:code];
    
    }
    
   

    
}

@end
