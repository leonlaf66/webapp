//
//  BarcodeAndQRcode.h
//  BarcodeAndQRcode
//
//  Created by 林建军 on 15/11/13.
//  Copyright (c) 2015年 林建军. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BarcodeAndQRcode : NSObject
+(UIImage *) getImage:(NSInteger)imgtype setData:(NSString *)datas setWidth:(int)width setHeight:(int)height;
@end

