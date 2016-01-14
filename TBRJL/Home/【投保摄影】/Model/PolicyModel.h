//
//  PolicyModel.h
//  TBRJL
//
//  Created by lili on 15/11/17.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PolicyModel : NSObject
//会员编号
@property (nonatomic,strong) NSString* userid;
//会员姓名
@property (nonatomic,strong) NSString* hyname;
//保单号（业务流水号）
@property (nonatomic,strong) NSString* safeno;
//保单类型bbtsafetype（0产险1寿险）
@property (nonatomic,assign) NSInteger safetype;
//投保人姓名
@property (nonatomic,strong) NSString* sname;

@property (nonatomic ,copy) NSString *safecode;
//投保人身份证
@property (nonatomic,strong) NSString* cardno;
//保险公司名称
@property (nonatomic,strong) NSString* companyname;
//保险公司机构代码
@property (nonatomic,strong) NSString* companycode;
//保险公司类型
@property (nonatomic ,copy)NSString *companytype;
//保险公司代码
@property (nonatomic,strong) NSString* companyno;
//sysocde
@property (nonatomic,strong) NSString* syscode;
//被保险人姓名
@property (nonatomic,strong) NSString* pname;
//被保险人身份证号
@property (nonatomic,strong) NSString* pcardno;
//车牌
@property (nonatomic,strong) NSString* pcarno;
//车架号
@property (nonatomic,strong) NSString* pwin;
//险种
@property (nonatomic,strong) NSString* psafetypes;
//保险起期
@property (nonatomic,strong) NSString* psafedate;
//保险止期
@property (nonatomic,strong) NSString* psafedateend;
//性别bbtsex（1男0女）

@property (nonatomic ,strong) NSString *isSamePeople;
@property (nonatomic,copy)NSString *sex;
//保费
@property (nonatomic,copy) NSString *safecost;
//年龄
@property (nonatomic,assign) NSString *age;
//保额
@property (nonatomic,copy) NSString  *psafepay;
//区域
@property (nonatomic,strong) NSString* areaid;
//专、兼业
@property (nonatomic,strong) NSString* isprofessional;
//审核状态bbtcheckstatus（0 待审，1待补拍，2已通过,3待补录，4已删除）
@property (nonatomic,assign) NSInteger checkstatus;
//退回原因
@property (nonatomic,strong) NSString* trunbackreason;
//是否已读
@property (nonatomic,strong) NSString* isread;
//业务员机构代码
@property (nonatomic,strong) NSString* personorgno;
//业务员所属公司
@property (nonatomic,strong) NSString* personorgname;
//投保人证件类型(01 身份证，02 护照，03 军官证， 04其他)
@property (nonatomic,strong) NSString* cardtype;
//被投保人证件类型(01 身份证，02 护照，03 军官证， 04其他)
@property (nonatomic,strong) NSString* pcardtype;
//审核人
@property (nonatomic,strong) NSString* checker;
//审核时间
@property (nonatomic,strong) NSString* checktime;
//是否二维码
@property (nonatomic,strong) NSString* isqrcode;
//补录原因
@property (nonatomic,strong) NSString* bulureason;
//版本
@property (nonatomic,strong) NSString* version;
//上传版本
@property (nonatomic,strong) NSString* upversion;

@property (nonatomic,strong) NSString* pid;
//  创建时间
@property (nonatomic ,copy) NSString *creatTime;


@property (nonatomic,assign) NSInteger policy_id;

//   存放图片的文件夹
@property (nonatomic ,copy) NSString *photoDicPath;

//上传版本
@property (nonatomic,strong) NSString* picturefile;

@property(nonatomic,copy)NSString *filename;//根据是否上传文件

//险种名称
@property (nonatomic,strong) NSString* psafetypesName;

//退回原因
@property (nonatomic,strong) NSString* thyy;
@end
