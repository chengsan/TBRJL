//
//  AppDelegate.m
//  TBRJL
//
//  Created by Charls on 15/12/14.
//  Copyright (c) 2015年 陈浩. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ScanViewController.h"
#import "AFNetworking.h"
#import "CHSaveDataTool.h"
#import "NSString+NSStringMD5.h"

/**
 * 账号
 */
#define CHAccount @"CHAccount"
/**
 * 密码
 */
#define CHPassword @"CHPassword"
@interface AppDelegate ()
@property (nonatomic ,assign) BOOL isOffline;   // 是否离线
@property (nonatomic ,strong) NSTimer *timer;   //  定时器
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self AFNetworkingStatusObserve];
    //登录控制器
    _loginController = [[LoginViewController alloc] init];
    //菜单控制器
    _menuController = [[DDMenuController alloc] initWithRootViewController:_loginController];
    
    //设置右控制器
    _setURLController = [[SetServiceURLViewController alloc] init];
    __weak typeof (self) weakSelf = self;
    _setURLController.clickBlock = ^{
        [weakSelf.menuController showRootController:YES];
    };
    _menuController.rightViewController = _setURLController;
    self.window.rootViewController = _menuController;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


-(void)AFNetworkingStatusObserve{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝网");
                
                [self setup];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                [self setup];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网");
                                 
                [Util setObject:@"1" key:@"offline"];
                break;
                
            default:
                break;
        }
    }];
    [manager startMonitoring];
}


-(void)setup{
    _isOffline = NO;
    [Util setObject:@"0" key:@"offline"];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%s",__func__);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:6000 target:self selector:@selector(login) userInfo:nil repeats:YES];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    BOOL isClean = [CHSaveDataTool boolForkey:@"退出时清除缓存"];
    //     如果退出清除缓存
    if (isClean) {
        [PublicClass cleanCacheWithPath:PATH];
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%s",__func__);
    [self.timer invalidate];
    self.timer = nil;
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%s",__func__);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s",__func__);
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//-(void)getUserInfo
//{
//    NSString *cardNumber = @"350701198610200159";
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:cardNumber forKey:@"cardno"];
//
//    [[Globle getInstance].service requestWithServiceName:@"BBTone_getUserInfo" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result)
//     {
//            NSLog(@"%@",result);
//             NSString *areaid = result[@"areaid"];
//             [Util setObject:cardNumber key:@"username"];
//             [Util setObject:areaid key:@"areaid"];
//             [Globle getInstance].userInfoDic = result;
//             [Util setObject:result key:@"userInfo"];
//
//
//             NSString *content = [NSString stringWithFormat:@"%@",result];
//
//             /*
//              //获取Document路径
//              NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//              //建立自己的目录
//              path = [path stringByAppendingPathComponent:@"userInfo"];
//              //文件名
//              NSString *fileName = [NSString stringWithFormat:@"%@.text",[[Globle getInstance].userInfoDic objectForKey:@"cardno"]];
//              */
//
//             NSString *path = UserInfoDic;
//             NSString *fileName = (NSString *)[Util getValue:@"username"];
//             NSString *fullPath = [path stringByAppendingPathComponent:fileName];
//
//             NSFileManager *fileManager = [NSFileManager defaultManager];
//             //判断目录是否存在的，不存在就建立
//             if(![fileManager fileExistsAtPath:path])
//             {
//                 BOOL b = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
//                 if(b)
//                 {
//                     NSLog(@"创建目录成功");
//                 }
//                 else
//                 {
//                     NSLog(@"创建目录失败");
//                 }
//             }
//
//             //判断文件是否存在
//             if([fileManager fileExistsAtPath:fullPath])
//             {
//                 //存在久删除·
//                 [fileManager removeItemAtPath:fullPath error:nil];
//             }
//
//             BOOL deleteSucess = [fileManager createFileAtPath:fullPath contents:nil attributes:nil];
//             if(deleteSucess)
//             {
//                 NSLog(@"创建文件成功");
//             }
//             else
//             {
//                 NSLog(@"创建文件失败");
//             }
//    }];
//}
//
//
-(void)login
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:CHAccount];
    NSString *pass = [defaults objectForKey:CHPassword];
    if(nil == name || pass == nil)
    {
        return;
    }
    [params setObject:name forKey:@"cardno"];
    [params setObject:[pass md5] forKey:@"pwd"];
    [[Globle getInstance].service requestWithServiceName:@"BBTone_LoginIOS" params:params httpMethod:@"POST" resultIsDictionary:false completeBlock:^(id result)
     {
         [MBProgressHUD hideHUD];
         NSString *str = [NSString stringWithFormat:@"%@",result];
         NSLog(@"result = %@",str);
         
     }];
    
}



@end
