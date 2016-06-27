//
//  AboutViewController.m
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "AboutViewController.h"
#import "TBRJL-Prefix.pch"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(230, 230, 230);
    self.title = @"关于";

    [self initView];
    
    
    
}

-(void) initView{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    imgView.image = [UIImage imageNamed:@"icon"];
    imgView.center = CGPointMake(ScreenWidth /2, ScreenHeight/2 - 120);
    [self.view addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    label.center = CGPointMake(ScreenWidth /2, imgView.bottom +20);
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = [NSString stringWithFormat:@"福建省投保人记录系统 %@",VersionName];
    label.text=string;
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    UILabel *lal = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight -90, ScreenWidth, 20)];

    lal.textAlignment = NSTextAlignmentCenter;
    lal.text = @"福建省保险行业协会监制";
    lal.font = [UIFont systemFontOfSize:14];
    lal.textColor = [UIColor grayColor];
    [self.view addSubview:lal];
    
    
}

// 进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
    
}

// 退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
