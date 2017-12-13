//
//  BedsFilterView.h
//  house_usa
//
//  Created by 林 建军 on 08/09/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef void (^BedsSearchBackAction)(NSDictionary *data);
@interface BedsFilterView : UIView
@property(nonatomic,strong)  UIButton *surenBtn;
@property(nonatomic,strong) BedsSearchBackAction backAction;

@property(nonatomic,strong)  NSDictionary *data;

-(void)loadLang;
-(void)setData:(NSDictionary *)data;

@end
