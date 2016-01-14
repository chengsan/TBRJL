//
//  UserInfoModel.h
//  TBRJL
//
//  Created by 程三 on 15/5/30.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
//密码
@property(copy ,nonatomic)NSString *acountpwd;
//政治面貌
@property(copy ,nonatomic)NSString *politics;
//所属机构名称
@property(copy ,nonatomic)NSString *orgname;
//婚姻状态
@property(copy ,nonatomic)NSString *marry;
//传真
@property(copy ,nonatomic)NSString *fax;
//所在公司类型
@property(copy ,nonatomic)NSString *companyno;
//手机
@property(copy ,nonatomic)NSString *mobile;
//出生年月
@property(copy ,nonatomic)NSString *birthday;
//性别
@property(copy ,nonatomic)NSString *sex;
//投保人证件号码
@property(copy ,nonatomic)NSString *cardno;
//姓名
@property(copy ,nonatomic)NSString *name;
//所属机构编码
@property(copy ,nonatomic)NSString *orgno;
//学历
@property(copy ,nonatomic)NSString *edulevel;
//地区 所在地 序列号
@property(copy ,nonatomic)NSString *areaid;
//证件类型
@property(copy ,nonatomic)NSString *cardtypeid;
//国籍
@property(copy ,nonatomic)NSString *nationality;
@end
