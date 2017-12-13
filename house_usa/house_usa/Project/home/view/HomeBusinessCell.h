//
//  HomeBusinessCell.h
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiPentacleView.h"

typedef void (^BusinessGetBackAction)(NSInteger id);


@interface HomeBusinessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MultiPentacleView *startView;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (strong, nonatomic)  NSArray *data;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lianxiLabel;
@property (strong, nonatomic)  UIView *lastView;


@property (strong, nonatomic)  BusinessGetBackAction getBack;

@end
