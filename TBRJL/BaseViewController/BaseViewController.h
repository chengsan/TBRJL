//
//  BaseViewController.h
//  TBRJL
//
//  Created by 程三 on 15/6/2.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
#import "PhotoInfoModel.h"
#import "PolicyModel.h"
#import "FMDatabase.h"
#import "MBProgressHUD+PKX.h"
#import "TBRJL-Prefix.pch"
#import "EntityBean.h"
#import "UIViewExt.h"
#import "Util.h"
#import "Globle.h"
#import "PublicClass.h"

@interface BaseViewController : UIViewController
{
    UIView *_loadView;
    UIView *_noticeView;
}

@property(nonatomic,assign)BOOL isBackButton;

//是否显示加载提示
-(void)showLoading:(BOOL)show;
//显示没有数据提示
-(void)showNotice:(BOOL)show;

@property (nonatomic ,strong)UILabel *backTitleLabel;

@property (nonatomic ,strong) FMDatabase *db;



/**
 *  创建保单表
 */
-(void)creatPolicy;


/**
 *  创建保单图片的表单
 */
-(void)creatPolicyImage;

/**
 *  存储保单到数据表中
 */
-(BOOL)updatePolicy:(PolicyModel *)model;

/**
 *  根据保单表创建的时间来 存储图片信息到数据库
 */
-(BOOL)updatePolicyImage:(PhotoInfoModel *)model withCreatTime:(NSString *)creatTime;

/**
 *  从数据库获取保单数据
 */
-(NSMutableArray *)getPolicyDataWithUserID:(NSString *)userid;

/**
 *  根据创建的时间找到所对应的数据表
 */
-(NSMutableArray *)getImagePathWithCreatTime:(NSString *)creatTime;

/**
 *  根据保单创建时间删除指定数据表单
 */
-(BOOL) deleteTableByCreatTime:(NSString *)creatTime TableName:(NSString*)tableName;






@end
