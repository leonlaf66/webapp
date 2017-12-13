//
//  ProCategoryView.h
//  house_usa
//
//  Created by 林 建军 on 27/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProCategoryView : UIView
@property(nonatomic,strong)NSDictionary *data;

@property(nonatomic,strong)UIImageView *titleImage;

@property(nonatomic,strong) UILabel *titleLabel;
-(instancetype)initWithFrame:(CGRect)frame setData:(NSDictionary *)data;
@end
