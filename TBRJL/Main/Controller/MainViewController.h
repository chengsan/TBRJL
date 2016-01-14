//
//  MainViewController.h
//  TBRJL
//
//  Created by 程三 on 15/6/2.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController<UINavigationControllerDelegate>
{
    int seletedIndex;
}
@property(nonatomic,retain)UIView *tabBarView;
//按钮数组
@property(nonatomic,retain)NSMutableArray *btnArray;
//标题按钮
@property(nonatomic,retain)NSMutableArray *titleArray;
@end
