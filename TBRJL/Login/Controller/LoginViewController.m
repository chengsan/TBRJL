//
//  LoginViewController.m
//  TBRJL
//
//  Created by 程三 on 15/5/30.
//  Copyright (c) 2015年 程三. All rights reserved.
//


//    _userName.text = @"350701198610200159";
//    _passName.text = @"13751122150";

#import "LoginViewController.h"
#import "UIViewExt.h"
#import "TBRJL-Prefix.pch"
#import "MainViewController.h"
#import "WXHLDataService.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UserInfoModel.h"
#import "MJExtension.h"
#import "NSString+NSStringMD5.h"
#import "AFNetWorkService.h"
#import "Globle.h"
#import "Util.h"
#import "AppDelegate.h"
#import "CHSaveDataTool.h"
#import "MBProgressHUD+PKX.h"
#import "UIImage+Extension.h"
#import "QuestionViewController.h"

/**
 * 记住密码
 */
#define CHRmbPassword @"CHRmbPassword"

/**
 * 是否自动登录
 */
#define CHAutoLogin @"CHAutoLogin"
@interface LoginViewController ()
@property (nonatomic ,strong) UIButton *remPwdBtn;
@property (nonatomic ,strong) UIButton *autoLoginBtn;

@property (nonatomic ,strong)UIAlertView *myAlertView;
@end

@implementation LoginViewController

- (void)viewDidLoad
{

    [super viewDidLoad];

    //初始化Globle对象
    [self initGloble];
    self.view.backgroundColor = [UIColor colorWithRed:76/255.0 green:129/255.0 blue:190/255.0 alpha:1];
    isRemenber = false;
    isAutoLogin = false;
    _isLogin = NO;

    [self _initView];
    
    isRemenber= [CHSaveDataTool boolForkey:@"记住密码"];
    self.remPwdBtn.selected = isRemenber;
    isAutoLogin = [CHSaveDataTool boolForkey:@"自动登录"];
    self.autoLoginBtn.selected = isAutoLogin;
    
    NSString *leapAPPName = LeapAPPName;
    [self checkVersion:leapAPPName];
}

-(void)_initView
{
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:[UIImage imageNamed:@"login_set_icon.png"] forState:UIControlStateNormal];
    setBtn.frame = CGRectZero;
    int widthSet = 30;
    setBtn.top = 5 + StatusBarHeight;
    setBtn.width = widthSet;
    setBtn.height = widthSet;
    setBtn.left = ScreenWidth - widthSet - 5;
    setBtn.tag = 200;
    [setBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setBtn];
    
    int leftMarg = ScreenWidth/10;
    UIImageView *loginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon.png"]];
    loginImageView.frame = CGRectZero;
    loginImageView.left = leftMarg;
    loginImageView.right = leftMarg;
    loginImageView.top = ScreenHeight /5;
    loginImageView.width = 50;
    loginImageView.height = 60;
    loginImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:loginImageView];
    
    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectZero];
    appName.left = loginImageView.right + 5;
    appName.top = loginImageView.top;
    appName.width = ScreenWidth - appName.left - leftMarg;
    appName.height = loginImageView.height;
    appName.textAlignment = NSTextAlignmentCenter;
    appName.font = [UIFont systemFontOfSize:20];
    appName.text = @"福建省投保人纪录系统";
    appName.textColor = [UIColor whiteColor];
    appName.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:appName];
    
    //用户名
    UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [userIcon setImage:[UIImage imageNamed:@"loginbox_icon01"]];
    userIcon.left = leftMarg;
    userIcon.top = loginImageView.bottom + 30;
    userIcon.width = 26;
    userIcon.height = 26;
    userIcon.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:userIcon];
    
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(userIcon.right + 5, userIcon.top, ScreenWidth - userIcon.right - leftMarg, 30)];
    UIColor *color = [UIColor whiteColor];
    _userName.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName:color}];
    _userName.delegate = self;
