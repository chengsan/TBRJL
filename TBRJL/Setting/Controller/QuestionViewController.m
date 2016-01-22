//
//  QuestionViewController.m
//  TBRJL
//
//  Created by 陈浩 on 16/1/19.
//  Copyright © 2016年 陈浩. All rights reserved.
//

#import "QuestionViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"常见问题";
    [super showLoading:YES];
    [self setupWebView];
    
}


-(void)setupWebView{
    
    UIWebView *webView =[[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:webView];
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
