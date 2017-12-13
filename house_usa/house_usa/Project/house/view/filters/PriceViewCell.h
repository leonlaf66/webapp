//
//  PriceViewCell.h
//  house_usa
//
//  Created by 林 建军 on 29/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterBaseViewCell.h"
typedef void (^PriceBackAction)(NSDictionary *data);
@interface PriceViewCell : FilterBaseViewCell
@property(nonatomic,weak)IBOutlet UITextField *startPrice;
@property(nonatomic,weak)IBOutlet UITextField *endPrice;
@property(nonatomic,strong) PriceBackAction priceBack;
@property(nonatomic,weak)IBOutlet UILabel *beweenLabel;
@end
