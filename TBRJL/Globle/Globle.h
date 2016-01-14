//
//  Globle.h
//  TBRJL
//
//  Created by 程三 on 15/6/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorkService.h"

@interface Globle : NSObject

//登陆平台地址
@property(nonatomic,copy) NSString *serviceURL;
//升级平台地址
@property(nonatomic,copy)NSString *updateURL;
//用户对象
@property(nonatomic,retain)NSDictionary *userInfoDic;
//调用服务对象
@property(nonatomic,retain)AFNetWorkService *service;

@property (nonatomic ,strong) NSMutableArray *arrM;

@property (nonatomic ,strong)NSArray *photoArr;

+(Globle *)getInstance;


@end
