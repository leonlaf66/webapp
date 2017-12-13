//
//  PriceFilterView.h
//  house_usa
//
//  Created by 林 建军 on 13/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^PriceSearchBackAction)(NSArray *datas);
@interface PriceFilterView : UIView
@property(nonatomic,strong)  UIButton *surenBtn;
@property(nonatomic,strong) PriceSearchBackAction backAction;

@property(nonatomic,strong)  NSDictionary *selectedData;

@property(nonatomic)  NSInteger type;

@property(nonatomic)  NSInteger ptype;


@property(nonatomic,strong)  UITextField *startField;
@property(nonatomic,strong)  UITextField *endField;

-(void)loadLang;

-(instancetype)initWithFrame:(CGRect)frame setType:(NSInteger)type;

-(void)setDatas:(NSDictionary *)data;

@end
