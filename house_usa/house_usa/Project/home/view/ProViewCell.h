//
//  ProViewCell.h
//  house_usa
//
//  Created by 林 建军 on 27/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewMultiPentacleView.h"


@interface ProViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet NewMultiPentacleView *startView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (strong, nonatomic)  NSDictionary *data;
@end