//    _userName.text = @"350701198610200159";
    _userName.textColor = [UIColor whiteColor];
    UIImage *imageName = [UIImage imageNamed:@"loginEditBg"];
    imageName=[imageName stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [_userName setBackground:imageName];
    _userName.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    
    //设置左边距
    UIView *userLeftView = [[UIView alloc] initWithFrame:_userName.frame];
    userLeftView.width = 10;
    _userName.leftViewMode = UITextFieldViewModeAlways;
    _userName.leftView = userLeftView;
    [self.view addSubview:_userName];
    
    //密码
    UIImageView *passIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [passIcon setImage:[UIImage imageNamed:@"loginbox_icon02"]];
    passIcon.left = leftMarg;
    passIcon.top = userIcon.bottom + 20;
    passIcon.width = 26;
    passIcon.height = 26;
    passIcon.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:passIcon];
    
    _passName = [[UITextField alloc] initWithFrame:CGRectMake(passIcon.right + 5, passIcon.top, ScreenWidth - passIcon.right - leftMarg, 30)];
    _passName.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:color}];
    _passName.delegate = self;
//    _passName.text = @"123456";
    _passName.textColor = [UIColor whiteColor];
    _passName.secureTextEntry = YES;
    UIImage *imagePass = [UIImage imageNamed:@"loginEditBg"];
    imagePass=[imagePass stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [_passName setBackground:imagePass];
    _passName.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    
    //设置左边距
    UIView *passLeftView = [[UIView alloc] initWithFrame:_passName.frame];
    passLeftView.width = 10;
    _passName.leftViewMode = UITextFieldViewModeAlways;
    _passName.leftView = passLeftView;
    [self.view addSubview:_passName];
    
    //记住密码
    UIButton *remenberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [remenberBtn setImage:[UIImage imageNamed:@"pass_unsd"] forState:UIControlStateNormal];
    [remenberBtn setImage:[UIImage imageNamed:@"pass_sd"] forState:UIControlStateSelected];
    remenberBtn.tag = 100;
    remenberBtn.left = leftMarg;
    remenberBtn.top =passIcon.bottom + 30;
    remenberBtn.width = 20;
    remenberBtn.height = 20;
    remenberBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [remenberBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remenberBtn];
    
    UILabel *remTitle = [[UILabel alloc] initWithFrame:CGRectMake(remenberBtn.right+5, remenberBtn.top-10, 80, 40)];
    remTitle.text = @"记住密码";
    remTitle.font = [UIFont systemFontOfSize:16];
    remTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:remTitle];
    self.remPwdBtn = remenberBtn;
    
    //自动登录
    UIButton *loginAutoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginAutoBtn setImage:[UIImage imageNamed:@"pass_unsd"] forState:UIControlStateNormal];
    [loginAutoBtn setImage:[UIImage imageNamed:@"pass_sd"] forState:UIControlStateSelected];
    loginAutoBtn.tag = 101;
    loginAutoBtn.top =passIcon.bottom + 30;
    loginAutoBtn.width = 20;
    loginAutoBtn.height = 20;
    loginAutoBtn.left = ScreenWidth - loginAutoBtn.width - remTitle.width - leftMarg;
    loginAutoBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [loginAutoBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginAutoBtn];
    self.autoLoginBtn = loginAutoBtn;
    
    UILabel *loginAutoTitle = [[UILabel alloc] initWithFrame:CGRectMake(loginAutoBtn.right+5, loginAutoBtn.top-10, 80, 40)];
    loginAutoTitle.text = @"自动登录";
    loginAutoTitle.font = [UIFont systemFontOfSize:16];
    loginAutoTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:loginAutoTitle];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@" 登 录 " forState:UIControlStateNormal];
    loginBtn.tag = 102;
    loginBtn.frame = CGRectZero;
    loginBtn.left = leftMarg;
    loginBtn.right = leftMarg;
    loginBtn.top = loginAutoBtn.bottom + 30;
    loginBtn.width = ScreenWidth - loginBtn.left - loginBtn.right;
    loginBtn.height = 40;
    UIImage *img = [UIImage resizeImgWithName:@"login_bg.png"];
