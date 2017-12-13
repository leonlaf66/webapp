//
//
//  Created by 林 建军 on 8/2/15.
//  Copyright (c) 2015 yl. All rights reserved.
//
#import "NSString+XTExtension.h"
#import <CommonCrypto/CommonDigest.h>

#define phonePredicate @"^[0-9]{11}$" // 手机号码
#define nickNamePredicate @"^[a-zA-Z0-9_\\u4E00-\\u9FA5\\w]{2,10}$" // 中文，数字，字母，2-10位
#define numberPredicate @"^[0-9]*$"//是否为数字 3位
#define emailPredicate @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define passwordPredicate @"^[a-zA-Z0-9_]{6,12}$" // 字母数字或下划线 6-12位
#define payPasswordPredicate @"^[0-9]{6}$" // 数字，6位
#define verificationcodePredicate @"^[0-9]{6}$" // 数字，6位
#define moneyPredicate @"^[0-9]{0,5}$" // 金额，小数点后两位，允许逗号分割
#define identifyChinese @"^[\u4E00-\u9FA5]{2,8}$" // 匹配中文

@implementation NSString (XTExtension)


- (NSString *)URLDecode
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLEncode
{
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}



- (BOOL)isVaildNumber {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberPredicate];
    return [pred evaluateWithObject:self];
}

- (BOOL)isValidPhone {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phonePredicate];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isValidPassword {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordPredicate];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isValidPayPassword {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", payPasswordPredicate];
    
    return [pred evaluateWithObject:self];
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap
{
	if ( self.length >= 2 )
	{
		if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}
        
		if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}
	}
    
	return self;
}



- (BOOL)isMatch:(NSString *)regex{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

static NSDateFormatter *dateFormatter = nil;
- (NSDate *)dateWithFormate:(NSString *)formate{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formate];
    return [dateFormatter dateFromString:self];
}

- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}



@end


@implementation NSString (md5)

-(NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end


@implementation NSString (TextFieldText)
// 调用textField(textField: UITextField, shouldChangeCharactersInRange时，第一个输入的字符不会进入前面一个方法，此方法就是将第一个字符插入[futureString insertString:string atIndex:range.location]
- (NSString *) changeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString * futureString = [NSMutableString stringWithString:self];
    if (range.length == 0) {
        [futureString insertString:string atIndex:range.location];
    } else {
        [futureString deleteCharactersInRange:range];
    }
    
    return futureString;
}

@end
