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
    self.view.backgroundColor = [[UIColor alloc] initWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    self.title = @"关于";

    [self initView];
}

-(void) initView{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 74, 74)];
    imgView.image = [UIImage imageNamed:@"icon"];
    imgView.center = CGPointMake(ScreenWidth /2, ScreenHeight/2 - 64);
    [self.view addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    label.center = CGPointMake(ScreenWidth /2, imgView.bottom +20);
    label.textAlignment = NSTextAlignmentCenter;
    label.text=@"福建省投保人记录系统 V1.1.8";
    [self.view addSubview:label];
    
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
