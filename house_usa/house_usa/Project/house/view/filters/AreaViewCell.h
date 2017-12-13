//
//  AreaViewCell.h
//  house_usa
//
//  Created by 林 建军 on 29/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterBaseViewCell.h"
typedef void (^AreaBackAction)(NSDictionary *data);
@interface AreaViewCell : FilterBaseViewCell
@property(nonatomic,weak)IBOutlet UITextField *startArea;
@property(nonatomic,weak)IBOutlet UITextField *endArea;
@property(nonatomic,strong) AreaBackAction areaBack;
@property(nonatomic,weak)IBOutlet UILabel *beweenLabel;
@end

