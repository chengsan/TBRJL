//
//  QuestionViewController.m
//  TBRJL
//
//  Created by 陈浩 on 16/1/19.
//  Copyright © 2016年 陈浩. All rights reserved.
//
 
#import "QuestionViewController.h"

@interface QuestionViewController ()<UIWebViewDelegate>
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
    webView.delegate = self;
    [webView setScalesPageToFit:YES];
    [self.view addSubview:webView];

        NSURL *url = [[NSURL alloc]initWithString:@"http://fjisip.yxybb.com/LEAP/FAQ.html"];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
   
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



#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [super showLoading:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [super showLoading:false];
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
