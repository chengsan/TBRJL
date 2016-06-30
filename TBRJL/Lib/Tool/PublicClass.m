 //
//  PublicClass.m
//  TBRJL
//
//  Created by 陈浩 on 15/12/21.
//  Copyright © 2015年 陈浩. All rights reserved.
//

#import "PublicClass.h"

@implementation PublicClass

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


#pragma mark - 身份证识别
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    {
        NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [pred evaluateWithObject:cardNo];
        return isMatch;
    }
}


/**
 *  根据规则判断字符串
 */
+(BOOL)checkPrint:(NSString *)text withRule:(NSString *)ruleStr{
    
    NSString *regex = ruleStr;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:text] == false)
    {
        return false;
    }
    return true;
}



//    清除缓存
+(void)cleanCacheWithPath:(NSString *)path{
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
    for (NSString *p in files) {
        NSError *error;
        if ([p hasPrefix:@"Preferences"]) {
            return;
        }
        NSString *Path = [path stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
        }
    }
}

@end
