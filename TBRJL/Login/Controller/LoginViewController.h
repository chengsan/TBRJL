//
//  LoginViewController.h
//  TBRJL
//
//  Created by 程三 on 15/5/30.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVCustomAlertView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    BOOL isRemenber;
    BOOL isAutoLogin;
    FVCustomAlertView *_alertView;
    NSString *cdnpath;
}

@property(nonatomic,retain) UITextField *userName;
@property(nonatomic,retain) UITextField *passName;
@property(nonatomic,copy) NSString *userNameStr;
@property(nonatomic,copy) NSString *passwordStr;
@property (nonatomic ,assign) BOOL isLogin;    //  是否登录过

@end
