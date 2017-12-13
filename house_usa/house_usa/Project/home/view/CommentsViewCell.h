//
//  CommentsViewCell.h
//  house_usa
//
//  Created by 林 建军 on 28/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiPentacleView.h"

@interface CommentsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet MultiPentacleView *startView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *pView;

@property(nonatomic,strong)NSDictionary *data;

@end
