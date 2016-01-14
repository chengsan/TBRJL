//
//  BPXXViewController.m
//  TBRJL
//
//  Created by 程三 on 15/8/15.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BPXXViewController.h"
#import "SearchParameters.h"
#import "BPXXCell.h"
#import "BaoDanInfoController.h"
#import "MJExtension.h"
#import "PhotoViewController.h"
@interface BPXXViewController()
@property (nonatomic ,strong) NSMutableArray *photoArr;
@end

@implementation BPXXViewController
-(NSMutableArray *)photoArr{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [super setTitle:@"补拍信息"];
    [self _initView];
    [self loadData];
   
}

#pragma mark 初始化UI
-(void)_initView
{
    bpxxTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    bpxxTableView.delegate = self;
    bpxxTableView.dataSource = self;
    [self.view addSubview:bpxxTableView];

}


#pragma mark 加载数据
-(void)loadData
{
    //显示加载提示
    [super showLoading:true];
    
    //获取登录人的id
    NSString *userid = [[Globle getInstance].userInfoDic objectForKey:@"id"];
    SearchParameters *search = [[SearchParameters alloc] init];
    [search setFillCodeValue:@"true"];
    [search addParameter:@"userid" value:userid flag:11];
    [search setOrder:@"createtime desc"];
    //当前为第几页
    [search setPageNum:[[NSNumber alloc] initWithInt:1]];
    //一页的数量
    [search setPageSize:[[NSNumber alloc] initWithInt:100]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[search getStringOfObject] forKey:@"par"];
    [params setValue:@"true" forKey:@"isBupai"];

    [[Globle getInstance].service requestWithServiceName:@"BBTone_getDataList" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result) {
        [self loadDataFinish:result];
    }];
    
}

#pragma mark 加载数据完成
-(void)loadDataFinish:(id)result
{
    //隐藏加载提示
    [super showLoading:false];
    
    if(result == nil)
    {
        [super showNotice:true];
        return;
    }
    
    NSDictionary *dic = result;
    
    if(nil == dic)
    {
        [super showNotice:true];
        return;
    }
    
    dataArray = [dic objectForKey:@"result"];
    
    if(dataArray == nil || dataArray.count == 0)
    {
        [super showNotice:true];
        return;
    }
    [bpxxTableView reloadData];
    
}



/**
 *  根据保单ID获取对应的照片数组
 */
-(void)setupPhotoWithID:(NSString *)idd{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"infoid"]= idd;
    [[Globle getInstance].service requestWithServiceName:@"BBTone_getDatainfo" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result) {
        NSMutableDictionary *dict = result;
        NSArray *res = dict[@"result"];
        NSMutableDictionary *dic = res[0];
        EntityBean *safeInfo = [self getSafeInfo:dic];
        [self.photoArr removeAllObjects];
        self.photoArr = [self getPhotoArr:dic[@"atts"]];
        [bpxxTableView reloadData];

        PhotoViewController *photoVc = [[PhotoViewController alloc] init];
        [photoVc setCurrentType:2];
        [photoVc setSafeInfo:safeInfo];
        [photoVc setPhotoArray:self.photoArr];
        [self.navigationController pushViewController:photoVc animated:YES];
    }];
}




//  获取照片信息数组
-(NSMutableArray *)getPhotoArr:(NSArray *)array{
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSMutableDictionary *att in array) {
        EntityBean *bean = [[EntityBean alloc]init];
        [bean setValue:att[@"bbtinfoid"] forKey:@"bbtinfoid"];
        [bean setValue:att[@"beanname"] forKey:@"beanname"];
        [bean setValue:att[@"code"] forKey:@"code"];
        [bean setValue:att[@"createtime"] forKey:@"createtime"];
        [bean setValue:att[@"creator"] forKey:@"creator"];
        [bean setValue:att[@"filename"] forKey:@"filename"];
        [bean setValue:att[@"id"] forKey:@"id"];
        [bean setValue:att[@"ishistory"] forKey:@"ishistory"];
        [bean setValue:att[@"isvalid"] forKey:@"isvalid"];
        [bean setValue:att[@"iswater"] forKey:@"iswater"];
        [bean setValue:att[@"namedpath"] forKey:@"namedpath"];
        [bean setValue:att[@"nullable"] forKey:@"nullable"];
        [bean setValue:att[@"photocode"] forKey:@"photocode"];
        [bean setValue:att[@"phototype"] forKey:@"phototype"];
        [bean setValue:att[@"title"] forKey:@"title"];
        [bean setValue:att[@"updater"] forKey:@"updater"];
        [bean setValue:att[@"updatetime"] forKey:@"updatetime"];
        [arrM addObject:bean];
    }
    return arrM;
}



