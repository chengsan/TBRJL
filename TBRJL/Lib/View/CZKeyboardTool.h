//
//  CZKeyboardTool.h
//  网易彩票
//
//  Created by Apple on 15/5/30.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CZKeyboardToolButtonTypeCancel,// 取消
    CZKeyboardToolButtonTypeSure,// 确定
}CZKeyboardToolButtonType;

typedef void (^ButtonClickBlock)(CZKeyboardToolButtonType buttonType);


@interface CZKeyboardTool : UIView
+(instancetype)keyboardTool;

@property (nonatomic,copy) ButtonClickBlock clickBlock;

@end
