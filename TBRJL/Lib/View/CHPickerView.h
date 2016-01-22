//
//  CHPickerView.h
//  TBRJL
//
//  Created by lili on 15/10/14.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZKeyboardTool.h"

@class CHPickerView;

@protocol CHPickerViewDelegate <NSObject>
@optional

- (void)PickerView:(CHPickerView *)pickeView didClickBtnType:(CZKeyboardToolButtonType)type;

@end

@interface CHPickerView : UIView

@property (nonatomic,weak) id<CHPickerViewDelegate> delegate;
/**
 *  选择器
 */
@property (nonatomic,weak,readonly) UIPickerView *pickerView;

@property (nonatomic ,strong)NSArray *dataSource;

@property (nonatomic ,copy) NSString *title;
/**
 *  创建日期选择器
 *
 */
+(instancetype)pickerView;
/**
 *  显示日期选择器
 */
-(void)show;
/**
 *  隐藏日期选择器
 */
-(void)dismiss;
@end
