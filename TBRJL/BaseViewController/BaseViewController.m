//
//  BaseViewController.m
//  TBRJL
//
//  Created by 程三 on 15/6/2.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

-(id)init
{
    self = [super init];
    if(self)
    {
        self.isBackButton = YES;
    }
    
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"标题";
    NSArray *array = self.navigationController.viewControllers;
    if(array.count > 1 && self.isBackButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 70, 30);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        //图标
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tbsy_back_icon.png"]];
        imageView.frame = CGRectMake(0, 0, 30, 30);
        [button addSubview:imageView];
        
        //文字
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right, 0, 35, 30)];
        title.font = [UIFont systemFontOfSize:15];
        title.text = @"返回";
        title.textColor = RGB(37, 165, 225);
        [button addSubview:title];
        self.backTitleLabel = title;
        
        // 调整 leftBarButtonItem 在 iOS7 下面的位置
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?20:0))
            
        {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                           target:nil action:nil];
            negativeSpacer.width = -20;//这个数值可以根据情况自由变化
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
        }
        else
            
            self.navigationItem.leftBarButtonItem = backItem;
        
        //UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        //self.navigationItem.leftBarButtonItem = backItem;
    }
}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置标题
-(void) setTitle:(NSString *)title
{
    [super setTitle:title];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

//是否显示加载提示
-(void)showLoading:(BOOL)show
{
    if(_loadView == nil)
    {
        float width = ScreenWidth;
        float heigh = ScreenHeight;
        int statusBarHeight = (int)StatusBarHeight;
        int titleBarHeight = (int)TitleBarHeight;
        
        _loadView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width, heigh - statusBarHeight - titleBarHeight)];
        _loadView.backgroundColor = [UIColor whiteColor];
        
        //loadingView
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake((_loadView.width - 35)/2, (_loadView.height - 35)/2, 35, 35);
        [activityView startAnimating];
        
        [_loadView addSubview:activityView];
    }
    
    if(show)
    {
        if(![_loadView superview])
        {
            //添加到TableView中
            [self.view addSubview:_loadView];
        }
    }
    else
    {
        if([_loadView superview])
        {
            //从TableView中移除
            [_loadView removeFromSuperview];
        }
    }
    
}


//显示没有数据提示
-(void)showNotice:(BOOL)show
{
    if(_noticeView == nil)
    {
        
        float width = ScreenWidth;
        float heigh = ScreenHeight;
        int statusBarHeight = (int)StatusBarHeight;
        int titleBarHeight = (int)TitleBarHeight;
        
        //加载label
        _noticeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width, heigh - statusBarHeight - titleBarHeight)];
        _noticeView.backgroundColor = [UIColor whiteColor];
        
        //加载label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,width, heigh - statusBarHeight - titleBarHeight)];
        //label.backgroundColor = [UIColor whiteColor];
        label.text = @"没有数据";
        label.font = [UIFont systemFontOfSize:16.0];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_noticeView addSubview:label];
        
    }
    
    if(show)
    {
        if(![_noticeView superview])
        {
            //添加到TableView中
            [self.view addSubview:_noticeView];
        }
    }
    else
    {
        if([_noticeView superview])
        {
            //从TableView中移除
            [_noticeView removeFromSuperview];
        }
    }
    
}


