//
//  AppDelegate.h
//  TBRJL
//
//  Created by Charls on 15/12/14.
//  Copyright (c) 2015年 陈浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetServiceURLViewController.h"
#import "DDMenuController.h"
#import "LoginViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) DDMenuController *menuController;
@property(nonatomic,retain)LoginViewController *loginController;
@property(nonatomic,retain)SetServiceURLViewController *setURLController;
@end


