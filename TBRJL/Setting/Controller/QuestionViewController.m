//
//  QuestionViewController.m
//  TBRJL
//
//  Created by 陈浩 on 16/1/19.
//  Copyright © 2016年 陈浩. All rights reserved.
//
 
#import "QuestionViewController.h"

@interface QuestionViewController ()
@property (nonatomic ,strong) UIWebView *webView;
@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"常见问题";
  
    [self setupWebView];
    
}


-(void)setupWebView{
    
    UIWebView *webView =[[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView = webView;
    [self.view addSubview:webView];
//      [super showLoading:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...

        NSURL *url = [[NSURL alloc]initWithString:@"http://fjisip.yxybb.com/LEAP/FAQ.html"];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [super showLoading:false];
        });
    }); 
}

-(void)dismiss{

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-40, 30, 30, 30)];
//    btn.backgroundColor = [UIColor redColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [self.webView addSubview:btn];
 
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:NULL];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [super showLoading:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
