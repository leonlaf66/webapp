//
//  BSViewController.h
//  decoration
//
//  Created by 林 建军 on 04/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKAlertCenter.h"
#import "MyNavigationBar.h"
@interface BSViewController : UIViewController{

    MyNavigationBar *_myNavBar;
}
@property(nonatomic,strong)  NSDictionary *lang;
@property(nonatomic,weak) IBOutlet UILabel *ctitleLabel;
-(void)showLoading:(NSString *)msg;

-(void)hideLoading;

-(void)showMsg:(NSString *)msg;
-(void)setLeftBar;
-(void)goBack;
@end
