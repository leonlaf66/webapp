//
//  SubwayViewCell.m
//  house_usa
//
//  Created by 林 建军 on 30/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "SubwayViewCell.h"

@implementation SubwayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(NSDictionary *)data{
    _data = data;

}
@end