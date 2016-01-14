//
//  SZSettingItem.m
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "SZSettingItem.h"

@implementation SZSettingItem

+(instancetype)itemWithTitle:(NSString *)title btnTitle:(NSString *)btnTitle{
    SZSettingItem *item = [[self alloc] init];
    item.title = title;
    item.btnTitle = btnTitle;
    return item;
}

+(instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithTitle:title btnTitle:nil];
}
@end
