//
//  BLXXViewController.m
//  TBRJL
//
//  Created by 程三 on 15/8/15.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BLXXViewController.h"
#import "Globle.h"
#import "SearchParameters.h"
#import "BLXXCell.h"

@implementation BLXXViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [super setTitle:@"补录信息"];
    [self _initView];
    [self loadData];
}

-(void)_initView
{
    buxxTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    buxxTableView.delegate = self;
    buxxTableView.dataSource = self;
    [self.view addSubview:buxxTableView];
}

//加载数据
-(void)loadData
{
    [super showLoading:true];
    
    //获取用户id
    NSString *userId = [[Globle getInstance].userInfoDic objectForKey:@"id"];
    SearchParameters *search = [[SearchParameters alloc] init];
    [search setFillCodeValue:@"true"];
    [search addParameter:@"userid" value:userId flag:11];
    [search setOrder:@"createtime desc"];
    //审核状态
    [search addParameter:@"checkstatus" value:[[NSNumber alloc] initWithInt:3] flag:11];
    [search setPageSize:[[NSNumber alloc] initWithInt:100]];
    [search setPageNum:[[NSNumber alloc] initWithInt:1]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[search getStringOfObject] forKey:@"par"];
    [params setValue:@"false" forKey:@"isBupai"];
    
    [[Globle getInstance].service requestWithServiceName:@"BBTone_getDataList" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result)
    {
//        NSLog(@"补录的数据   %@",result);
        [self loadDataFinish:result];
    } ];
    
}

//加载完成调用方法
-(void)loadDataFinish:(id)result
{
    [super showLoading:false];
    
    if(result == nil)
    {
        [super showNotice:true];
        return;
    }
    
    NSDictionary *dic = result;
    if(dic == nil)
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
    
    //刷新界面
    [buxxTableView reloadData];
}

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil != dataArray)
    {
        return dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    BLXXCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[BLXXCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setBLXXViewController:self];
    [cell setDataDic:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BLXXCell getCellheight];
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
