//
//  SZSettingGroup.m
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "SZSettingGroup.h"

@implementation SZSettingGroup

+(instancetype) groupWithItems:(NSArray *)items{
    SZSettingGroup *group = [[SZSettingGroup alloc] init];
    group.items = items;
    return group;
}
@end
