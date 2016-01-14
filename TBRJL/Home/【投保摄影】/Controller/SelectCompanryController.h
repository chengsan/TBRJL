//
//  SelectCompanryController.h
//  TBRJL
//
//  Created by 程三 on 15/6/22.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaseViewController.h"
#import "DropDown.h"

@interface SelectCompanryController : BaseViewController<DropDownDelagate>
{
    //公司列表
    NSArray *comparyArray;
    //保险产品列表
    NSArray *safeArray;
    //保单信息对象
    EntityBean *safeInfo;
    //照片数组
    NSArray *photoArray;
    //录入方式:0 二维码 ／1 手工
    int way;
    
    
}
@property(nonatomic,retain)DropDown *dropDownCompary;
@property(nonatomic,retain)UILabel *comparyCodeName;
@property(nonatomic,retain)DropDown *dropDownSafeKind;
@property(nonatomic,retain)UILabel *userNameName;
@property(nonatomic,retain)UIImageView *ewmImage;
@property(nonatomic,retain)UIImageView *sgImage;
@property(nonatomic,retain)UIButton *nextBtn;

@end
