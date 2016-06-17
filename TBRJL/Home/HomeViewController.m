//
//  HomeViewController.m
//  TBRJL
//
//  Created by 程三 on 15/6/2.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewExt.h"
#import "TBRJL-Prefix.pch"
#import "HistoryViewController.h"
#import "SelectCompanryController.h"
#import "Util.h"
#import "BLXXViewController.h"
#import "BPXXViewController.h"
#import "ZCViewController.h"
#import "SearchParameters.h"
#import "QueryViewController.h"
#import "NSString+NSStringMD5.h"
#import "EntityBean.h"

@interface HomeViewController ()
@property (nonatomic ,strong)UIButton *zcswIcon;
@property (nonatomic ,strong)UIButton *bpyxIcon;
@property (nonatomic ,strong)UIButton *blxxIcon;
@property (nonatomic ,strong)UILabel *rightLabel;
@end

@implementation HomeViewController

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
    [super setTitle:@"办公管理"];
    self.view.backgroundColor = [[UIColor alloc] initWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];

    [self _initView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)_initView
{
    
    //设置左边按钮
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TbpLogo.png"]];
    leftImage.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftItem;
    

    
    //设置右边按钮
    UILabel *rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    self.rightLabel = rightTitle;

    
    rightTitle.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightTitle];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //图片的宽度和高度
    int iconWidth = 35;
    //－－－－－－－－－－－－－投保摄影－－－－－－－－－－－－
    UIButton *tbsyView = [UIButton buttonWithType:UIButtonTypeCustom];
    tbsyView.frame = CGRectMake(0, 20, ScreenWidth, 50);
    [tbsyView setBackgroundImage:[UIImage imageNamed:@"tbsy_home_btn_bg.png"] forState:UIControlStateNormal];
    //[tbsyView setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_selected"] forState:UIControlStateHighlighted];
    tbsyView.tag = 100;
    [tbsyView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tbsyView];
    
    UIImageView *tbsyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainpage_create_phone.png"]];
    tbsyImageView.frame = CGRectZero;
    tbsyImageView.width = iconWidth;
    tbsyImageView.height = iconWidth;
    tbsyImageView.left = 20;
    tbsyImageView.top = (tbsyView.height - tbsyImageView.height)/2;
    [tbsyView addSubview:tbsyImageView];
    UILabel *tbsyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tbsyLabel.width = 70;
    tbsyLabel.height = 20;
    tbsyLabel.left = tbsyImageView.right + 10;
    tbsyLabel.top = (tbsyView.height - tbsyLabel.height)/2;
    tbsyLabel.textAlignment = NSTextAlignmentCenter;
    tbsyLabel.text = @"投保摄影";
    tbsyLabel.textColor = [UIColor blackColor];
    tbsyLabel.font = [UIFont systemFontOfSize:15];
    [tbsyView addSubview:tbsyLabel];
    
    UIButton *numIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    numIcon.frame = CGRectZero;
    numIcon.width = 20;
    numIcon.height = 15;
    numIcon.top = (tbsyView.height - numIcon.height)/2;
    numIcon.left = tbsyView.width - numIcon.width - 10;
//    [numIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateNormal];
//    [numIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateHighlighted];
//    [numIcon setTitle:@"8" forState:UIControlStateNormal];
    numIcon.titleLabel.textColor = [UIColor whiteColor];
    numIcon.titleLabel.font = [UIFont systemFontOfSize:13];
    //按钮不接受任何事件
    [numIcon setUserInteractionEnabled:YES];
    numIcon.hidden = YES;
    [tbsyView addSubview:numIcon];
    
    
    
    //－－－－－－－－－－－－暂存事务－－－－－－－－－－－－
    UIButton *zcswView = [UIButton buttonWithType:UIButtonTypeCustom];
    zcswView.frame = CGRectMake(0, tbsyView.bottom + 20, ScreenWidth, 50);
    [zcswView setBackgroundImage:[UIImage imageNamed:@"tbsy_home_btn_bg.png"] forState:UIControlStateNormal];
    //[zcswView setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_selected"] forState:UIControlStateHighlighted];
    zcswView.tag = 101;
    [zcswView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zcswView];
    
    UIImageView *zcswImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tbsy_2.png"]];
    zcswImageView.frame = CGRectZero;
    zcswImageView.width = iconWidth;
    zcswImageView.height = iconWidth;
    zcswImageView.left = 20;
    zcswImageView.top = (zcswView.height - zcswImageView.height)/2;
    [zcswView addSubview:zcswImageView];
    
    UILabel *zcswLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    zcswLabel.width = 70;
    zcswLabel.height = 20;
    zcswLabel.left = zcswImageView.right + 10;
    zcswLabel.top = (zcswView.height - zcswLabel.height)/2;
    zcswLabel.textAlignment = NSTextAlignmentCenter;
    zcswLabel.text = @"暂存事务";
    zcswLabel.textColor = [UIColor blackColor];
    zcswLabel.font = [UIFont systemFontOfSize:15];
    [zcswView addSubview:zcswLabel];
    
    UIButton *zcswIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    zcswIcon.frame = CGRectZero;
    zcswIcon.width = 20;
    zcswIcon.height = 15;
    zcswIcon.top = (zcswView.height - zcswIcon.height)/2;
    zcswIcon.left = zcswView.width - zcswIcon.width - 10;