//    img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    
    [loginBtn setBackgroundImage:img forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    loginBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                    UIViewAutoresizingFlexibleHeight;
    [loginBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *questionBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginAutoBtn.frame), loginBtn.bottom +20, 80, 40)];
    [questionBtn setTitle:@"常见问题" forState:UIControlStateNormal];
    questionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [questionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [questionBtn addTarget:self action:@selector(questionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBtn];
    
    
    
    UILabel *createOrg = [[UILabel alloc] initWithFrame:CGRectZero];
    createOrg.left = leftMarg;
    createOrg.right = leftMarg;
    createOrg.top = ScreenHeight - 60;
    createOrg.width = ScreenWidth - leftMarg*2;
    createOrg.height = 20;
    createOrg.text = @"福建省保险行业协会监制";
    createOrg.font = [UIFont systemFontOfSize:13];
    createOrg.textAlignment = NSTextAlignmentCenter;
    createOrg.textColor = [UIColor whiteColor];
    [self.view addSubview:createOrg];
    
    UILabel *technicalSupport = [[UILabel alloc] initWithFrame:CGRectZero];
    technicalSupport.text = @"深圳市永兴元科技有限公司提供技术支持";
    technicalSupport.font = [UIFont systemFontOfSize:13];
    technicalSupport.left = leftMarg;
    technicalSupport.right = leftMarg;
    technicalSupport.top = ScreenHeight - 40;
    technicalSupport.width = ScreenWidth - leftMarg*2;
    technicalSupport.height = 20;
    technicalSupport.textAlignment = NSTextAlignmentCenter;
    technicalSupport.textColor = [UIColor whiteColor];
    [self.view addSubview:technicalSupport];
    
}


-(void)questionBtnClick{
     [[BaiduMobStat defaultStat] logEvent:@"common-problem" eventLabel:@"常见问题"];
    QuestionViewController *questionVc  = [[QuestionViewController alloc] init];
    [self presentViewController:questionVc animated:YES completion:NULL];
    [questionVc dismiss];
}


#pragma mark Action
-(void)onClick:(UIButton *)btn
{
    if(btn != nil)
    {
        int tag = (int)btn.tag;
        switch (tag) {
            case 100:
            {
                btn.selected = !btn.selected;
//                如果记住密码没选中
                if (!btn.selected) {
//                    自动登录也不要选中
                    self.autoLoginBtn.selected = NO;
                }
            }
                break;
            case 101:
            {
                btn.selected = !btn.selected;
//                 如果是自动登录选中
                if (btn.selected) {
//                     记住密码也要选中
                    self.remPwdBtn.selected = YES;
                }
            }
                break;
            case 102:           //  点击登录
            {
                
                [self loginBtnClick];
            }
           
                break;
                
            case 200:
            {
                [[BaiduMobStat defaultStat] logEvent:@"Set-app" eventLabel:@"APP设置"];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate.menuController showRightController:true];
            }
                break;
            default:
                break;
        }
    }
}


//   登陆
-(void)loginBtnClick{
    
   [[BaiduMobStat defaultStat] logEvent:@"login" eventLabel:@"登陆"];
    
    self.userNameStr = self.userName.text;
    self.passwordStr = self.passName.text;
    NSString *noticeStr = nil;
    //登录
    
    if(_userNameStr.length == 0 || _userNameStr == nil)
    {
        noticeStr = @"用户名不能为空";
        [self showNotice:noticeStr];
        return;
    }
    
    if(_passwordStr.length == 0 || _passwordStr == nil)
    {
        noticeStr = @"密码不能为空";
        [self showNotice:noticeStr];
        return;
    }
    [MBProgressHUD showMessage:@"正在登陆"];
    
    NSString *isOffline = (NSString *)[Util getValue:@"offline"];
    if ([isOffline isEqualToString:@"1"]) {      //  如果是离线
        [MBProgressHUD hideHUD];
        NSLog(@"离线登录");
        NSString *userName = (NSString *)[Util getValue:CHAccount];
        NSString *passName = (NSString *)[Util getValue:CHPassword];
        if ([_userNameStr isEqualToString: userName] && [_passwordStr isEqualToString: passName]) {
             MainViewController *mainCTRL = [[MainViewController alloc] init];
             self.view.window.rootViewController = mainCTRL;
        }else{
             [MBProgressHUD showError:@"用户名或密码错误"];
        }
        
    }else{
        //开始登陆
        NSLog(@"在线登录");
        [self login:_userNameStr pass:_passwordStr];
    }
    
}

