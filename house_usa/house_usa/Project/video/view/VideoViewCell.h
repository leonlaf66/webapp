//
//  VideoViewCell.h
//  house_usa
//
//  Created by 林 建军 on 05/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface VideoViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,strong) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UIView *pView;
@property (nonatomic,strong)NSURL *url;





@end
