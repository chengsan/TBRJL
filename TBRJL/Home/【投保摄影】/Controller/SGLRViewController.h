//
//  SGLRViewController.h
//  TBRJL
//
//  Created by 程三 on 15/7/26.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaseViewController.h"
#import "TitleDropDown.h"
#import "FVCustomAlertView.h"
#import "PhotoViewController.h"


@interface SGLRViewController : BaseViewController<TitleDropDownDelagate,UITextFieldDelegate>
{
    int currentType;//类型：0 新建／1:缓存／2:补拍／3:补录
    //保单信息对象
    EntityBean *safeInfo;
    //照片数组
    NSArray *photoArray;
    //下一步按钮
    UIButton *nextBtn;
//     图片文件夹地址
    NSString *photoDicPath;
    //流水号
    UITextField *safenoTextView;
    //投保人姓名
    UITextField *safenameTextView;
    //投保人证件类型
    TitleDropDown *titleDropDown;
    //证件类型
    NSString *safeType;
    //被保险人姓名
    UITextField *safepnameTextView;
    //被保险人证件类型
    TitleDropDown *safepnameDropDown;
    //被保险人证件类型
    NSString *psafeType;
//     车牌号
    TitleDropDown *carnoDropDown;
    //保费
    UITextField *safepayTextView;
    //保额
    UITextField *safecostTextView;
    //开始时间输入框
    UITextField *starttimeTextView;
    //结束时间输入框
    UITextField *endtimeTextView;
    //0:开始／1:结束
    int mark;
    //车牌号
    UITextField *pcarnoTextView;
    //车架号
    UITextField *carpwinTextView;
    //投保人性别
    UITextField *sexTextView;
    //投保人年龄
    UITextField *ageTextView;
    
    //时间选择View
    UIView *dateView;
    //时间选择的总View
    UIButton *viewLayout;
    //开始时间
    NSString *startTimeString;
    //结束时间
    NSString *endTimeString;
}

-(void)setSafeInfo:(EntityBean *)safeInfoBean;
-(void)setPhotoArray:(NSArray *)photos;
-(void)setCurrentType:(int)type;
@end