//    [zcswIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateNormal];
//    [zcswIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateHighlighted];
//    [zcswIcon setTitle:@"8" forState:UIControlStateNormal];
    zcswIcon.titleLabel.textColor = [UIColor whiteColor];
    zcswIcon.titleLabel.font = [UIFont systemFontOfSize:13];
    _zcswIcon = zcswIcon;
    //按钮不接受任何事件
    [zcswIcon setUserInteractionEnabled:YES];
    [zcswView addSubview:zcswIcon];
    
    
    //－－－－－－－－－－－－补拍影像－－－－－－－－－－－－
    UIButton *bpyxView = [UIButton buttonWithType:UIButtonTypeCustom];
    bpyxView.frame = CGRectMake(0, zcswView.bottom + 20, ScreenWidth, 50);
    [bpyxView setBackgroundImage:[UIImage imageNamed:@"tbsy_home_btn_bg.png"] forState:UIControlStateNormal];
    //[bpyxView setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_selected"] forState:UIControlStateHighlighted];
    bpyxView.tag = 102;
    [bpyxView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bpyxView];
    
    UIImageView *bpyxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainpage_create_deal.png"]];
    bpyxImageView.frame = CGRectZero;
    bpyxImageView.width = iconWidth;
    bpyxImageView.height = iconWidth;
    bpyxImageView.left = 20;
    bpyxImageView.top = (bpyxView.height - bpyxImageView.height)/2;
    [bpyxView addSubview:bpyxImageView];
    
    UILabel *bpyxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bpyxLabel.width = 70;
    bpyxLabel.height = 20;
    bpyxLabel.left = bpyxImageView.right + 10;
    bpyxLabel.top = (bpyxView.height - bpyxLabel.height)/2;
    bpyxLabel.textAlignment = NSTextAlignmentCenter;
    bpyxLabel.text = @"补拍影像";
    bpyxLabel.textColor = [UIColor blackColor];
    bpyxLabel.font = [UIFont systemFontOfSize:15];
    [bpyxView addSubview:bpyxLabel];
    
    UIButton *bpyxIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    bpyxIcon.frame = CGRectZero;
    bpyxIcon.width = 20;
    bpyxIcon.height = 15;
    bpyxIcon.top = (bpyxView.height - bpyxIcon.height)/2;
    bpyxIcon.left = bpyxView.width - bpyxIcon.width - 10;
//    [bpyxIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateNormal];
//    [bpyxIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateHighlighted];
//    [bpyxIcon setTitle:@"8" forState:UIControlStateNormal];
    bpyxIcon.titleLabel.textColor = [UIColor whiteColor];
    bpyxIcon.titleLabel.font = [UIFont systemFontOfSize:13];
    //按钮不接受任何事件
    [bpyxIcon setUserInteractionEnabled:YES];
    _bpyxIcon = bpyxIcon;
    [bpyxView addSubview:bpyxIcon];
    
    
    
    //－－－－－－－－－－－－补录信息－－－－－－－－－－－－
    UIButton *blxxView = [UIButton buttonWithType:UIButtonTypeCustom];
    blxxView.frame = CGRectMake(0, bpyxView.bottom + 20, ScreenWidth, 50);
    [blxxView setBackgroundImage:[UIImage imageNamed:@"tbsy_home_btn_bg.png"] forState:UIControlStateNormal];
    //[blxxView setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_selected"] forState:UIControlStateHighlighted];
    blxxView.tag = 103;
    [blxxView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blxxView];
    
    UIImageView *blxxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainpage_create_ofice.png"]];
    blxxImageView.frame = CGRectZero;
    blxxImageView.width = iconWidth;
    blxxImageView.height = iconWidth;
    blxxImageView.left = 20;
    blxxImageView.top = (blxxView.height - blxxImageView.height)/2;
    [blxxView addSubview:blxxImageView];
    
    UILabel *blxxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    blxxLabel.width = 70;
    blxxLabel.height = 20;
    blxxLabel.left = blxxImageView.right + 10;
    blxxLabel.top = (blxxView.height - blxxLabel.height)/2;
    blxxLabel.textAlignment = NSTextAlignmentCenter;
    blxxLabel.text = @"补录信息";
    blxxLabel.textColor = [UIColor blackColor];
    blxxLabel.font = [UIFont systemFontOfSize:15];
    [blxxView addSubview:blxxLabel];
    
    UIButton *blxxIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    blxxIcon.frame = CGRectZero;
    blxxIcon.width = 20;
    blxxIcon.height = 15;
    blxxIcon.top = (blxxView.height - blxxIcon.height)/2;
    blxxIcon.left = blxxView.width - blxxIcon.width - 10;
