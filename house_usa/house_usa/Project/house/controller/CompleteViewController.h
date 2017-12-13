//
//  CompleteViewController.h
//  house_usa
//
//  Created by 林 建军 on 13/09/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BSViewController.h"
#import "Key.h"
typedef void (^KeySearchBackAction)(Key *key);
@interface CompleteViewController : BSViewController
@property(nonatomic,strong) KeySearchBackAction backAction;
-(void)reloadDatas:(NSArray *)datas;
@end

