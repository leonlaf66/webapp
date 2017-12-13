//
//  HomeViewController.h
//  house_usa
//
//  Created by 林 建军 on 26/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BSViewController.h"
typedef void (^SetLangAction)();
@interface HomeViewController : BSViewController

@property(nonatomic,strong) SetLangAction setLangAction;
@end
