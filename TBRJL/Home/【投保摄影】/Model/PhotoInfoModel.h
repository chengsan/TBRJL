//
//  PhotoInfoModel.h
//  TBRJL
//
//  Created by Charls on 15/12/1.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoInfoModel : NSObject

@property(nonatomic,copy)NSString *safecategory;//险种（关联DetailCofigModel）
@property(nonatomic,copy)NSString *configDataCompanyno;//机构代码关联ConfigDataModel）
//
//attid = 7ff29c99c2134a20bdca3193a5a94c4f;
//beanname = bbtoneconfigattext;
//code = 1010201;
//createtime = "2014-12-23 11:28:04.047";
//creator = 350000012000;
//filename = "2015123201943.jpg";
//iswater = 1;
//nullable = 1;
//path = "/var/mobile/Containers/Data/Application/0E67590C-CA02-4EC8-AF39-7FD9536BE138/Documents/photoInfo/2015123201937";
//photocode = 10102;
//photoname = "\U6295\U4fdd\U4eba\U8eab\U4efd\U8bc1\U539f\U4ef6\U6b63\U9762";
//phototype = "\U6295\U4fdd\U4eba\U8eab\U4efd\U8bc1\U539f\U4ef6";
//title = "\U6295\U4fdd\U4eba\U8eab\U4efd\U8bc1\U539f\U4ef6\U6b63\U9762";
//updater = 350000012000;
//updatetime = "2014-12-25 18:01:11.213";
//

@property (nonatomic ,copy)NSString *photoTable;     //表名
@property (nonatomic ,copy)NSString *attid;        //
@property (nonatomic ,copy)NSString *beanname;
@property (nonatomic ,copy)NSString *code;        // 所属类型
@property (nonatomic ,copy)NSString *createtime;
@property (nonatomic ,copy)NSString *creator;
@property (nonatomic ,copy)NSString *filename;        //文件名称
@property (nonatomic ,copy)NSString *iswater;     // 是否加水印
@property (nonatomic ,copy)NSString *nullable1;      //1:必拍 0：可以不拍
@property (nonatomic ,copy)NSString *path;           //本地完整路径名、
@property (nonatomic ,copy)NSString *photocode;      //是否有效
@property (nonatomic ,copy)NSString *photoname;       //标题
@property (nonatomic ,copy)NSString *phototype;       // 照片类型（如区分身份证照片和签名照）
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *updater;
@property (nonatomic ,copy)NSString *updatetime;
@property (nonatomic ,copy)NSString *bbtinfoid;      //保宝通id




@property (nonatomic ,copy)NSString *namedpath;     //	通道




@end
