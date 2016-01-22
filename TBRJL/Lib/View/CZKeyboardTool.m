//
//  CZKeyboardTool.m
//  网易彩票
//
//  Created by Apple on 15/5/30.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "CZKeyboardTool.h"

@interface CZKeyboardTool()
- (IBAction)cancel;
- (IBAction)sure;

@end

@implementation CZKeyboardTool

+(instancetype)keyboardTool{
    return [[[NSBundle mainBundle] loadNibNamed:@"CZKeyboardTool" owner:nil options:nil] lastObject];
}
/**
 *  取消
 */
- (IBAction)cancel {
    if (self.clickBlock) {
        self.clickBlock(CZKeyboardToolButtonTypeCancel);
    }
}

/**
 *  确定
 */
- (IBAction)sure {
    if (self.clickBlock) {
        self.clickBlock(CZKeyboardToolButtonTypeSure);
    }
}
@end
