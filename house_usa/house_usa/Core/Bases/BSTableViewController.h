//
//  BSTableViewController.h
//  house_usa
//
//  Created by 林 建军 on 13/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
@interface BSTableViewController : UITableViewController{
    
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
