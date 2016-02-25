//
//  QRCodeViewController.m
//  TBRJL
//
//  Created by Charls on 15/12/15.
//  Copyright (c) 2015年 陈浩. All rights reserved.
//

#import "QRCodeViewController.h"
#import "PhotoViewController.h"
#import "SMS4.h"
#import "ScanViewController.h"
@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码扫描";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //===================扫面二维码按钮=====================
    scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBtn.tag = 100;
    scanBtn.top = 0;
    scanBtn.left = 0;
    scanBtn.width = ScreenWidth;
    scanBtn.height = 40;
    [scanBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_normal.png"] forState:UIControlStateNormal];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_selected.png"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:scanBtn];
    
    UIImageView *cameraIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tbsy_camera_normal.png"]];
    cameraIcon.backgroundColor = [UIColor clearColor];
    cameraIcon.left = 10;
    cameraIcon.height = 30;
    cameraIcon.top = (scanBtn.height - cameraIcon.height)/2;
    cameraIcon.width = 30;
    [scanBtn addSubview:cameraIcon];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.left = cameraIcon.right + 10;
    titleLabel.top = 0;
    titleLabel.width = ScreenWidth - cameraIcon.width - 10;
    titleLabel.height = scanBtn.height;
    //titleLabel.textAlignment = NSTextAlignmentCenter | NSTextAlignmentRight;
    titleLabel.text = @"扫描保单二维码";
    titleLabel.backgroundColor = [UIColor whiteColor];
