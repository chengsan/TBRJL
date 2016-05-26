//
//  ZCViewController.m
//  TBRJL
//
//  Created by lili on 15/11/9.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "ZCViewController.h"
#import "ZCCell.h"
#import "SGLRViewController.h"
#import "QRCodeViewController.h"

@interface ZCViewController ()<ZCCellDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray *policyArr;      //  存储保单数据的容器
@property (nonatomic ,strong)NSMutableArray *photoArr;      //  存储保单图片的容器
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) EntityBean *bean;

@end

@implementation ZCViewController


-(NSMutableArray *)policyArr{
    if (!_policyArr) {
        _policyArr = [NSMutableArray array];
    }
    return _policyArr;
}



-(NSMutableArray *)photoArr{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"暂存事务";
    [self.policyArr removeAllObjects];
  
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//     获取保单数据
    
   self.policyArr = [self getPolicyDataWithUserID:(NSString *)[Util getValue:CHAccount]];
    
    self.policyArr = self.policyArr.count >0?self.policyArr:[self getMatchData];

    if (self.policyArr.count == 0) {
        [super showNotice:true];
    }
   
}



//   删除存储到本地的图片
-(void)deletePolicyImageWithCreatTime:(NSString *)creatTime fileName:(NSString *)fileName{
    
    self.photoArr = [self getImagePathWithCreatTime:creatTime];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *photoDic = photoInfoDic;
       NSString *path =  [photoDic stringByAppendingPathComponent:fileName];
       NSLog(@"图片存储的地址%@",path);
       BOOL isDel =  [manager removeItemAtPath:path error:nil];
        if (isDel) {
            NSLog(@"删除成功");
        }else{
            NSLog(@"删除失败");
        }
    
}


#pragma mark - UITableViewDataSource 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.policyArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZCCell *cell = [ZCCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.bean = self.policyArr[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelate 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZCCell getCellheight];
}



#pragma mark - ZCCellDelegate
-(void)didBtnClickWithTag:(NSInteger)tag Type:(ZCCellBtnType)type{
    
    if (type == ZCCellBtnTypePolicy) {     //编辑保单
        
        SGLRViewController *sglrVC = [[SGLRViewController alloc] init];
        EntityBean *safeInfo = self.policyArr[tag];
        NSString *creatTime = (NSString *)[safeInfo objectForKey:@"creattime"];
        NSLog(@"跳转界面的创建时间%@",creatTime);
        [self.photoArr removeAllObjects];
         self.photoArr = [self getImagePathWithCreatTime:creatTime];
        
        [sglrVC setSafeInfo:safeInfo];
        [sglrVC setCurrentType:1];
        [sglrVC setPhotoArray:self.photoArr];
        [self.navigationController pushViewController:sglrVC animated:YES];

    }else if(type == ZCCellBtnTypeScanf){    // 扫描保单
        
        QRCodeViewController *qrCodeVc = [[QRCodeViewController alloc] init];
        EntityBean *safeInfo = self.policyArr[tag];
        NSString *creatTime = (NSString *)[safeInfo objectForKey:@"creattime"];
        [self.photoArr removeAllObjects];
         self.photoArr = [self getImagePathWithCreatTime:creatTime];
        
        [qrCodeVc setCurrentType:1];
        [qrCodeVc setSafeInfo:safeInfo];
        [qrCodeVc setPhotoArray:self.photoArr];
        [self.navigationController pushViewController:qrCodeVc animated:YES];
        
        
    }else if(type == ZCCellBtnTypeDel){     // 删除
        
        self.bean = self.policyArr[tag];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        
    }else{
        return;
    }
}





#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *creatTime = (NSString *)[self.bean objectForKey:@"creattime"];
   //   删除保单
       BOOL isDelPolicy = [self deleteTableByCreatTime:creatTime TableName:@"policy"];
   //  先删除存储的图片
        [self deletePolicyImageWithCreatTime:creatTime fileName:(NSString *)[self.bean objectForKey:@"time"]];
    //   删除保单图片数据
       BOOL isDelPolicyImage = [self deleteTableByCreatTime:creatTime TableName:@"policyimage"];
        
        if (isDelPolicy && isDelPolicyImage) {
                [MBProgressHUD showSuccess:@"删除成功"];
                self.policyArr = nil;
                self.policyArr =  [self getPolicyDataWithUserID:(NSString *)[Util getValue:CHAccount]];
                self.policyArr = self.policyArr.count >0?self.policyArr:[self getMatchData];
            
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showError:@"删除失败"];
            }
    }
}



@end

