//
//  DropDown.h
//  TBRJL
//
//  Created by 程三 on 15/6/27.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义协议
@class TitleDropDown;
@protocol TitleDropDownDelagate <NSObject>
//表示必须实现
//@required
//可以选择实现
@optional
-(void)titleDropDownDidSelected:(TitleDropDown *)dropDown index:(NSInteger)index;
@end

@interface TitleDropDown : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
    
    UITextField *contentTextView;
    UITableView *tv;//下拉列表
    UIButton *textBtn;//文本输入框
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    NSArray *tableArray;
}
@property (nonatomic ,strong) UITextField *contentTextView;
-(void)setTableArray:(NSArray *)tableArray;
//协议对象
@property(nonatomic,retain)id<TitleDropDownDelagate> dropDownDelagate;
//设置被选中的下标值
-(void)setSelectIndex:(int)index;
//获取输入的内容
-(NSString *)getTextFieldContent;
@end
