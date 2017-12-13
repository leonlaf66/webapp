//
//  HouseFilterViewCell.h
//  house_usa
//
//  Created by 林 建军 on 29/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseFilterViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *titleLabel;

@property(nonatomic,strong)NSDictionary *data;
@end
