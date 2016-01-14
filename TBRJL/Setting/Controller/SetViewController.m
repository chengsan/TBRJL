//
//  SetViewController.m
//  TBRJL
//
//  Created by 程三 on 15/6/2.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "SetViewController.h"
#import "UIViewExt.h"
#import "TBRJL-Prefix.pch"
#import "SZViewController.h"
#import "AboutViewController.h"
#import "Globle.h"
#import "Util.h"
#import "MBProgressHUD+PKX.h"
@interface SetViewController ()
@property (nonatomic ,strong) UILabel *rightLabel;
@end

@implementation SetViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setTitle:@"系统设置"];
    self.view.backgroundColor = [[UIColor alloc] initWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    
    [self _initView];
}

-(void)_initView
{
    //------------------------设置navigationBar---------------------------
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TbpLogo.png"]];
    leftImage.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UILabel *rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    _rightLabel = rightTitle;
       
    rightTitle.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightTitle];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    //------------------------------用户信息显示-----------------------------------
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectZero];
    userInfoView.width = ScreenWidth;
    userInfoView.height = 80;
    userInfoView.left = 0;
    userInfoView.top = 20;
    [self.view addSubview:userInfoView];
    
    //设置背景
    UIImageView *bg = [[UIImageView alloc] initWithFrame:userInfoView.bounds];
    bg.image = [UIImage imageNamed:@"tbsy_btn_bg_normal.png"];
    [userInfoView addSubview:bg];
    
    //用户头像
    UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    userIcon.width = 60;
    userIcon.height = 60;
    userIcon.left = 20;
    userIcon.top = (userInfoView.height - userIcon.height)/2;
    userIcon.image = [UIImage imageNamed:@"set_person_icon.png"];
    //设置图片为圆角
    userIcon.layer.cornerRadius = 5;//半径
    userIcon.layer.borderWidth = 1;//设置边框
    userIcon.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    //设置显示边框
    userIcon.layer.masksToBounds = YES;
    [userInfoView addSubview:userIcon];
    
    //用户名
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectZero];
    userName.left = userIcon.right + 20;
    userName.width = userInfoView.width - userName.left;
    userName.height = 20;
    userName.text = @"保宝通测试2";
    userName.textColor = [UIColor blackColor];
    userName.font = [UIFont systemFontOfSize:16];
    [userInfoView addSubview:userName];
    
    //公司名称
    UILabel *orgName = [[UILabel alloc] initWithFrame:CGRectZero];
    orgName.left = userName.left;
    orgName.width = userName.width;
    orgName.height = 20;
    orgName.text = @"福建三木有限公司";
    orgName.textColor = [UIColor grayColor];
    orgName.font = [UIFont systemFontOfSize:13];
    [userInfoView addSubview:orgName];
    
    userName.top = (userInfoView.height - userName.height - orgName.height)/2;
    orgName.top = userName.bottom;
    
    
    //图片的宽度和高度
    int iconWidth = 35;
    //－－－－－－－－－－－－－设置－－－－－－－－－－－－
    UIButton *setView = [UIButton buttonWithType:UIButtonTypeCustom];
    setView.frame = CGRectMake(0, userInfoView.bottom + 20, ScreenWidth, 50);
    [setView setBackgroundImage:[UIImage imageNamed:@"tbsy_home_btn_bg.png"] forState:UIControlStateNormal];
    //[setView setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_selected.png"] forState:UIControlStateHighlighted];
    setView.tag = 100;
    [setView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setView];
    
    UIImageView *setImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_panel_set_icon.png"]];
    setImageView.frame = CGRectZero;
    setImageView.width = iconWidth;
    setImageView.height = iconWidth;
    setImageView.left = 20;
    setImageView.top = (setView.height - setImageView.height)/2;
    [setView addSubview:setImageView];
    
    UILabel *setLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    setLabel.left = setImageView.right + 10;
    setLabel.width = setView.width - setLabel.left;
    setLabel.height = 20;
    setLabel.top = (setView.height - setLabel.height)/2;
    setLabel.text = @"设置";
    setLabel.textColor = [UIColor blackColor];
    setLabel.font = [UIFont systemFontOfSize:15];
    [setView addSubview:setLabel];

    
    //－－－－－－－－－－－－－更新配置文件－－－－－－－－－－－－
    UIButton *upadateFileView = [UIButton buttonWithType:UIButtonTypeCustom];
    upadateFileView.frame = CGRectMake(0, setView.bottom + 20, ScreenWidth, 50);
    [upadateFileView setBackgroundImage:[UIImage imageNamed:@"tbsy_home_btn_bg.png"] forState:UIControlStateNormal];
    //[upadateFileView setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_selected.png"] forState:UIControlStateHighlighted];
    upadateFileView.tag = 101;
    [upadateFileView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upadateFileView];
    
    UIImageView *upadateFileImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_panel_dialog_icon.png"]];
    upadateFileImageView.frame = CGRectZero;
    upadateFileImageView.width = iconWidth;
    upadateFileImageView.height = iconWidth;
    upadateFileImageView.left = 20;
    upadateFileImageView.top = (upadateFileView.height - upadateFileImageView.height)/2;
    [upadateFileView addSubview:upadateFileImageView];
    
    UILabel *upadateFileLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    upadateFileLabel.left = upadateFileImageView.right + 10;
    upadateFileLabel.width = upadateFileView.width - upadateFileLabel.left;
    upadateFileLabel.height = 20;
    upadateFileLabel.top = (upadateFileView.height - upadateFileLabel.height)/2;
    upadateFileLabel.text = @"更新配置文件";
    upadateFileLabel.textColor = [UIColor blackColor];
    upadateFileLabel.font = [UIFont systemFontOfSize:15];
    [upadateFileView addSubview:upadateFileLabel];
    
    //－－－－－－－－－－－－－关于－－－－－－－－－－－－
    UIButton *aboutView = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutView.frame = CGRectMake(0, upadateFileView.bottom + 20, ScreenWidth, 50);
    [aboutView setBackgroundImage:[UIImage imageNamed:@"tbsy_home_btn_bg.png"] forState:UIControlStateNormal];
    //[aboutView setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_selected.png"] forState:UIControlStateHighlighted];
    aboutView.tag = 102;
    [aboutView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutView];
    
    UIImageView *aboutImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_panel_about_icon.png"]];
    aboutImageView.frame = CGRectZero;
    aboutImageView.width = iconWidth;
    aboutImageView.height = iconWidth;
    aboutImageView.left = 20;
    aboutImageView.top = (aboutView.height - aboutImageView.height)/2;
    [aboutView addSubview:aboutImageView];
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    aboutLabel.height = 20;
    aboutLabel.left = aboutImageView.right + 10;
    aboutLabel.width = aboutView.width - aboutLabel.left;
    aboutLabel.top = (aboutView.height - aboutLabel.height)/2;
    aboutLabel.text = @"关于";
    aboutLabel.textColor = [UIColor blackColor];
    aboutLabel.font = [UIFont systemFontOfSize:15];
    [aboutView addSubview:aboutLabel];

}