//    保存用户登陆数据
-(void)saveUserData{
    _isLogin = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.autoLoginBtn.selected forKey:@"自动登录"];
    [defaults setBool:self.remPwdBtn.selected forKey:@"记住密码"];
    [defaults setObject:self.userName.text forKey:CHAccount];

    [defaults setObject:self.passName.text forKey:CHPassword];
    [defaults setBool:_isLogin forKey:@"register"];
    
    
    
}




//  设置数据
-(void)loadUserData{
    
    // 获得NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL rmbPassword = [defaults boolForKey:@"记住密码"];
    self.remPwdBtn.selected = rmbPassword;
    if (rmbPassword) { // 如果是记住密码
        // 获得密码
        self.passName.text =  [defaults objectForKey:CHPassword];
    }
    // 给账号输入框赋值
    self.userName.text = [defaults objectForKey:CHAccount];
    
    BOOL autoLogin = [defaults boolForKey:@"自动登录"];
    self.autoLoginBtn.selected = autoLogin;
    if (autoLogin) { // 如果是自动登录
        
         [self loginBtnClick];
    }
}


#pragma mark 提示方法
-(void)showNotice:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)login:(NSString *)name pass:(NSString *)pass
{
   
    //NSString *url = @"http://211.154.145.81:977/restservices/leap/BBTone_LoginIOS/query";
    //NSString *url = @"http://fjisip.yxybb.com/restservices/leap//query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:name forKey:@"cardno"];
    [params setObject:[pass md5] forKey:@"pwd"];
    
  
    [[Globle getInstance].service requestWithServiceName:@"BBTone_LoginIOS" params:params httpMethod:@"POST" resultIsDictionary:false completeBlock:^(id result)
    {
        [MBProgressHUD hideHUD];
        NSString *str = [NSString stringWithFormat:@"%@",result];
        
        if([@"true" isEqualToString:str])
        {
            //获取用户信息
            [self getUserInfo:name];
          
        }
        else
        {
            [MBProgressHUD showError:@"用户名或密码错误"];

        }
    }];

}


-(void)getUserInfo:(NSString *)cardNumber
{
    
    if(cardNumber == nil || cardNumber.length == 0)
    {
        return;
    }
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:cardNumber forKey:@"cardno"];
    
    [[Globle getInstance].service requestWithServiceName:@"BBTone_getUserInfo" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result)
    {
        
        if(result == nil)
        {
            [_alertView dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户信息获取失败，请检查后台用户信息是否完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            NSLog(@"%@",result);
           
            [Globle getInstance].userInfoDic = result;
            
            [Util setObject:cardNumber key:@"username"];
             NSString *areaid = result[@"areaid"];
            [Util setObject:areaid key:@"areaid"];
            [Util setObject:result key:@"userInfo"];
            NSString *workName = result[@"name"];
            [Util setObject:workName key:@"workname"];
            [Util setObject:result[@"orgname"] key:@"orgname"];
            [Util setObject:result[@"id"] key:@"id"];
            
            
            NSString *content = [NSString stringWithFormat:@"%@",result];
            
            /*
            //获取Document路径
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            //建立自己的目录
            path = [path stringByAppendingPathComponent:@"userInfo"];
            //文件名
            NSString *fileName = [NSString stringWithFormat:@"%@.text",[[Globle getInstance].userInfoDic objectForKey:@"cardno"]];
            */
            
            NSString *path = UserInfoDic;
            NSString *fileName = (NSString *)[Util getValue:@"username"];
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
             
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //判断目录是否存在的，不存在就建立
            if(![fileManager fileExistsAtPath:path])
            {
                BOOL b = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
                if(b)
                {
                     NSLog(@"创建目录成功");
                }
                else
                {
                    NSLog(@"创建目录失败");
                }
            }
            
            //判断文件是否存在
            if([fileManager fileExistsAtPath:fullPath])
            {
                //存在久删除
                [fileManager removeItemAtPath:fullPath error:nil];
            }
            
            BOOL deleteSucess = [fileManager createFileAtPath:fullPath contents:nil attributes:nil];
            if(deleteSucess)
            {
                NSLog(@"创建文件成功");
            }
            else
            {
                NSLog(@"创建文件失败");
            }
//            
            BOOL b = [content writeToFile:[path stringByAppendingPathComponent:fileName] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            if(!b)
            {
                UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户信息写入失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [aler show];
                return;
            }
            
            [self getUserComparnyInfo:[result objectForKey:@"areaid"] cardNo:cardNumber];
            
        }
    }];
}

