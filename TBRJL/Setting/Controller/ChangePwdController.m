//
//  ChangePwdController.m
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "ChangePwdController.h"
#import "Util.h"
#import "Globle.h"
#import "MBProgressHUD+PKX.h"


/**
 * 密码
 */
#define CHPassword @"CHPassword"
@interface ChangePwdController ()<UIActionSheetDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPwdField;

@property (weak, nonatomic) IBOutlet UITextField *firstNewPwdField;
@property (weak, nonatomic) IBOutlet UITextField *secondNewField;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;


- (IBAction)changeBtnClick;

@end

@implementation ChangePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    self.changeBtn.layer.cornerRadius = 5;
    self.changeBtn.layer.masksToBounds = YES;
    self.changeBtn.enabled = NO;
    self.changeBtn.backgroundColor = [UIColor colorWithRed:74/255.0 green:163/255.0 blue:218/255.0 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChanged) name:UITextFieldTextDidChangeNotification object:self.oldPwdField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChanged) name:UITextFieldTextDidChangeNotification object:self.firstNewPwdField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChanged) name:UITextFieldTextDidChangeNotification object:self.secondNewField];
}


-(void)valueChanged{
    self.changeBtn.enabled = (self.oldPwdField.text.length && self.firstNewPwdField.text.length && self.secondNewField.text.length);
}


//    _passName.text = @"13751122150";
- (IBAction)changeBtnClick {
    if (![_oldPwdField.text isEqualToString:(NSString *)[Util getValue:CHPassword]]) {
        [MBProgressHUD showError:@"旧密码输入错误"];
        
    }else if(_firstNewPwdField.text.length < 6 || _secondNewField.text.length <6){
        [MBProgressHUD showError:@"密码长度少于6位"];
        
    }else if (![_firstNewPwdField.text isEqualToString:_secondNewField.text]) {
        [MBProgressHUD showError:@"两次密码输入不一样"];
        
    }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定修改吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
    }

}


#pragma mark - UIActionSheetDelegate 代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (buttonIndex == 0) {    // 确定
        NSString *isOffline = (NSString *)[Util getValue:@"offline"];
        if ([isOffline isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您目前的状态是离线，请在有网的状态下登陆后修改." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
       //         修改密码
          [self changePwd];
        }
       
    }
}



- (void)changePwd{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cardno"] = (NSString *)[Util getValue:@"username"];
    params[@"pwd"] = self.secondNewField.text;
    
    NSLog(@"%@",params);
    [[Globle getInstance].service requestWithServiceName:@"BBTone_modifyUserPwd" params:params httpMethod:@"POST" resultIsDictionary:false completeBlock:^(id result) {
     
        if ([result isEqualToString:@"true"]) {
            [MBProgressHUD showSuccess:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"修改密码失败"];
        }
    }];
    
}

//  移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
@end
