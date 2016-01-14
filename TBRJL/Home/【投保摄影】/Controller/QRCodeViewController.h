//
//  QRCodeViewController.h
//  TBRJL
//
//  Created by Charls on 15/12/15.
//  Copyright (c) 2015年 陈浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface QRCodeViewController : BaseViewController
{
    UIButton *scanBtn;
    UILabel  *contentLabel;
    UIButton *nextBtn;
    NSString *ewmContent;
    int currentType;//类型：0 新建／1:缓存／2:补拍／3:补录
    //保单信息对象
    EntityBean *safeInfo;
    //照片数组
    NSArray *photoArray;
}

@property (nonatomic ,strong)PolicyModel *model;
-(void)setSafeInfo:(EntityBean *)safeInfoBean;
-(void)setPhotoArray:(NSArray *)photos;
-(void)setCurrentType:(int)type;
@end