-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == 100) {        //  设置
        SZViewController *szVC = [[SZViewController alloc] init];
        [self.navigationController pushViewController:szVC animated:YES];
        
    }else if(btn.tag == 102){    //  关于
        AboutViewController *aboutVc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVc animated:YES];
        
    }else if(btn.tag == 101){
        NSString *cardno = (NSString *)[Util getValue:@"username"];
        NSString *areaid = (NSString *)[Util getValue:@"areaid"];
        
        [MBProgressHUD showMessage:@"正在更新配置文件"];
        NSString *isOffline = (NSString *)[Util getValue:@"offline"];
        if ([isOffline isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您目前的状态是离线，请在有网的状态下登陆尝试更新." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

        }else{
            //        更新配置文件
            [self updateComparnyInfo:areaid cardNo:cardno];
        }
       
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *isOffline = (NSString *)[Util getValue:@"offline"];
    if ([isOffline isEqualToString:@"1"]) {
        _rightLabel.text = @"离线登录";
        _rightLabel.textColor = [UIColor blackColor];
        
    }else{
        _rightLabel.text = @"在线登陆";
        _rightLabel.textColor = [UIColor redColor];
    }
}


//更新配置文件
-(void)updateComparnyInfo:(NSString *)areaid cardNo:(NSString *)cardno
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:areaid forKey:@"areaid"];
    [params setObject:cardno forKey:@"cardno"];
    
    [[Globle getInstance].service requestWithServiceName:@"BBTone_getConfigData" params:params httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result)
     {
         [MBProgressHUD hideHUD];
         NSLog(@"%@",result);
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
         
         BOOL b = [array writeToFile:fullPath atomically:YES];
         
         
         if(!b)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"配置信息写入失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
             [alert show];
             return;
         }else{
             [MBProgressHUD showSuccess:@"已更新为最新"];
         }
     }];
    
}


@end
