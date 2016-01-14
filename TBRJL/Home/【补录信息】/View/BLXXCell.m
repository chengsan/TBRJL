//
//  BLXXCell.m
//  TBRJL
//
//  Created by 程三 on 15/8/15.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BLXXCell.h"
#import "UIViewExt.h"
#import "TBRJL-Prefix.pch"
#import "Globle.h"
#import "PhotoViewController.h"
#import "BaoDanCell.h"
#import "BaoDanInfoController.h"
#import "QRCodeViewController.h"
#define KWHeight 100
#define KHeight 30
#define LeftMargin 20
@implementation BLXXCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    
    return self;
}

-(void)_initView
{
    kindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    kindLabel.text = @"险种:";
    kindLabel.textColor = [PublicClass colorWithHexString:@"#04a3fe"];
    kindLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:kindLabel];
    
    psafetypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    psafetypeLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    psafetypeLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:psafetypeLabel];
    
    
    personLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    personLabel.text = @"投保人:";
    personLabel.textColor = [PublicClass colorWithHexString:@"#04a3fe"];
    personLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:personLabel];
    
    snameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    snameLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    snameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:snameLabel];
    
    
    numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    numLabel.text = @"保单号:";
    numLabel.textColor =[PublicClass colorWithHexString:@"#04a3fe"];
    numLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:numLabel];
    
    safenoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    safenoLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    safenoLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:safenoLabel];
    
