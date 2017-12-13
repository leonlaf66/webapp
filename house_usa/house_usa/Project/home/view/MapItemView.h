//
//  MapItemView.h
//  house_usa
//
//  Created by 林 建军 on 21/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FateModel.h"
@interface MapItemView : UIView
@property(nonatomic)BOOL selected;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)FateModel *data;
@end
