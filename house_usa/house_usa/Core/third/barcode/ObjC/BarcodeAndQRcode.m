//
//  BarcodeAndQRcode.m
//  BarcodeAndQRcode
//
//  Created by 林建军 on 15/11/13.
//  Copyright (c) 2015年 林建军. All rights reserved.
//
#import "ZXingObjC.h"
#import "BarcodeAndQRcode.h"

@implementation BarcodeAndQRcode
+(UIImage *) getImage:(NSInteger)imgtype setData:(NSString *)datas setWidth:(int)width setHeight:(int)height{
    
    UIImage  *returnImage = nil;
    NSError *error = nil;
    
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBarcodeFormat format = kBarcodeFormatITF;
    
    if (imgtype == 1) {
        format = kBarcodeFormatCode128; //kBarcodeFormatITF;
    }else if(imgtype == 2){
        format = kBarcodeFormatQRCode;
    }
    ZXBitMatrix* result = [writer encode:datas
                                  format:format
                                   width:width
                                  height:height
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        returnImage = [[UIImage alloc] initWithCGImage:image];
        
    }
  

    return returnImage;
 
}
@end
