//
//  HomeViewCell.h
//  house_usa
//
//  Created by 林 建军 on 04/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,strong) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UIView *pView;

@end