//
//// 获取保单数据
//-(void)getPolicyData{
//    
//    if (!self.db) {
//        [self creatDataBase];
//    }
//    if ([self.db open]) {
//        NSString *nameSql = @"select * from policy";
//        FMResultSet *rs = [self.db executeQuery:nameSql];
//        while ([rs next]) {
//            PolicyModel *model = [[PolicyModel alloc]init];
//            model.age = [rs stringForColumn:@"age"] ;
//            model.areaid = [rs stringForColumn:@"areaid"];
//            model.cardno =  [rs stringForColumn:@"cardno"];
//            model.cardtype = [rs stringForColumn:@"cardtype"];
//            model.companycode = [rs stringForColumn:@"companycode"];
//            model.companyname = [rs stringForColumn:@"companyname"];
//            model.companyno = [rs stringForColumn:@"companyno"];
//            model.companytype = [rs stringForColumn:@"companytype"];
//            model.pcardno = [rs stringForColumn:@"pcardno"];
//            model.pcardtype = [rs stringForColumn:@"pcardtype"];
//            model.pname = [rs stringForColumn:@"pname"];
//            model.psafedate = [rs stringForColumn:@"psafedate"];
//            model.psafedateend = [rs stringForColumn:@"psafedateend"];
//            model.psafepay = [rs stringForColumn:@"psafepay"];
//            model.psafetypes = [rs stringForColumn:@"psafetypes"];
//            model.safecost = [rs stringForColumn:@"safecost"];
//            model.safeno = [rs stringForColumn:@"safeno"];
//            model.safetype = [[rs stringForColumn:@"safetype"] integerValue];
//            model.sex = [rs stringForColumn:@"sex"];
//            model.sname = [rs stringForColumn:@"sname"];
//            model.syscode = [rs stringForColumn:@"syscode"];
//            model.creatTime = [rs stringForColumn:@"creattime"];
//            NSLog(@"创建的时间是%@",model.creatTime);
//            NSLog(@"%@",model.psafetypes);
//            [self.arr addObject:model];
//        }
//    }
//    [self.tableView reloadData];
//    
//    
//}
//  创建数据库
-(void)creatDataBase{
    NSString *cardno = (NSString *)[Util getValue:@"username"];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlt",cardno]];
    self.db = [FMDatabase databaseWithPath:fileName];
}

//  创建保单表
-(void)creatPolicy{
    
    if (!self.db) {
        [self creatDataBase];
    }
    [self.db setShouldCacheStatements:YES];
    if ([self.db open]) {
        if (![self isTableExistWithTableName:@"policy"]) {
            
            NSString *policy = @"create table policy(userid text,age text,areaid text,cardno text,cardtype text,companycode text,companyname text,companyno text,companytype text,pcardno text,pcardtype text,pname text,psafedate text,psafedateend text,psafepay text,psafetypes text,safecode text,safecost text,safeno text,safetype integer,sex text,sname text,syscode text,pcarno text,pwin text,creattime text,photoDicPath text,isread text,isqrcode text,time text)";
            BOOL res = [self.db executeUpdate:policy];
            if (!res) {
                NSLog(@"----创建失败");
            }else{
                NSLog(@"----创建成功");
                
            }
        }
    }
}

//根据表的名字判断表是否存在
-(BOOL)isTableExistWithTableName:(NSString *)tableName
{
    FMResultSet *set = [self.db executeQuery:@"select count(*) as count from sqlite_master where type = 'table' and name = ?",tableName];
    if ([set next]) {
        NSInteger count = [set intForColumn:@"count"];
        if (0 == count) {
            return NO;
        }
        return YES;
    }
    return NO;
}



//  创建图片表
-(void)creatPolicyImage{
    if (!self.db) {
        [self creatDataBase];
    }
    [self.db setShouldCacheStatements:YES];
    if ([self.db open]) {
        if (![self isTableExistWithTableName:@"policyimage"]){
            NSString *policyImageCreat = @"create table policyimage(creattime text,attid text,beanname text,code text,createtime text,creator text,filename text,iswater text,nullable text,path text,photocode text,photoname text,phototype text,title text,updater text,updatetime text)";
            BOOL res = [self.db executeUpdate:policyImageCreat];
            if (!res) {
                NSLog(@"创建失败");
            }else{
                NSLog(@"创建成功");
            }
        }
    }
}


//  暂存图片到数据库
-(BOOL)updatePolicyImage:(PhotoInfoModel *)model withCreatTime:(NSString *)creatTime{
    if (!self.db) {
        [self creatDataBase];
    }
    if ([self.db open]) {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO policyimage(creattime,attid,beanname,code,createtime,creator,filename,iswater,nullable,path,photocode,photoname,phototype,title,updater,updatetime)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",creatTime,model.attid,model.beanname,model.code,model.createtime,model.creator,model.filename,model.iswater,model.nullable1,model.path,model.photocode,model.photoname,model.phototype,model.title,model.updater,model.updatetime];
        BOOL res = [self.db executeUpdate:sqlInsert];
        return res;
    }
    return NO;
}


 //  暂存保单信息到数据库
