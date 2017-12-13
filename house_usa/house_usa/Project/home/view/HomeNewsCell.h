//
//  HomeNewsCell.h
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNewsCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *data;

@property(nonatomic,weak)IBOutlet  UIImageView *headerImage;
@property(nonatomic,weak)IBOutlet  UILabel *titleLabel;
@property(nonatomic,weak)IBOutlet  UILabel *myLabel;
@end
