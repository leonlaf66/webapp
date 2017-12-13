//
//  TypeBtn.h
//  house_usa
//
//  Created by 林 建军 on 12/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TypeBackAction)(BOOL first);


@interface TypeBtn : UIView
@property(nonatomic,strong) NSDictionary *data;
@property(nonatomic,strong) UIButton *nameLabel;
 @property(nonatomic,strong)  UIButton *checkBtn;
 @property(nonatomic)  BOOL isAll;
@property(nonatomic,strong) TypeBackAction backAction;
@end
