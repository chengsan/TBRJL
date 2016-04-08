//
//  SetServiceURLViewController.m
//  TBRJL
//
//  Created by 程三 on 15/5/30.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "SetServiceURLViewController.h"
#import "UIViewExt.h"
#import "TBRJL-Prefix.pch"
#import "Util.h"
#import "Globle.h"
#import "MBProgressHUD+PKX.h"
@interface SetServiceURLViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *braceTextField;   //  支撑平台
@property (weak, nonatomic) IBOutlet UITextField *updateTextField;   //  升级平台
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;        //  是否注册
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;        //  当前版本
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;         //  设备号
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)sureBtnClick;
@end

@implementation SetServiceURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.backgroundColor =  [UIColor colorWithRed:76/255.0 green:129/255.0 blue:190/255.0 alpha:1];
    self.navView.backgroundColor =  [UIColor colorWithRed:76/255.0 green:129/255.0 blue:190/255.0 alpha:1];
    BOOL isRegister = [Util getValue:@"register"];
    if (isRegister) {
        self.registerLabel.text = @"已注册";
    }else{
        self.registerLabel.text = @"未注册";
    }
    
    
//     设备号
//    self.deviceLabel.text = [[UIDevice currentDevice] model];
    self.deviceLabel.text = [[UIDevice currentDevice] systemVersion];
    
    
    
//      版本号

    self.versionLabel.text = VersionName;
    [self initData];
    
}

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString); return result;
}

-(void)initData{
    
     //          从本地取出平台URL,如果本地存在，就取出
    self.braceTextField.text = (NSString *)[Util getValue:@"serviceURL"];
    self.updateTextField.text = (NSString *)[Util getValue:@"updateURL"];

 
    //          如果本地不存在，就去配置信息里取出，再存储到本地
    if ((self.braceTextField.text.length== 0 || self.updateTextField.text.length == 0) || (self.braceTextField.text == nil || self.updateTextField.text == nil)) {
        
        self.braceTextField.text = ServiceURL;
        self.updateTextField.text = UpdateURL;
        NSLog(@"%@",self.braceTextField.text);
        //        把数据保存到本地
        [Util setObject:self.braceTextField.text key:@"serviceURL"];
        [Util setObject:self.updateTextField.text key:@"updateURL"];
        
    }}



- (IBAction)sureBtnClick {
    if (self.braceTextField.text.length > 0 && self.braceTextField.text.length >0) {
        [Util setObject:self.braceTextField.text key:@"serviceURL"];
        [Util setObject:self.updateTextField.text key:@"updateURL"];
        
    }else{
        [MBProgressHUD showError:@"平台信息不能为空"];
        return;
    }
    if (self.clickBlock) {
        self.clickBlock();
    }
    
    [self initGloble];
    
}

-(void)initGloble{
    NSString *serviceURL = (NSString *)[Util getValue:@"serviceURL"];
    if (serviceURL.length == 0 || serviceURL == nil ) {
        [Globle getInstance].serviceURL = ServiceURL;
    }else{
        [Globle getInstance].serviceURL = serviceURL;
    }
    [Globle getInstance].updateURL = UpdateURL;
}





@end
