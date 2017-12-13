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
#undef	RGB
#define RGB(R,G,B)          [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef	RGBA
#define RGBA(R,G,B,A)       [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#undef	HEX_RGB
#define HEX_RGB(V)          [UIColor fromHexValue:V]

#undef	HEX_RGBA
#define HEX_RGBA(V, A)      [UIColor fromHexValue:V alpha:A]

#undef	SHORT_RGB
#define SHORT_RGB(V)        [UIColor fromShortHexValue:V]

#undef	SHORT_RGBA
#define SHORT_RGBA(V, A)    [UIColor fromShortHexValue:V alpha:A]

@interface UIColor (XTExtention)

+ (UIColor *)globalTintColor;
+ (UIColor *)globalRedColor;
+ (UIColor *)globalGrayColor;
+ (UIColor *)fromHexValue:(NSUInteger)hex;
+ (UIColor *)fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)fromShortHexValue:(NSUInteger)hex;
+ (UIColor *)fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithString:(NSString *)string; // {#FFF|#FFFFFF|#FFFFFFFF}{0.6}

@end
