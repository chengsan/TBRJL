//
//  photoViewController.h
//  TBRJL
//
//  Created by 程三 on 15/7/12.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomCarmeraController.h"
#import "FVCustomAlertView.h"

@interface PhotoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CustomCarmeraDelagate,CustomAlertViewDelegate>
{
    UITableView *photoTableView;
    UIButton *saveBtn;//保存
    UIButton *sendBtn;//发送
    //上传提示
    FVCustomAlertView *sendNotice;
    //上传成功提示
    FVCustomAlertView *successNotice;
    int currentType;//类型：0 新建／1:缓存／2:补拍／3:补录
    //保单信息对象
    EntityBean *safeInfo;
    //照片数组
    NSArray *photoArray;
    //相机类
    CustomCarmeraController *carmeraController;
    //图片存放的目录
    NSString *photoDicPath;
    //Zip包路径
    NSString *zipPath;
    //当前拍摄影像的下标值
    NSInteger position;
}

-(void)setSafeInfo:(EntityBean *)safeInfoBean;
-(void)setPhotoArray:(NSArray *)photos;
-(void)setCurrentType:(int)type;

@end
