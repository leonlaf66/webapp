//
//
//  Created by 林 建军 on 8/2/15.
//  Copyright (c) 2015 yl. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <TargetConditionals.h>

#import <AVFoundation/AVFoundation.h>

@interface NSString (XTExtension)

- (NSString *)URLDecode;

- (NSString *)URLEncode;

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)trim;
- (NSString *)unwrap;

- (NSDate *)dateWithFormate:(NSString *)formate;

- (BOOL)isPureInt;

- (BOOL)isValidPhone;
- (BOOL)isValidPassword;
- (BOOL)isValidPayPassword;

@end


@interface NSString (md5)

-(NSString *)md5;

@end

@interface NSString (TextFieldText)

- (NSString *) changeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