-(BOOL)updatePolicy:(PolicyModel *)model{
    if (!self.db) {
        [self creatDataBase];
    }
    if ([self.db open]) {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO policy(userid,age,areaid,cardno,cardtype,companycode,companyname,companyno,companytype,pcardno,pcardtype,pname,psafedate,psafedateend,psafepay,psafetypes,safecode,safecost,safeno,safetype,sex,sname,syscode,pcarno,pwin,creattime,photoDicPath,isread,isqrcode,time) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%zd','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",model.userid,model.age,model.areaid,model.cardno,model.cardtype,model.companycode,model.companyname,model.companyno,model.companytype,model.pcardno,model.pcardtype,model.pname,model.psafedate,model.psafedateend,model.psafepay,model.psafetypes,model.safecode,model.safecost,model.safeno,model.safetype,model.sex,model.sname,model.syscode,model.pcarno,model.pwin,model.creatTime,model.photoDicPath,model.isread,model.isqrcode,model.time];
        BOOL res = [self.db executeUpdate:sqlInsert];
        return res;
    }
    return NO;

}


#pragma mark - 从数据库获取保单数据
-(NSMutableArray *)getPolicyDataWithUserID:(NSString *)userid{
    
    if (!self.db) {
        [self creatDataBase];
    }
    if ([self.db open]) {

        NSString *nameSql = [NSString stringWithFormat:@"select * from policy where userid = %@",userid];
        FMResultSet *rs = [self.db executeQuery:nameSql];
        NSMutableArray *arrM = [NSMutableArray array];
        while ([rs next]) {
            EntityBean *bean = [[EntityBean alloc]init];
            
            [bean setValue:[rs stringForColumn:@"areaid"] forKey:@"areaid"];
            [bean setValue:[rs stringForColumn:@"cardno"] forKey:@"cardno"];
            [bean setValue:[rs stringForColumn:@"cardtype"] forKey:@"cardtype"];
            [bean setValue:[rs stringForColumn:@"companycode"] forKey:@"companycode"];
            [bean setValue:[rs stringForColumn:@"companyname"] forKey:@"companyname"];
            [bean setValue:[rs stringForColumn:@"companyno"] forKey:@"companyno"];
            [bean setValue:[rs stringForColumn:@"companytype"] forKey:@"companytype"];
            [bean setValue:[rs stringForColumn:@"pcardno"] forKey:@"pcardno"];
            [bean setValue:[rs stringForColumn:@"pcardtype"] forKey:@"pcardtype"];
            [bean setValue:[rs stringForColumn:@"pname"] forKey:@"pname"];
            [bean setValue:[rs stringForColumn:@"psafedate"] forKey:@"psafedate"];
            [bean setValue:[rs stringForColumn:@"psafedateend"] forKey:@"psafedateend"];
            [bean setValue:[rs stringForColumn:@"psafepay"] forKey:@"psafepay"];
            [bean setValue:[rs stringForColumn:@"psafetypes"] forKey:@"psafetypes"];
            [bean setValue:[rs stringForColumn:@"psafetypes"] forKey:@"safecode"];
            [bean setValue:[rs stringForColumn:@"safecost"] forKey:@"safecost"];
            [bean setValue:[rs stringForColumn:@"safeno"] forKey:@"safeno"];
            [bean setValue:[rs stringForColumn:@"safetype"] forKey:@"safetype"];
            [bean setValue:[rs stringForColumn:@"isread"] forKey:@"isread"];
            [bean setValue:[rs stringForColumn:@"isqrcode"] forKey:@"isqrcode"];
            [bean setValue:[rs stringForColumn:@"time"] forKey:@"time"];
            
            NSString *age = [rs stringForColumn:@"age"];
            if (![age isEqualToString:@"(null)"]) {
                [bean setValue:age forKey:@"age"];
            }
            NSString *sex = [rs stringForColumn:@"sex"];
            if (![sex isEqualToString:@"(null)"]) {
                [bean setValue:sex forKey:@"sex"];
            }
            NSString *pcarno = [rs stringForColumn:@"pcarno"];
            if (![pcarno isEqualToString:@"(null)"]) {
                [bean setValue:pcarno forKey:@"pcarno"];
            }
            NSString *pwin = [rs stringForColumn:@"pwin"];
            if (![pwin isEqualToString:@"(null)"]) {
                [bean setValue:pwin forKey:@"pwin"];
            }
            [bean setValue:[rs stringForColumn:@"sname"] forKey:@"sname"];
            [bean setValue:[rs stringForColumn:@"safecode"] forKey:@"safecode"];
            [bean setValue:[rs stringForColumn:@"syscode"] forKey:@"syscode"];
            [bean setValue:[rs stringForColumn:@"creattime"] forKey:@"creattime"];
            [bean setValue:[rs stringForColumn:@"photoDicPath"] forKey:@"photoDicPath"];
            [bean setValue:[rs stringForColumn:@"companycode"] forKey:@"companycode"];
            [bean setValue:[rs stringForColumn:@"companycode"] forKey:@"companycode"];
            NSLog(@"创建的时间是%@",[bean objectForKey:@"creattime"]);
            [arrM addObject:bean];
        }
        return arrM;
    }
    return nil;
}

