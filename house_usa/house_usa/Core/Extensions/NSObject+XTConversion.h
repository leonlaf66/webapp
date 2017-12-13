//
//  NSObject+XTConversion.h
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <TargetConditionals.h>

#import <AVFoundation/AVFoundation.h>

@interface NSObject (XTConversion)

- (NSNumber *)toNumber;

/**
 *  国际化 获取指定语言集合
 *
 *  @param lang 语言zh-Hans,en
 *
 *  @return 字典
 */
-(NSDictionary *)getLocal:(NSString *)lang;
/**
 *  获取系统语言
 *
 *  @return 字典
 */
-(NSDictionary *)getSystemLocal;
/**
 *  获取系统语言
 *
 *  @return 系统语言
 */
-(NSString *)getSystemLang;
/**
 *  获取默认语言集合
 *
 *  @return 字典
 */
-(NSString *)getLang;

-(NSString *)getMyLang;
-(NSDictionary *)getMyLocal;

@end
