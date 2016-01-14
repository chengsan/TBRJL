//
//  SZSettingItem.h
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^OperationBlock)();

@interface SZSettingItem : NSObject

/**
 *  标题
 */
@property (nonatomic ,copy) NSString *title;

/**
 *  按钮的标题
 */
@property (nonatomic ,copy) NSString *btnTitle;

@property (nonatomic ,copy) OperationBlock operationBlock;

+(instancetype) itemWithTitle:(NSString *)title;
+(instancetype) itemWithTitle:(NSString *)title btnTitle:(NSString *)btnTitle;
@end
