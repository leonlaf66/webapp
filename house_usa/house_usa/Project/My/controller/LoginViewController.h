//
//  LoginViewController.h
//  house_usa
//
//  Created by 林 建军 on 21/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BSViewController.h"

@interface LoginViewController : BSViewController


- (void)getWxWXAction:(NSString *)code;
- (void)loginWXAction:(NSString *)openid access:(NSString *)accessToken;
@end
