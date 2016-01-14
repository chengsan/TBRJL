//
//  DropDown.h
//  TBRJL
//
//  Created by 程三 on 15/6/27.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义协议
@class DropDown;
@protocol DropDownDelagate <NSObject>
//表示必须实现
//@required
//可以选择实现
@optional
-(void)DropDownDidSelected:(DropDown *)dropDown index:(NSInteger)index;
@end

@interface DropDown : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel;
    UITableView *tv;//下拉列表
    //NSArray *tableArray;//下拉列表数据
    UIButton *textBtn;//文本输入框
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    NSArray *tableArray;
}

-(void)setTableArray:(NSArray *)tableArray;
//协议对象
@property(nonatomic,retain)id<DropDownDelagate> dropDownDelagate;
//设置标题
-(void)setTitle:(NSString *)title;
//设置被选中的下标值
-(void)setSelectIndex:(int)index;
@end
