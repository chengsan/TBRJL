//
//  BaseNavigationViewController.m
//  TBRJL
//
//  Created by 程三 on 15/6/2.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.navigationBar.hidden = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取系统版本
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 5.0)
    {
        UIImage *img = [UIImage imageNamed:@"navigationbar_background.png"];
        img = [img stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        //调用setNeedsDisplay方法会让渲染引擎异步调用drawRect方法
        [self.navigationBar setNeedsDisplay];
    }

    //手势对象，一个对象只能监听一个方向的手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    //设置监听向右滑的手势
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    //给View添加手势监听
    [self.view addGestureRecognizer:swipeGesture];
}

-(void)swipeAction:(UISwipeGestureRecognizer *)gesture
{
    //判断控制器的数量大于1个时就可以响应手势
    if(self.viewControllers.count > 1)
    {
        //判断是不是右滑手势
        if(gesture.direction == UISwipeGestureRecognizerDirectionRight)
        {
            //删除最上面的控制器
            [self popToRootViewControllerAnimated:YES];
        }
    }
}

@end
