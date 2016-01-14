//
//  TBPUtil.m
//  TBRJL
//
//  Created by 程三 on 15/8/23.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "TBPUtil.h"

@implementation TBPUtil
+(NSString *)getSafeTypeNameByCode:(NSString *)psafetypes
{
    NSString *string = nil;
    if([@"001" isEqualToString:psafetypes])
    {
        string = @"普通寿险";
    }
    else if([@"002" isEqualToString:psafetypes])
    {
        string = @"分红型寿险";
    }
    else if([@"003" isEqualToString:psafetypes])
    {
        string = @"投资连结保险";
    }
    else if([@"004" isEqualToString:psafetypes])
    {
        string = @"健康保险";
    }
    else if([@"005" isEqualToString:psafetypes])
    {
        string = @"万能保险";
    }
    else if([@"006" isEqualToString:psafetypes])
    {
        string = @"意外伤害保险";
    }
    else if([@"101" isEqualToString:psafetypes])
    {
        string = @"车险";
    }
    else if([@"102" isEqualToString:psafetypes])
    {
        string = @"家财险";
    }
    else if([@"103" isEqualToString:psafetypes])
    {
        string = @"责任险";
    }
    else if([@"104" isEqualToString:psafetypes])
    {
        string = @"意外险";
    }
    else
    {
        string = @"未知";
    }

    return string;
}
@end