//    [blxxIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateNormal];
//    [blxxIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateHighlighted];
//    [blxxIcon setTitle:@"8" forState:UIControlStateNormal];
    blxxIcon.titleLabel.textColor = [UIColor whiteColor];
    blxxIcon.titleLabel.font = [UIFont systemFontOfSize:13];
    //按钮不接受任何事件
    [blxxIcon setUserInteractionEnabled:YES];
    _blxxIcon = blxxIcon;
    [blxxView addSubview:blxxIcon];

    
    //－－－－－－－－－－－－查询事务－－－－－－－－－－－－
    UIButton *cxswView = [UIButton buttonWithType:UIButtonTypeCustom];
    cxswView.frame = CGRectMake(0, blxxView.bottom + 20, ScreenWidth, 50);
    [cxswView setBackgroundImage:[UIImage imageNamed:@"tbsy_home_btn_bg.png"] forState:UIControlStateNormal];
    //[cxswView setBackgroundImage:[UIImage imageNamed:@"tbsy_btn_bg_selected"] forState:UIControlStateHighlighted];
    cxswView.tag = 104;
    [cxswView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cxswView];
    
    UIImageView *cxswImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainpage_create_query.png"]];
    cxswImageView.frame = CGRectZero;
    cxswImageView.width = iconWidth;
    cxswImageView.height = iconWidth;
    cxswImageView.left = 20;
    cxswImageView.top = (cxswView.height - cxswImageView.height)/2;
    [cxswView addSubview:cxswImageView];
    
    UILabel *cxswLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    cxswLabel.width = 70;
    cxswLabel.height = 20;
    cxswLabel.left = cxswImageView.right + 10;
    cxswLabel.top = (cxswView.height - cxswLabel.height)/2;
    cxswLabel.textAlignment = NSTextAlignmentCenter;
    cxswLabel.text = @"查询事务";
    cxswLabel.textColor = [UIColor blackColor];
    cxswLabel.font = [UIFont systemFontOfSize:15];
    [cxswView addSubview:cxswLabel];
    
    UIButton *cxswIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    cxswIcon.frame = CGRectZero;
    cxswIcon.width = 20;
    cxswIcon.height = 15;
    cxswIcon.top = (cxswView.height - cxswIcon.height)/2;
    cxswIcon.left = cxswView.width - cxswIcon.width - 10;
//    [cxswIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateNormal];
//    [cxswIcon setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateHighlighted];
//    [cxswIcon setTitle:@"8" forState:UIControlStateNormal];
    cxswIcon.titleLabel.textColor = [UIColor whiteColor];
    cxswIcon.titleLabel.font = [UIFont systemFontOfSize:13];
    //按钮不接受任何事件
    [cxswIcon setUserInteractionEnabled:YES];
    cxswIcon.hidden = YES;
    [cxswView addSubview:cxswIcon];


    
}


//  视图即将显示
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *isOffline = (NSString *)[Util getValue:@"offline"];
    if ([isOffline isEqualToString:@"1"]) {
        self.rightLabel.text = @"离线登录";
        self.rightLabel.textColor = [UIColor blackColor];
    }else{
        self.rightLabel.text = @"在线登陆";
        self.rightLabel.textColor = [UIColor redColor];
        [self login:(NSString *)[Util getValue:CHAccount] pass:(NSString *)[Util getValue:CHPassword]];
    }
    
    [self getBuPaiCount];
    [self getBuluCount];
    
    NSString *userid = (NSString *)[Util getValue:CHAccount];
    
    NSMutableArray *arr = [self getPolicyDataWithUserID:userid];
    //
    arr = arr.count>0?arr: [self getMatchData];
    
   [self setBtn:_zcswIcon WithCount:arr.count];
    
    
   }

