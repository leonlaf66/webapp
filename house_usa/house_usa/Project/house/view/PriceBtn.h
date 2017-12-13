//
//  TypeBtn.h
//  house_usa
//
//  Created by 林 建军 on 12/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PriceBtn;

typedef void (^PriceBackAction)(PriceBtn* btn);


@interface PriceBtn : UIView
@property(nonatomic,strong) NSDictionary *data;
@property(nonatomic,strong) UIButton *nameLabel;
@property(nonatomic)  BOOL isAll;
@property(nonatomic,strong) PriceBackAction backAction;
@end
