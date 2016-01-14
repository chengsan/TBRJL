//
//  SZSettingGroup.h
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZSettingGroup : NSObject

@property (nonatomic ,strong) NSArray *items;

+(instancetype)groupWithItems:(NSArray *)items;
@end