#pragma mark 单击事件方法
-(void)btnAction:(UIButton *)btn
{
    int tag = (int)btn.tag;
    switch (tag)
    {
        case 100:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"福建省保险行业协会友情提示:根据您投保意愿,保险销售人员将对您投保签名进行影像采集;为了保障您的合法权益,所以采集的影像只作为保险投保使用.如有其它行为,请予以拒绝." delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"同意", nil];
            [alert show];
        }
            break;
        case 101:
        {
            ZCViewController *zcVC = [[ZCViewController alloc] init];
            [self.navigationController pushViewController:zcVC animated:YES];
        }
            break;
        case 102:
        {
            BPXXViewController *bpxxViewController = [[BPXXViewController alloc] init];
            [self.navigationController pushViewController:bpxxViewController animated:YES];
        }
            break;
        case 103:
        {
            BLXXViewController *blxxViewController = [[BLXXViewController alloc] init];
            [self.navigationController pushViewController:blxxViewController animated:YES];
        }
            break;
        case 104:
        {
            QueryViewController *queryVc = [[QueryViewController alloc] init];
            [self.navigationController pushViewController:queryVc animated:YES];
        }
            break;
        
    }
}





// UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        SelectCompanryController *selectCTRL = [[SelectCompanryController alloc] init];
        [self.navigationController pushViewController:selectCTRL animated:YES];
    }
}


//  获取需要补拍的人数
-(void )getBuPaiCount{
    //获取登录人的id
    NSString *userid = (NSString *)[Util getValue:@"id"];
    SearchParameters *search = [[SearchParameters alloc] init];
    [search setFillCodeValue:@"true"];
    [search addParameter:@"userid" value:userid flag:11];
    [search setOrder:@"createtime desc"];
    //当前为第几页
    [search setPageNum:[[NSNumber alloc] initWithInt:1]];
    //一页的数量
    [search setPageSize:[[NSNumber alloc] initWithInt:100]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[search getStringOfObject] forKey:@"par"];
    [params setValue:@"true" forKey:@"isBupai"];
    
    
    [[Globle getInstance].service requestWithServiceName:@"BBTone_getDataList" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result) {
        NSDictionary *dict = result;
        NSArray *arr = [dict objectForKey:@"result"];
        
        [self setBtn:_bpyxIcon WithCount:arr.count];
    }];
    
}


//   获取需要补录的人数
-(void)getBuluCount{
    //获取用户id
    NSString *userId = (NSString *)[Util getValue:@"id"];
    SearchParameters *search = [[SearchParameters alloc] init];
    [search setFillCodeValue:@"true"];
    [search addParameter:@"userid" value:userId flag:11];
    [search setOrder:@"createtime desc"];
    //审核状态
    [search addParameter:@"checkstatus" value:[[NSNumber alloc] initWithInt:3] flag:11];
    [search setPageSize:[[NSNumber alloc] initWithInt:100]];
    [search setPageNum:[[NSNumber alloc] initWithInt:1]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[search getStringOfObject] forKey:@"par"];
    [params setValue:@"false" forKey:@"isBupai"];
    
    [[Globle getInstance].service requestWithServiceName:@"BBTone_getDataList" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result)
     {
         NSDictionary *dict = result;
         NSArray *arr = [dict objectForKey:@"result"];
         [self setBtn:_blxxIcon WithCount:arr.count];
         
     } ];

}


//   设置按钮的角标
-(void)setBtn:(UIButton *)btn WithCount:(NSInteger )count{
    
    NSString *num = [NSString stringWithFormat:@"%ld",count];
    if (count != 0) {
        btn.hidden = NO;
        [btn setTitle:num forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"mainpage_new_num.png"] forState:UIControlStateNormal];
    }else{
        btn.hidden = YES;
    }
}



-(void)login:(NSString *)name pass:(NSString *)pass
{
    

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:name forKey:@"cardno"];
    [params setObject:[pass md5] forKey:@"pwd"];
    
    
    [[Globle getInstance].service requestWithServiceName:@"BBTone_LoginIOS" params:params httpMethod:@"POST" resultIsDictionary:false completeBlock:^(id result)
     {
         [MBProgressHUD hideHUD];
         NSString *str = [NSString stringWithFormat:@"%@",result];
         
         if([@"true" isEqualToString:str])
         {
//             获取用户信息
             [self getUserInfo:name];
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
            NSLog(@"%@",result);
             
             [Globle getInstance].userInfoDic = result;
//
//             [Util setObject:cardNumber key:@"username"];
//             NSString *areaid = result[@"areaid"];
//             [Util setObject:areaid key:@"areaid"];
//             [Util setObject:result key:@"userInfo"];
//             NSString *workName = result[@"name"];
//             [Util setObject:workName key:@"workname"];
//             [Util setObject:result[@"orgname"] key:@"orgname"];
//             [Util setObject:result[@"id"] key:@"id"];
         
     }];
}

                     

@end
