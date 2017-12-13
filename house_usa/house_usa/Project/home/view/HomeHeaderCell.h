//
//  HomeHeaderCell.h
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (weak, nonatomic) IBOutlet UILabel *nearbyLabel;

@property (weak, nonatomic) IBOutlet UILabel *newsLabel;

@property (weak, nonatomic) IBOutlet UILabel *servicesLabel;

@property (weak, nonatomic) IBOutlet UILabel *flowLabel;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@end
