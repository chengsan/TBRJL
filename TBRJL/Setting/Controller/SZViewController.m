//
//  SZViewController.m
//  TBRJL
//
//  Created by user on 15/11/12.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "SZViewController.h"
#import "SZTableViewCell.h"
#import "SZSettingGroup.h"
#import "TBRJL-Prefix.pch"
#import "MBProgressHUD+PKX.h"
#import "ChangePwdController.h"
#import "SelectCompanryController.h"
#import "Globle.h"
#import "Util.h"
#import "CHSaveDataTool.h"


@interface SZViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)UIAlertView *alertView;

@property (nonatomic ,strong)NSMutableArray *groupArr;

@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation SZViewController

-(NSMutableArray *)groupArr{
    if (!_groupArr) {
        _groupArr = [NSMutableArray array];
    }
    return _groupArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.backTitleLabel.text = @"设置";
   [self initView];
    
    SZSettingSwitch *item0 = [SZSettingSwitch itemWithTitle:@"记住密码"];
    SZSettingSwitch *item1 = [SZSettingSwitch itemWithTitle:@"自动登录"];
    SZSettingGroup *group0 = [SZSettingGroup groupWithItems:@[item0,item1]];
    [_groupArr addObject:group0];
    
    
    SZSettingArrow *item10 = [SZSettingArrow itemWithTitle:@"修改密码"];
    item10.operationBlock = ^{
        ChangePwdController *changePwdVc = [[ChangePwdController alloc] init];
        [self.navigationController pushViewController:changePwdVc animated:YES];
    };
    
    
    SZSettingGroup *group1 = [SZSettingGroup groupWithItems:@[item10]];
    [_groupArr addObject:group1];
    
    SZSettingSwitch *item100 = [SZSettingSwitch itemWithTitle:@"退出时清除缓存"];
    SZSettingLabel *item101 = [SZSettingLabel itemWithTitle:@"清除缓存"];
     item101.text = [NSString stringWithFormat:@"%.1fM", [self folderSizeAtPath:PATH]];
    __weak typeof (self) weakSelf = self;
    item101.operationBlock = ^{
        [MBProgressHUD showMessage:@"正在清除缓存,请稍候..."];
//         清理缓存
         [PublicClass cleanCacheWithPath:PATH];
            // 隐藏指示器
         [MBProgressHUD hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showSuccess:@"清除成功"];
                [weakSelf setCacheWithItem:item101 WithPath:PATH];
                [weakSelf.tableView reloadData];
            });
    };
    
    
    SZSettingGroup *group2 = [SZSettingGroup groupWithItems:@[item100,item101]];
    [_groupArr addObject:group2];
    
    SZSettingLabel *item1000 = [SZSettingLabel itemWithTitle:@"当前版本"];
    item1000.text = VersionName;
    SZSettingArrow *item1001 = [SZSettingArrow itemWithTitle:@"版本更新"];
    
    item1001.operationBlock = ^{
        
        [MBProgressHUD showMessage:@"正在检查更新"];
        
        NSString *isOffline = (NSString *)[Util getValue:@"offline"];
        if ([isOffline isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您目前的状态是离线，请在有网的状态下登陆尝试检查." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }else{
            
            NSString *leapAPPName = LeapAPPName;
            
            [self checkVersion:leapAPPName];
        }
        
    };
    SZSettingGroup *group3 = [SZSettingGroup groupWithItems:@[item1000,item1001]];
    [_groupArr addObject:group3];
    
    
}


-(void)initView{
   
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.sectionHeaderHeight = 10;
    tableView.sectionFooterHeight = 0;
    tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;

    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, ScreenWidth -30, 35)];
    exitBtn.layer.cornerRadius = 5;
    exitBtn.layer.masksToBounds = YES;
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.backgroundColor = RGB(208, 69, 62);
    [footView addSubview:exitBtn];
    tableView.tableFooterView = footView;
    
    
}

//    退出
-(void)exitBtnClick{
     BOOL isClean = [CHSaveDataTool boolForkey:@"退出时清除缓存"];
//     如果退出清除缓存
    if (isClean) {
        [PublicClass cleanCacheWithPath:PATH];
    }
    [self.db close];
    exit(0);

}


-(void)setCacheWithItem:(SZSettingLabel *)item WithPath:(NSString *)path{
      NSString *str = [NSString stringWithFormat:@"%.1fM", [self folderSizeAtPath:path]];
    item.text = str;
}



- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

#pragma mark - UITableViewDataSource 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groupArr.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      SZSettingGroup *group = _groupArr[section];
      return group.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SZTableViewCell *cell = [SZTableViewCell cellForTableView:tableView];
    SZSettingGroup *group = _groupArr[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.showLine = (indexPath.row == group.items.count - 1);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SZSettingGroup *group = _groupArr[indexPath.section];
    SZSettingItem *item = group.items[indexPath.row];
    if (item.operationBlock) {
        item.operationBlock();
        return;
    }
}



//#pragma mark -UIAlertViewDelegate 代理方法
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {    //  确定
//        
//    }
//}


#pragma mark 检测版本号
-(void)checkVersion:(NSString *)leapAPPname
{
    if(leapAPPname != nil)
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:leapAPPname forKey:@"appname"];
        
        [[Globle getInstance].service requestWithServiceName:@"lbcp_getAppVersion" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result) {
          
            NSLog(@"result:%@",result);
            
            NSDictionary *dic = (NSDictionary *)result;
            if(nil != dic)
            {
                [MBProgressHUD hideHUD];
                //获取本地版本
                NSString *localVersion = VersionCode;
                NSLog(@"当前版本号%@",localVersion);
                int localVersionNUm = (localVersion == nil ? -1 : [localVersion intValue]);
                //获取服务器版本
                NSString *serverVersion = [dic valueForKey:@"appversion"];
                int serverVersionNum = (serverVersion == nil ? -1 : [serverVersion intValue]);
                //判断是非升级
                if(localVersionNUm < serverVersionNum)
                {
                    NSString *upgrade = [dic valueForKey:@"upgrade"];
                    if([@"1" isEqualToString:upgrade])    //   强制升级
                    {
                        self.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"有新的版本，请及时更新。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    }
                    else     //  自选升级
                    {
                        self.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"有新的版本，请及时更新。" delegate:self cancelButtonTitle: nil otherButtonTitles:@"确定",@"取消",nil];
                    }
                    [self.alertView show];
                    
                }else{
                    [MBProgressHUD showSuccess:@"当前是最新版本"];
                }
            }
            
        }];
    }
}


#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.alertView)
    {
        if(buttonIndex == 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://chengsan.github.io/demo"]];
        }
        
        long oldTime = (long)[Util getValue:@"systemTime"];
        oldTime = oldTime + 24*60*60*1000;
        [Util setObject:[[NSNumber alloc] initWithLong:oldTime] key:@"systemTime"];
    }
}



@end