//    titleLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [scanBtn addSubview:titleLabel];
    
    int titleBarHeight = TitleBarHeight;
    int statusBarHeight = StatusBarHeight;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scanBtn.bottom, ScreenWidth, ScreenHeight - scanBtn.height - titleBarHeight - statusBarHeight - 50)];
    scrollView.contentSize = CGSizeMake(ScreenWidth, 350);
    scrollView.backgroundColor = RGB(230, 230, 230);
    [self.view addSubview:scrollView];
    
    //显示扫面内容
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 0)];
    contentLabel.numberOfLines = 0; // z自动换行，最关键的一句
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = RGB(11, 11, 11);
    [scrollView addSubview:contentLabel];
    
    
    //======================下一步按钮========================
    UIView *nextBtnView = [[UIView alloc] initWithFrame:CGRectZero];
    nextBtnView.left = 0;
    nextBtnView.top = scrollView.bottom;
    nextBtnView.width = ScreenWidth;
    nextBtnView.height = 50;
    [self.view addSubview:nextBtnView];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(currentType == 3 && (photoArray == nil || photoArray.count == 0))
    {
        [nextBtn setTitle:@"发送" forState:UIControlStateNormal];
    }
    else
    {
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    
    nextBtn.tag = 101;
    nextBtn.frame = CGRectZero;
    nextBtn.width = 200;
    nextBtn.height = 40;
    nextBtn.left = (ScreenWidth - nextBtn.width)/2;
    nextBtn.top = (nextBtnView.height - nextBtn.height)/2;
    //设置不可点击
    nextBtn.enabled = NO;
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    
    UIImage *img = [UIImage imageNamed:@"login_submit_normal.png"];
    img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [nextBtn setBackgroundImage:img forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtnView addSubview:nextBtn];
    
    //填充数据
    [self setData];
    
}
-(void)setSafeInfo:(EntityBean *)safeInfoBean
{
    safeInfo = safeInfoBean;
    NSLog(@" 扫描 %@",[safeInfo getDic]);
}
-(void)setPhotoArray:(NSArray *)photos
{
    photoArray = photos;
}
-(void)setCurrentType:(int)type
{
    currentType = type;
}
-(void)onClick:(UIButton *)btn
{
//    if(nil != nextBtn)
//    {
//        nextBtn.enabled = NO;
//    }
//    
    NSInteger tag = btn.tag;
    
    if(tag == 100)
    {
        NSLog(@"开始扫描");
        //==================使用原生扫码界面======================
        
        ScanViewController *scanVc = [[ScanViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        scanVc.resultBlock = ^(NSString *result){
            [weakSelf getSafeInfo:result];
        };
        
        [self presentViewController:scanVc animated:YES completion:NULL];
        
    }
    else if(tag == 101)
    {
        //设置是否是二维码录入表示字段,0二维码/1手工
        [safeInfo setValue:@"0" forKey:@"isqrcode"];
        
        PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
        [photoViewController setCurrentType:currentType];
        [photoViewController setSafeInfo:safeInfo];
        [photoViewController setPhotoArray:photoArray];
        [self.navigationController pushViewController:photoViewController animated:YES];
    }
}
//显示提示对话框
-(void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg
{
    if(title == nil || msg == nil)
    {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

//获取保单信息
-(void)getSafeInfo:(NSString *)result
{
       if(nil == safeInfo)
    {
        [self showAlertWithTitle:@"温馨提示" msg:@"二维码扫描无效,请重新扫描。"];
        return;
    }
    
    if(result == nil || result.length == 0)
    {
        if(nil != nextBtn)
        {
            nextBtn.enabled = NO;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"二维码扫描无效，请重新扫描" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //进行分解
    if(result != nil )
    {
        NSArray *array = [result componentsSeparatedByString:@"|"];
        
        if(array.count == 16)
        {
            //进行校验
            if(currentType == 0 || currentType == 1 || currentType == 2)
            {
                if(nil != [array objectAtIndex:1] && ![@"" isEqualToString:[array objectAtIndex:1]] && ![@"null" isEqualToString:[array objectAtIndex:1]])
                {
                    if(![[array objectAtIndex:1] isEqualToString:(NSString *)[safeInfo objectForKey:@"safecode"]])
                    {
                        [self showAlertWithTitle:@"温馨提示" msg:@"选择的保险险种与二维码不匹配，请检查二维码是否正确"];
                        return;
                    }
                }
                else
                {
                    //产险需要检验
                    [self showAlertWithTitle:@"温馨提示" msg:@"选择的保险产品与二维码不匹配，请检查二维码是否正确"];
                    return;
                }
            }
            else
            {
                if(safeInfo != nil)
                {
                    int companytype = (int)[safeInfo objectForKey:@"companytype"];
                    //产险需要检验
                    if(1 == companytype)
                    {
                        if(nil != [array objectAtIndex:1] && ![@"" isEqualToString:[array objectAtIndex:1]] && ![@"null" isEqualToString:[array objectAtIndex:1]])
                        {
                            if(![[array objectAtIndex:1] isEqualToString:(NSString *)[safeInfo objectForKey:@"safecode"]])
                            {
                                [self showAlertWithTitle:@"温馨提示" msg:@"选择的保险产品与二维码不匹配，请检查二维码是否正确"];
                                return;
                            }
                        }
                        else
                        {
                            [self showAlertWithTitle:@"温馨提示" msg:@"选择的保险产品与二维码不匹配，请检查二维码是否正确"];
                            return;
                        }
                    }
                    else
                    {
                        if(nil != [array objectAtIndex:1] && ![@"" isEqualToString:[array objectAtIndex:1]] && ![@"null" isEqualToString:[array objectAtIndex:1]])
                        {
                            if([@"101" isEqualToString:[array objectAtIndex:1]] ||
                               [@"102" isEqualToString:[array objectAtIndex:1]] ||
                               [@"103" isEqualToString:[array objectAtIndex:1]] ||
                               [@"104" isEqualToString:[array objectAtIndex:1]])
                            {
                                [self showAlertWithTitle:@"温馨提示" msg:@"选择的保险产品与二维码不匹配，请检查二维码是否正确"];
                                return;
                            }
                        }
                        else
                        {
                            [self showAlertWithTitle:@"温馨提示" msg:@"选择的保险产品与二维码不匹配，请检查二维码是否正确"];
                            return;
                        }
                    }
                }
            }
            
            NSMutableString *newStr = [[NSMutableString alloc] init];
            //获取二维码数据
            NSString *string = nil;
            
            //保单号
            string = [array objectAtIndex:0];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中保单号为空"];
            }
            else
            {
                [safeInfo setValue:string forKey:@"safeno"];
                [newStr appendString:[NSString stringWithFormat:@"\n保单号:%@",string]];
            }
            string = nil;
            
            
            //险种代码
            string = [array objectAtIndex:1];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中险种为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"safecode"];
                [safeInfo setValue:string forKey:@"psafetypes"];
            }
            string = nil;
            
            //投保人
            string = [array objectAtIndex:2];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中投保人姓名为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"sname"];
                [newStr appendString:[NSString stringWithFormat:@"\n投保人姓名:%@",string]];
            }
            string = nil;
            
            //投保人证件类型
            string = [array objectAtIndex:3];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中投保人证件类型为空"];
                return;
            }
            else
            {
                if([self getCardName:string] == nil)
                {
                    [self showAlertWithTitle:@"温馨提示" msg:@"二维码中投保人证件类型不正确"];
                    return;
                }
                else
                {
                    [safeInfo setValue:string forKey:@"cardtype"];
                    [newStr appendString:[NSString stringWithFormat:@"\n投保人证件类型:%@",[self getCardName:string]]];
                }
            }
            string = nil;
            
            //投保人证件号
            string = [array objectAtIndex:4];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中投保人证件号为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"cardno"];
                
                //判断是否是身份证，是的话需要校验
                if([@"01" isEqualToString:((NSString *)[array objectAtIndex:3])])
                {
                    //校验代码暂时没写
                    
                    
                    [newStr appendString:[NSString stringWithFormat:@"\n投保人证件号:%@",string]];
                }
                else
                {
                    [newStr appendString:[NSString stringWithFormat:@"\n投保人证件号:%@",string]];
                }
            }
            string = nil;
            
            //性别:(1男／0女)
            string = [array objectAtIndex:8];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中保单号为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"sex"];
                if([@"1" isEqualToString:string])
                {
                    [newStr appendString:[NSString stringWithFormat:@"\n投保人性别:男"]];
                }
                else if([@"0" isEqualToString:string])
                {
                    [newStr appendString:[NSString stringWithFormat:@"\n投保人性别:女"]];
                }
                else
                {
                    [self showAlertWithTitle:@"温馨提示" msg:@"二维码中性别数据不符合要求"];
                    return;
                }
            }
            string = nil;
            
            //年龄
            string = [array objectAtIndex:9];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中被保险人年龄为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"age"];
                [newStr appendString:[NSString stringWithFormat:@"\n被保险人年龄:%@",string]];
            }
            string = nil;
            
            
            //被保险人
            string = [array objectAtIndex:5];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中被保险人姓名为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"pname"];
                [newStr appendString:[NSString stringWithFormat:@"\n被保险人姓名:%@",string]];
            }
            string = nil;
            
            
            //被保险人证件类型
            string = [array objectAtIndex:6];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中被保险人证件类型为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"pcardtype"];
                [newStr appendString:[NSString stringWithFormat:@"\n被保险人证件类型:%@",[self getCardName:string]]];
            }
            string = nil;
            
            
            //被保险人证件号
            string = [array objectAtIndex:7];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中被保险人证件号为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"pcardno"];
                //判断是否是身份证，是的话需要校验
                if([@"01" isEqualToString:((NSString *)[array objectAtIndex:3])])
                {
                    //校验代码暂时没写
                    
                    
                    [newStr appendString:[NSString stringWithFormat:@"\n被保险人证件号:%@",string]];
                }
                else
                {
                    [newStr appendString:[NSString stringWithFormat:@"\n被保险人证件号:%@",string]];
                }
            }
            string = nil;
            
            
            //保费
            string = [array objectAtIndex:10];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中保费为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"safecost"];
                //判断保费数据是否正确
                [newStr appendString:[NSString stringWithFormat:@"\n保费(元):%@",string]];
            }
            string = nil;
            
            
            //保额
            string = [array objectAtIndex:11];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中保额为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"psafepay"];
                [newStr appendString:[NSString stringWithFormat:@"\n保额(元):%@",string]];
            }
            string = nil;
            
            //保险起期
            string = [array objectAtIndex:12];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中保险起期为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"psafedate"];
                [newStr appendString:[NSString stringWithFormat:@"\n保险起期:%@",string]];
            }
            string = nil;
            
            //保险止期
            string = [array objectAtIndex:13];
            if(string == nil || string.length == 0 || [@"" isEqualToString:string])
            {
                [self showAlertWithTitle:@"温馨提示" msg:@"二维码中保险止期为空"];
                return;
            }
            else
            {
                [safeInfo setValue:string forKey:@"psafedateend"];
                [newStr appendString:[NSString stringWithFormat:@"\n保险止期:%@",string]];
            }
            string = nil;
            
            //车险才有的车牌和车架号
            if([@"001" isEqualToString:(NSString *)[array objectAtIndex:1]])
            {
                //车牌
                string = [array objectAtIndex:14];
                if(string == nil || string.length == 0 || [@"" isEqualToString:string])
                {
                    [self showAlertWithTitle:@"温馨提示" msg:@"二维码中车牌为空"];
                    return;
                }
                else
                {
                    [safeInfo setValue:string forKey:@"pcarno"];
                    [newStr appendString:[NSString stringWithFormat:@"\n车牌:%@",string]];
                }
                string = nil;
                
                //车架号
                string = [array objectAtIndex:15];
                if(string == nil || string.length == 0 || [@"" isEqualToString:string])
                {
                    [self showAlertWithTitle:@"温馨提示" msg:@"二维码中车架号为空"];
                    return;
                }
                else
                {
                    [safeInfo setValue:string forKey:@"pwin"];
                    [newStr appendString:[NSString stringWithFormat:@"\n车架号:%@",string]];
                }
                string = nil;
            }
            
            if(safeInfo != nil)
            {
                NSString *safecode = (NSString *)[safeInfo objectForKey:@"psafetypes"];
                NSString *string = nil;
                if([@"001" isEqualToString:safecode])
                {
                    string = @"普通寿险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:0] forKey:@"safetype"];
                }
                else if ([@"002" isEqualToString:safecode]) {
                    string = @"分红型寿险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:0] forKey:@"safetype"];
                }
                else if ([@"003" isEqualToString:safecode]) {
                    string = @"投资连结保险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:0] forKey:@"safetype"];
                }
                else if ([@"004" isEqualToString:safecode]) {
                    string = @"健康保险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:0] forKey:@"safetype"];
                }
                else if ([@"005" isEqualToString:safecode]) {
                    string = @"万能保险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:0] forKey:@"safetype"];
                }
                else if ([@"006" isEqualToString:safecode]) {
                    string = @"意外伤害保险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:0] forKey:@"safetype"];
                }
                else if ([@"101" isEqualToString:safecode]) {
                    string = @"车险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:1] forKey:@"safetype"];
                }
                else if ([@"102" isEqualToString:safecode]) {
                    string = @"家财险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:1] forKey:@"safetype"];
                }
                else if ([@"103" isEqualToString:safecode]) {
                    string = @"责任险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:1] forKey:@"safetype"];
                }
                else if ([@"104" isEqualToString:safecode]) {
                    string = @"意外险";
                    [safeInfo setValue:[[NSNumber alloc] initWithInt:1] forKey:@"safetype"];
                }
                else {
                    string = @"";
                }
                if(nil != newStr)
                {
                    [newStr appendString:[NSString stringWithFormat:@"\n险种:%@",string]];
                }
            }
            
            [newStr appendString:@"\n"];
            
            
            if(nil != contentLabel)
            {
                contentLabel.text = [NSString stringWithFormat:@"%@",newStr];
            }
            contentLabel.height = [Util getSizeWithString:newStr textSize:14 width:contentLabel.width].height;
            if(nil != nextBtn)
            {
                nextBtn.enabled = YES;
            }
        }
        else
        {
            [self showAlertWithTitle:@"温馨提示" msg:@"二维码格式不符合要求。"];
            return;
        }
    }
    
}

