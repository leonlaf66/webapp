//
//  TypeFilterView.h
//  house_usa
//
//  Created by 林 建军 on 12/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeBtn.h"


typedef void (^TypeSearchBackAction)(NSArray *datas);
@interface TypeFilterView : UIView
@property(nonatomic,strong)  UIButton *surenBtn;
@property(nonatomic,strong) TypeSearchBackAction backAction;

@property(nonatomic,strong)  NSMutableArray *selectedDatas;

@property(nonatomic)  NSInteger type;
-(void)loadLang;

-(instancetype)initWithFrame:(CGRect)frame setType:(NSInteger)type;

-(void)setTypes:(NSArray *)types;
@end




