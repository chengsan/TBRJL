//
//  QueryViewController.m
//  TBRJL
//
//  Created by 陈浩 on 15/12/18.
//  Copyright © 2015年 陈浩. All rights reserved.
//

#import "QueryViewController.h"
#import "HistoryViewController.h"
@interface QueryViewController ()
//  投保人
@property (weak, nonatomic) IBOutlet UITextField *snameTextField;
//  保单号
@property (weak, nonatomic) IBOutlet UITextField *safenoTextField;
//  身份证
@property (weak, nonatomic) IBOutlet UITextField *cardnoTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)resetBtnClick;
- (IBAction)selectBtnClick;

@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询事务";
    self.resetBtn.layer.cornerRadius = 5;
    self.resetBtn.layer.masksToBounds = YES;
    self.resetBtn.backgroundColor =  [UIColor colorWithRed:76/255.0 green:129/255.0 blue:190/255.0 alpha:1];
    self.selectBtn.layer.cornerRadius = 5;
    self.selectBtn.layer.masksToBounds = YES;
    self.selectBtn.backgroundColor =  [UIColor colorWithRed:76/255.0 green:129/255.0 blue:190/255.0 alpha:1];
    
}


//   重置
- (IBAction)resetBtnClick {
    self.snameTextField.text = nil;
    self.safenoTextField.text = nil;
    self.cardnoTextField.text = nil;
    
}

//   查询
- (IBAction)selectBtnClick {
    
    if (self.snameTextField.text.length == 0 &&
        self.safenoTextField.text.length == 0 &&
        self.cardnoTextField.text.length == 0) {
        [MBProgressHUD showError:@"查询内容不能为空"];
        return;
    }
    NSString *isOffline = (NSString *)[Util getValue:@"offline"];
    if ([isOffline isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您目前的状态是离线，请在有网的状态下登陆查询." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
    HistoryViewController *historyVc = [[HistoryViewController alloc] init];
    historyVc.sname = self.snameTextField.text;
    historyVc.safeno = self.safenoTextField.text;
    historyVc.cardno = self.cardnoTextField.text;
    [self.navigationController pushViewController:historyVc animated:YES];
    }
}
@end
