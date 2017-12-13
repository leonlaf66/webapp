//
//  HotAreaViewCell.h
//  house_usa
//
//  Created by 林 建军 on 08/09/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Key.h"
@interface HotAreaViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *ctitleLabel;
@property(nonatomic,strong) Key *data;
@end
