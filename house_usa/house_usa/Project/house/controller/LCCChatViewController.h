//
//  LCCChatViewController.h
//  MobiLiveChat
//
//  Created by Krzysztof Górski on 12/11/13.
//  Copyright (c) 2013 Krzysztof Górski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSViewController.h"

@interface LCCChatViewController : BSViewController<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *chatView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@property (nonatomic) BOOL isHome;

- (id)initWithChatUrl:(NSString*)url;

@end