//     详情
    infoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    infoBtn.frame =CGRectZero;
    [infoBtn.layer setCornerRadius:5];
    infoBtn.tag = 100;
    [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_info_normal"] forState:UIControlStateNormal];
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_info_press"] forState:UIControlStateHighlighted];
    [infoBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:infoBtn];
    
//     手工
    sglrBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sglrBtn.frame =CGRectZero;
    [sglrBtn.layer setCornerRadius:5];
    sglrBtn.tag = 101;
    [sglrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sglrBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_sglr_normal.png"] forState:UIControlStateNormal];
    [sglrBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_sglr_press.png"] forState:UIControlStateHighlighted];
    [sglrBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sglrBtn];
    
//     二维码
    ewmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ewmBtn.frame =CGRectZero;
    [ewmBtn.layer setCornerRadius:5];
    ewmBtn.tag = 102;
    [ewmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ewmBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_camera_normal.png"] forState:UIControlStateNormal];
    [ewmBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_camera_press.png"] forState:UIControlStateHighlighted];
    [ewmBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:ewmBtn];
}

-(void)setDataDic:(NSDictionary *)dic
{
    dataDic = dic;
    if(dic != nil)
    {
        psafetypeLabel.text = [TBPUtil getSafeTypeNameByCode:[dic objectForKey:@"psafetypes"]];
        snameLabel.text = [dic objectForKey:@"sname"];
        safenoLabel.text = [dic objectForKey:@"safeno"];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    

    kindLabel.frame = CGRectMake(LeftMargin, 10, 60, KHeight);
    
    psafetypeLabel.frame = CGRectMake(CGRectGetMaxX(kindLabel.frame), 10, 100, KHeight);
    
    personLabel.frame = CGRectMake(LeftMargin, kindLabel.bottom, 60, KHeight);
    snameLabel.frame = CGRectMake(CGRectGetMaxX(personLabel.frame), kindLabel.bottom, 100, KHeight);
    
    numLabel.frame = CGRectMake(LeftMargin, personLabel.bottom,60, KHeight);
    safenoLabel.frame = CGRectMake(CGRectGetMaxX(numLabel.frame), personLabel.bottom, 100, KHeight);
    

    float marg = (ScreenWidth - KHeight * 3 - 2* 40)/2;
    infoBtn.frame = CGRectMake(40, numLabel.bottom + 10, KHeight, KHeight);
    
    sglrBtn.frame = CGRectMake(infoBtn.right + marg, numLabel.bottom + 10, KHeight, KHeight);
    
    ewmBtn.frame = CGRectMake(sglrBtn.right + marg, numLabel.bottom + 10, KHeight                                                                                                     , KHeight);
}


+(CGFloat)getCellheight
{
    return 10 + 30 *3 + 40 + 10;
}

#pragma mark 点击回调方法
-(void)onClick:(UIButton *)btn
{
    //设置对应的标记值：0:详情 1:手工 2:二维码
    if(btn == infoBtn)
    {
        [self loadDataForId:0];
    }
    else if(btn == sglrBtn)
    {
        [self loadDataForId:1];
    }
    else if(btn == ewmBtn)
    {
        [self loadDataForId:2];
    }
}

#pragma  mark 根据ID值加载下一步需要的数据
-(void)loadDataForId:(int)mark
{
    customAlert = [[FVCustomAlertView alloc] init];
    [customAlert showAlertWithonView:blxxViewController.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:0];
    
    //获取ID
    NSString *strId = [dataDic objectForKey:@"id"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:strId forKey:@"infoid"];
    [params setValue:@"true" forKey:@"isBupai"];
    
    [[Globle getInstance].service requestWithServiceName:@"BBTone_getDatainfo2" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result) {
        [self loadDataFinish:mark result:result];
    } ];
    
}

#pragma mark 加载数据完成回调方法
-(void)loadDataFinish:(int)mark result:(id)result
{
    if(nil != customAlert)
    {
        [customAlert dismiss];
    }
    
    if(result == nil)
    {
        [self showNotice:@"温馨提示" msg:@"数据加载失败"];
        return;
    }
    
    NSDictionary *dic = result;
    if(dic == nil)
    {
        [self showNotice:@"温馨提示" msg:@"数据加载失败"];
        return;
    }
    
    NSArray *array = [dic objectForKey:@"result"];
    if(nil == array || array.count == 0)
    {
        [self showNotice:@"温馨提示" msg:@"数据加载失败"];
        return;
    }
    
    NSDictionary *safeInfoDic = [array objectAtIndex:0];
    if(safeInfoDic == nil)
    {
        [self showNotice:@"温馨提示" msg:@"数据加载失败"];
        return;
    }
    
    //设置对应的标记值：0:详情 1:手工 2:二维码
    switch (mark) {
        case 0:
        {
            if(nil != blxxViewController)
            {
                BaoDanInfoController *baoDanVc = [[BaoDanInfoController alloc] init];
                baoDanVc.dict = safeInfoDic;
                [blxxViewController.navigationController pushViewController:baoDanVc animated:YES];
            }
            
        }
        break;
            
        case 1:
        {
            EntityBean *safeInfo = [[EntityBean alloc] init];
            NSArray *keyArray = [safeInfoDic allKeys];
            for (int i = 0; i < keyArray.count; i++)
            {
                [safeInfo setValue:[safeInfoDic objectForKey:[keyArray objectAtIndex:i]] forKey:[keyArray objectAtIndex:i]];
            }
            
            NSArray *photoArray = [self getPhotoArray:(NSArray *)[safeInfo objectForKey:@"atts"]];
            
            if(nil != blxxViewController)
            {
                SGLRViewController *sglrViewController = [[SGLRViewController alloc] init];
                [sglrViewController setSafeInfo:safeInfo];
                [sglrViewController setPhotoArray:photoArray];
                //类型：0 新建／1:缓存／2:补拍／3:补录
                [sglrViewController setCurrentType:3];
                
                [blxxViewController.navigationController pushViewController:sglrViewController animated:YES];
            }

        }
        break;
            
        case 2:
        {
            EntityBean *safeInfo = [[EntityBean alloc] init];
            NSArray *keyArray = [safeInfoDic allKeys];
            for (int i = 0; i < keyArray.count; i++)
            {
                [safeInfo setValue:[safeInfoDic objectForKey:[keyArray objectAtIndex:i]] forKey:[keyArray objectAtIndex:i]];
            }
            
            NSArray *photoArray = [self getPhotoArray:(NSArray *)[safeInfo objectForKey:@"atts"]];
            
            if(nil != blxxViewController)
            {
                QRCodeViewController *qrCodeVc = [[QRCodeViewController alloc] init];
                [qrCodeVc setSafeInfo:safeInfo];
                [qrCodeVc setPhotoArray:photoArray];
                //类型：0 新建／1:缓存／2:补拍／3:补录
                [qrCodeVc setCurrentType:3];
                [blxxViewController.navigationController pushViewController:qrCodeVc animated:YES];
            }

        }
        break;

    }
    
}

#pragma mark 获取照片数组
-(NSArray *)getPhotoArray:(NSArray *)array
{
    NSMutableArray *photoArray = nil;
    if(nil != array)
    {
        photoArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < array.count; i++)
        {
            NSDictionary *myDic = array[i];
            if(nil != myDic)
            {
                EntityBean *bean = [[EntityBean alloc] init];
                
                NSArray *allKeys = [myDic allKeys];
                if(nil != allKeys)
                {
                    for (int j = 0; j < allKeys.count; j++)
                    {
                        [bean setValue:[myDic objectForKey:allKeys[j]] forKey:allKeys[j]];
                    }
                }
                
                [photoArray addObject:bean];
            }
        }
    }

    return photoArray;
}

#pragma mark Cell所在控制器对象
-(void)setBLXXViewController:(BLXXViewController *)viewController
{
    blxxViewController = viewController;
}

#pragma mark 对话框提示方法
-(void)showNotice:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
@end
