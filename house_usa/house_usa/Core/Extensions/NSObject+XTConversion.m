//
//  NSObject+XTConversion.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "NSObject+XTConversion.h"
#import "NSString+XTExtension.h"
#import "AppDelegate.h"
@implementation NSObject (XTConversion)


- (NSNumber *)toNumber{
	if ([self isKindOfClass:[NSNumber class]]){
		return (NSNumber *)self;
	}
    
    if ([self isKindOfClass:[NSString class]]){
		return [NSNumber numberWithDouble:[(NSString *)self doubleValue]];
	}
    
    if ([self isKindOfClass:[NSDate class]]){
		return [NSNumber numberWithDouble:[(NSDate *)self timeIntervalSince1970]];
	}
    
    if ([self isKindOfClass:[NSNull class]]){
		return [NSNumber numberWithInteger:0];
	}
    
    NSAssert(NO, @"该类型（%@）不能转换为NSNumber类型",[self class]);
	return nil;
}
-(NSString *)getLang{
    AppDelegate *delegate =  (AppDelegate *) [UIApplication sharedApplication].delegate;
    return delegate.lang;
}

-(NSDictionary *)getLocal:(NSString *)lang{
    //zh-Hans,en
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:lang];
    return [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
}
-(NSDictionary *)getSystemLocal{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
  //currentLanguage =   [currentLanguage substringToIndex:[currentLanguage length] -3 ];
    if ([currentLanguage containsString:@"en"]) {
        currentLanguage = @"en";
    }else if ([currentLanguage containsString:@"zh"]) {
         currentLanguage = @"zh-Hans";
    }else{
       currentLanguage = @"en";
    }
    NSDictionary *datas =  [self getLocal:currentLanguage];
    return datas;
}
/**
 *  获取系统语言字典
 *
 *  @return 字典
 */
-(NSDictionary *)getMyLocal{
    NSDictionary *datas = nil;
    if ([self getLang] == nil) {
        datas =  [self getSystemLocal];
    }else{
        datas =  [self getLocal:[self getLang]];
    }
    
    return datas;
}

-(NSString *)getMyLang{
    if([self getLang]){
        return [self getLang];
    }else{
        return [self getSystemLang];
    }

}

-(NSString *)getSystemLang{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
   // currentLanguage =   [currentLanguage substringToIndex:[currentLanguage length] -3 ];
    if ([currentLanguage containsString:@"en"]) {
        currentLanguage = @"en";
    }else if ([currentLanguage containsString:@"zh"]) {
        currentLanguage = @"zh-Hans";
    }else{
        currentLanguage = @"en";
    }
    return currentLanguage;
}

@end
