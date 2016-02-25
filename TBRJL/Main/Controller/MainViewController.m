//
//  MainViewController.m
//  TBRJL
//
//  Created by 程三 on 15/6/2.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "SetViewController.h"
#import "BaseNavigationViewController.h"
#import "TBRJL-Prefix.pch"
#import "UIViewExt.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    seletedIndex = 0;
    self.tabBar.hidden = YES;
    [self _initViewController];
    [self _initTabBar];
}

-(void)_initViewController
{
    HomeViewController *homeCTRL = [[HomeViewController alloc] init];
    SetViewController *setCTRL = [[SetViewController alloc] init];
    
    NSArray *array = @[homeCTRL,setCTRL];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (UIViewController *viewController in array)
    {
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
        nav.delegate = self;
    }
    [self setViewControllers:viewControllers animated:YES];
}

-(void)_initTabBar
{
    
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-60, ScreenWidth, 60)];
    [self.view addSubview:_tabBarView];
    
    
    UIImage *tabImage = [UIImage imageNamed:@"navigationbar_background.png"];
    tabImage = [tabImage stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    
//    UIImage *tabImage = [UIImage imageNamed:@"tabbar_background.png"];
//    tabImage = [tabImage stretchableImageWithLeftCapWidth:0.5 topCapHeight:0];
    UIImageView *tabBarBg = [[UIImageView alloc] initWithImage:tabImage];
    tabBarBg.frame = _tabBarView.bounds;
    [_tabBarView addSubview:tabBarBg];
    
    //正常图片
    NSArray *menuBg = @[@"menu_sy_img.png",@"menu_sz_img.png"];
    //高亮图片
    NSArray *hightMenuBg = @[@"menu_sy_img_selected.png",@"menu_sz_img_selected.png"];
    //标题
    NSArray *titles = @[@"办公管理",@"系统管理"];

    
    //按钮数组
    _btnArray = [[NSMutableArray alloc] initWithCapacity:menuBg.count];
    //标题按钮
    _titleArray = [[NSMutableArray alloc] initWithCapacity:menuBg.count];
    for (int i = 0; i < menuBg.count; i++)
    {
        UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        btnView.tag = i;
        btnView.frame = CGRectMake(i * ScreenWidth/menuBg.count, 0, ScreenWidth/menuBg.count, _tabBarView.height);
        [_tabBarView addSubview:btnView];
        
        NSString *img = menuBg[i];
        NSString *hightImg =hightMenuBg[i];
        
        //－－－－－－－－－－－－－图片－－－－－－－－－－－－
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectZero;
        btn.width = 25;
        btn.height = 25;
        btn.left = (btnView.width - btn.width)/2;
        btn.top = (btnView.height - btn.height - 20)/2;
        //点击按钮时高亮
        //btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:hightImg] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:hightImg] forState:UIControlStateSelected];
        if(i == 0)
        {
            btn.selected = YES;
        }
        [btnView addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnArray addObject:btn];
        
        [btnView addSubview:btn];

        //－－－－－－－－－－标题－－－－－－－－－－－
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.bottom, btnView.width, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        if(i == 0)
        {
            titleLabel.textColor = [[UIColor alloc] initWithRed:97/255.0 green:152/255.0 blue:224/255.0 alpha:1];
        }
        else
        {
            titleLabel.textColor = [[UIColor alloc] initWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1];
        }
        titleLabel.text = titles[i];
        [btnView addSubview:titleLabel];
        
        [_titleArray addObject:titleLabel];
        
    }
}

-(void)selectTab:(UIButton *)btn
{
    int tag = (int)btn.tag;
    if(tag == seletedIndex)
    {
        return;
    }
    //设置已选中的按钮不选中
    if(seletedIndex >= 0 && seletedIndex < _btnArray.count && tag < _titleArray.count)
    {
        UIButton *btn = (UIButton *)_btnArray[seletedIndex];
        btn.selected = NO;
        UILabel *label = (UILabel *)_titleArray[seletedIndex];
        label.textColor = [[UIColor alloc] initWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1];
        seletedIndex = tag;
    }
    if(tag >= 0 && tag < _btnArray.count)
    {
        UIButton *btn = (UIButton *)_btnArray[tag];
        btn.selected = YES;
        UILabel *label = (UILabel *)_titleArray[tag];
        label.textColor = [[UIColor alloc] initWithRed:97/255.0 green:152/255.0 blue:224/255.0 alpha:1];
        ;
    }

    //设置选中的页面
    self.selectedIndex = tag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UINavigationController delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSInteger count = navigationController.viewControllers.count;
    if(count == 2)
    {
        [self showTableBar:NO];
    }
    else if(count == 1)
    {
        [self showTableBar:YES];
    }
}

//是否显示TabBar
-(void)showTableBar:(BOOL)show
{
    [UIView animateWithDuration:0.3 animations:^
     {
         if(show)
         {
             _tabBarView.left = 0;
         }
         else
         {
             _tabBarView.left = -ScreenWidth;
             
         }
     }];
}

@end