#pragma mark - 根据保单创建时间删除指定数据表单
-(BOOL) deleteTableByCreatTime:(NSString *)creatTime TableName:(NSString*)tableName{
    if (!self.db) {
        [self creatDataBase];
    }
    if ([self.db open]) {
        NSString *delSql = [NSString stringWithFormat:@"delete from %@ where creattime = %@",tableName,creatTime];
        BOOL isDel = [self.db executeUpdate:delSql];
        return isDel;
    }
    return NO;
}



#pragma mark -  根据创建的时间找到所对应的数据表
 
-(NSMutableArray *)getImagePathWithCreatTime:(NSString *)creatTime{
    if (!self.db) {
        [self creatDataBase];
    
    }
    if ([self.db open]) {
        NSString *nameSql =  [NSString stringWithFormat:@"select * from policyimage where creattime = %@",creatTime];
        FMResultSet *rs = [self.db executeQuery:nameSql];
        NSMutableArray *arrM = [NSMutableArray array];
        while ([rs next]) {
            EntityBean *bean = [[EntityBean alloc] init];
            [bean setValue:[rs stringForColumn:@"attid"] forKey:@"attid"];
            [bean setValue:[rs stringForColumn:@"beanname"] forKey:@"beanname"];
            [bean setValue:[rs stringForColumn:@"code"] forKey:@"code"];
            [bean setValue:[rs stringForColumn:@"createtime"] forKey:@"createtime"];
            [bean setValue:[rs stringForColumn:@"creator"] forKey:@"creator"];
            NSString *filename = [rs stringForColumn:@"filename"];
            if (![filename isEqualToString:@"(null)"]) {
                [bean setValue:filename forKey:@"filename"];
            }
            
            [bean setValue:[rs stringForColumn:@"iswater"] forKey:@"iswater"];
            [bean setValue:[rs stringForColumn:@"nullable"] forKey:@"nullable"];
            NSString *path = [rs stringForColumn:@"path"];
            if (![path isEqualToString:@"(null)"]) {
                [bean setValue:path forKey:@"path"];
            }
            
            [bean setValue:[rs stringForColumn:@"photocode"] forKey:@"photocode"];
            [bean setValue:[rs stringForColumn:@"photoname"] forKey:@"photoname"];
            [bean setValue:[rs stringForColumn:@"phototype"] forKey:@"phototype"];
            [bean setValue:[rs stringForColumn:@"title"] forKey:@"title"];
            NSString *updater = [rs stringForColumn:@"updater"];
            if (![updater isEqualToString:@"(null)"]) {
                [bean setValue:updater forKey:@"updater"];
            }
            NSString *updatetime = [rs stringForColumn:@"updatetime"];
            if (![updatetime isEqualToString:@"(null)"]) {
                [bean setValue:updatetime forKey:@"updatetime"];
            }
            
            [arrM addObject:bean];
        }
        return arrM;
    }
    return nil;
}





@end
