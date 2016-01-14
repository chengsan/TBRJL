//
//  CHSaveDataTool.h
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHSaveDataTool : NSObject

+(void)saveBool:(BOOL)b forKey:(NSString *)key;
+(BOOL)boolForkey:(NSString *)key;

+(void)setObject:(NSString *)object forKey:(NSString *)key;
+(NSString *)objectForkey:(NSString *)key;
@end