#pragma mark 获取证件名称
-(NSString *) getCardName:(NSString *)code
{
    if([@"01" isEqualToString:code])
    {
        return @"身份证";
    }
    else if([@"02" isEqualToString:code])
    {
        return @"护照";
    }
    else if([@"03" isEqualToString:code])
    {
        return @"军官证";
    }
    else if([@"04" isEqualToString:code])
    {
        return @"其他证件";
    }
    else
    {
        return nil;
    }
}

#pragma mark 填充数据
-(void)setData
{
    if(nil == safeInfo)
    {
        return;
    }
    //类型：0 新建／1:缓存／2:补拍／3:补录
    if(currentType != 0)
    {
        NSMutableString *str = [[NSMutableString alloc] init];
        NSString *txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"safeno"];
        //保单号
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n保单号：%@",txt]];
        }
        txt = nil;
        
        NSString  *safecode = (NSString *)[safeInfo objectForKey:@"psafetypes"];
        if([@"001" isEqualToString:safecode])
        {
            txt = @"普通寿险";
            [safeInfo setValue:@"0" forKey:@"safetype"];
        }
        else if ([@"002" isEqualToString:safecode]) {
            txt = @"分红型寿险";
            [safeInfo setValue:@"0" forKey:@"safetype"];
        }
        else if ([@"003" isEqualToString:safecode]) {
            txt = @"投资连结保险";
            [safeInfo setValue:@"0" forKey:@"safetype"];
        }
        else if ([@"004" isEqualToString:safecode]) {
            txt = @"健康保险";
            [safeInfo setValue:@"0" forKey:@"safetype"];
        }
        else if ([@"005" isEqualToString:safecode]) {
            txt = @"万能保险";
            [safeInfo setValue:@"0" forKey:@"safetype"];
        }
        else if ([@"006" isEqualToString:safecode]) {
            txt = @"意外伤害保险";
            [safeInfo setValue:@"0" forKey:@"safetype"];
        }
        else if ([@"101" isEqualToString:safecode]) {
            txt = @"车险";
            [safeInfo setValue:@"1" forKey:@"safetype"];
        }
        else if ([@"102" isEqualToString:safecode]) {
            txt = @"家财险";
            [safeInfo setValue:@"1" forKey:@"safetype"];
        }
        else if ([@"103" isEqualToString:safecode]) {
            txt = @"责任险";
            [safeInfo setValue:@"1" forKey:@"safetype"];
        }
        else if ([@"104" isEqualToString:safecode]) {
            txt = @"意外险";
            [safeInfo setValue:@"1" forKey:@"safetype"];
        }
        else {
            txt = @"";
        }
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n险种：%@",txt]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"sname"];
        //投保人
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n投保人姓名：%@",txt]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"cardtype"];
        //投保人证件类型
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n投保人证件类型：%@",[self getCardName:txt]]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"cardno"];
        //投保人身份证:420202198989898988
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n投保人证件号：%@",txt]];
        }
        txt = nil;
        
        
        txt = (NSString *)[safeInfo objectForKey:@"pname"];
        //被保险人
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n被保险人姓名：%@",txt]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"pcardtype"];
        //被保险人证件类型
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n被保险人证件类型：%@",[self getCardName:txt]]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"pcardno"];
        //被保险人身份证
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n被保险人证件号：%@",txt]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"sex"];
        //性别：1 （1男0女）
        if([self dataIsOK:txt])
        {
            if([@"2" isEqualToString:txt])
            {
                [str appendString:[NSString stringWithFormat:@"\n投保人性别：女"]];
            }
            else if([@"1"  isEqualToString:txt])
            {
                [str appendString:[NSString stringWithFormat:@"\n投保人性别：男"]];
            }
            else
            {
                [str appendString:[NSString stringWithFormat:@"\n投保人性别：未知"]];
            }
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"age"];
        //年龄：25
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n投保人年龄：%@",txt]];
        }
        txt = nil;
        
        
        txt = (NSString *)[safeInfo objectForKey:@"safecost"];
        //保费：950 （单位：元）
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n保费(元)：%@",txt]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"psafepay"];
        //保额：5    （单位：元）
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n保额(元)：%@",txt]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"psafedate"];
        //保险始期
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n保险起期(年)：%@",txt]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"psafedateend"];
        //保险止期
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n保险止限(年)：%@",txt]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"pcarno"];
        // 车牌
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n车牌：%@",txt]];
        }
        txt = nil;
        
        txt = (NSString *)[safeInfo objectForKey:@"pwin"];
        // 车架号
        if([self dataIsOK:txt])
        {
            [str appendString:[NSString stringWithFormat:@"\n车架号：%@",txt]];
        }
        txt = nil;
        
        if(nil != contentLabel)
        {
            contentLabel.text = str;
        }
        
        contentLabel.height = [Util getSizeWithString:str textSize:14 width:contentLabel.width].height +50;
        
        if(nil != nextBtn)
        {
            nextBtn.enabled = true;
        }
        
        str = nil;
    }
}

#pragma mark 判断数据是否符合要求
-(BOOL)dataIsOK:(NSString *)txt
{
    if(txt != nil && ![@"" isEqualToString:txt] && ![@"null" isEqualToString:txt])
    {
        return true;
    }
    return false;
}

@end
