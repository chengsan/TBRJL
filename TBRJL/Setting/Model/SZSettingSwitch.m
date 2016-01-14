//
//  SZSettingSwitch.m
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "SZSettingSwitch.h"
#import "CHSaveDataTool.h"
@implementation SZSettingSwitch

/**
 *  保存开关状态
 */
- (void)setOn:(BOOL)on {
    _on = on;
    [CHSaveDataTool saveBool:on forKey:self.title];
} 

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    
//     读取开关状态
    _on = [CHSaveDataTool boolForkey:title];
}
@end