//获取配置文件
-(void)getUserComparnyInfo:(NSString *)areaid cardNo:(NSString *)cardno
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:areaid forKey:@"areaid"];
    [params setObject:cardno forKey:@"cardno"];
    
    [[Globle getInstance].service requestWithServiceName:@"BBTone_getConfigData" params:params httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result)
    {
        [_alertView dismiss];
        if(result == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取配置文件失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSArray *array = (NSArray *)result;
        
        if(array == nil || array.count == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"配置信息获取失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
            return;
        }
            
        //将配置文件写入本地
        NSString *dicPath = ComparyInfoDic;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:dicPath])
        {
            BOOL sucess = [fileManager createDirectoryAtPath:dicPath withIntermediateDirectories:YES attributes:nil error:nil];
            if(!sucess)
            {
                return;
            }
        }
        NSString *fileName = [NSString stringWithFormat:@"%@",cardno];
        NSString *fullPath = [dicPath stringByAppendingPathComponent:fileName];
        if([fileManager fileExistsAtPath:fullPath])
        {
            [fileManager removeItemAtPath:fullPath error:nil];
        }
        
      
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
              BOOL b = [array writeToFile:fullPath atomically:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(!b)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"配置信息写入失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
                    [alert show];
                    return;
                }else{
                    NSLog(@"配置文件写入成功");
                    
                    //        保存数据
                    [self saveUserData];
                    
                    MainViewController *mainCTRL = [[MainViewController alloc] init];
                    self.view.window.rootViewController = mainCTRL;
                }
            });
            
        });

    }];
    
}



//初始化Globle
-(void)initGloble
{
    //取出url
    NSString *serviceURL = (NSString *)[Util  getValue:@"serviceURL"];
    if (serviceURL.length == 0 || serviceURL== nil) {
        [Globle getInstance].serviceURL = ServiceURL;
    }else{
        [Globle getInstance].serviceURL = serviceURL;
    }
    
    [Globle getInstance].updateURL = UpdateURL;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
}
#pragma mark UITextField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _userName)
    {
        _userNameStr = textField.text;
    }
    else if(textField == _passName)
    {
        _passwordStr = textField.text;
    }

    NSLog(@"失去焦点");
}


#pragma mark 检测版本号
-(void)checkVersion:(NSString *)leapAPPname
{
    if(leapAPPname != nil)
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:leapAPPname forKey:@"appname"];
        
        [[Globle getInstance].service requestWithServiceName:@"lbcp_getAppVersion" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result) {
            
            NSLog(@"result:%@",result);
            
            NSDictionary *dic = (NSDictionary *)result;
            if(nil != dic)
            {
                [MBProgressHUD hideHUD];
                //获取本地版本
                NSString *localVersion = VersionCode;
                NSLog(@"当前版本号%@",localVersion);
                int localVersionNUm = (localVersion == nil ? -1 : [localVersion intValue]);
                //获取服务器版本
                NSString *serverVersion = [dic valueForKey:@"appversion"];
                NSLog(@"服务器版本%@",serverVersion);
                cdnpath = [dic valueForKey:@"cdnpath"];
                int serverVersionNum = (serverVersion == nil ? -1 : [serverVersion intValue]);
                //判断是非升级
                if(localVersionNUm < serverVersionNum)
                {
                    NSString *upgrade = [dic valueForKey:@"upgrade"];
                    if([@"1" isEqualToString:upgrade])    //   强制升级
                    {
                        self.myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"有新的版本，请及时更新。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    }
                    else
                    {
                        self.myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"有新的版本，请及时更新。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
                    }
                    
                    if(nil != cdnpath && ![@"" isEqualToString:cdnpath])
                    {
                        [self.myAlertView show];
                    }
                    
                }
            }
            
        }];
    }
}


#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.myAlertView)
    {
        if(buttonIndex == 0)
        {
            NSString *urlStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",cdnpath];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
    }
}

// 进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
    [self loadUserData];
}

// 退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}



@end