//  转换成bean保单
-(EntityBean *)getSafeInfo:(NSMutableDictionary *)dict{
    EntityBean *bean = [[EntityBean alloc] init];
    [bean setValue:dict[@"areaid"] forKey:@"areaid"];
    [bean setValue:dict[@"beanname"] forKey:@"beanname"];
    [bean setValue:dict[@"cardno"] forKey:@"cardno"];
    [bean setValue:dict[@"checkstatus"] forKey:@"checkstatus"];
    [bean setValue:dict[@"companycode"] forKey:@"companycode"];
    [bean setValue:dict[@"companyname"] forKey:@"companyname"];
    [bean setValue:dict[@"companyno"] forKey:@"companyno"];
    [bean setValue:dict[@"createtime"] forKey:@"createtime"];
    [bean setValue:dict[@"creator"] forKey:@"creator"];
    [bean setValue:dict[@"hyname"] forKey:@"hyname"];
    [bean setValue:dict[@"id"] forKey:@"id"];
//    [bean setValue:dict[@"isprofessional"] forKey:@"isprofessional"];
    [bean setValue:dict[@"isread"] forKey:@"isread"];
    [bean setValue:dict[@"pcardno"] forKey:@"pcardno"];
    [bean setValue:dict[@"pcarno"] forKey:@"pcarno"];
    [bean setValue:dict[@"personorgname"] forKey:@"personorgname"];
    [bean setValue:dict[@"personorgno"] forKey:@"personorgno"];
    [bean setValue:dict[@"personorgtype"] forKey:@"personorgtype"];
    [bean setValue:dict[@"pname"] forKey:@"pname"];
    [bean setValue:dict[@"psafepay"] forKey:@"psafepay"];
    [bean setValue:dict[@"psafetypes"] forKey:@"psafetypes"];
    [bean setValue:dict[@"pwin"] forKey:@"pwin"];
    [bean setValue:dict[@"safecost"] forKey:@"safecost"];
    [bean setValue:dict[@"safeno"] forKey:@"safeno"];
    [bean setValue:dict[@"safetype"] forKey:@"safetype"];
    [bean setValue:dict[@"sname"] forKey:@"sname"];
    [bean setValue:dict[@"syscode"] forKey:@"syscode"];
//    [bean setValue:dict[@"trunbackreason"] forKey:@"trunbackreason"];
    [bean setValue:dict[@"updater"] forKey:@"updater"];
    [bean setValue:dict[@"updatetime"] forKey:@"updatetime"];
    [bean setValue:dict[@"userid"] forKey:@"userid"];
    [bean setValue:dict[@"sex"] forKey:@"sex"];
    [bean setValue:dict[@"age"] forKey:@"age"];

    return bean;
}


#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(dataArray != nil)
    {
        return dataArray.count;
    }
    return 0;
}

#pragma mark UITableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    BPXXCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[BPXXCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.clickBlock = ^{
        NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
        [weakSelf setupPhotoWithID:dict[@"id"]];
    };
    [cell setDataDic:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BPXXCell getCellheight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSMutableDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    BaoDanInfoController *baoDanInfoVc = [[BaoDanInfoController alloc]init];
    baoDanInfoVc.dict = dict;
    [self.navigationController pushViewController:baoDanInfoVc animated:YES];
 
    
}

//补全分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell  respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




@end
