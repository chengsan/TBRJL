//
//  PublicClass.h
//  TBRJL
//
//  Created by 陈浩 on 15/12/21.
//  Copyright © 2015年 陈浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface PublicClass : NSObject


#pragma mark - 16进制的色值转换成rgb
+ (UIColor *) colorWithHexString: (NSString *)color;

#pragma mark - 身份证识别
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;

#pragma mark -  是否为字符串
+(BOOL)checkPrint:(NSString *)text withRule:(NSString *)ruleStr;

// 清理缓存
+(void)cleanCacheWithPath:(NSString *)path;


@end
