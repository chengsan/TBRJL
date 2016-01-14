//
//  HistoryViewController.m
//  TBRJL
//
//  Created by 程三 on 15/6/16.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "HistoryViewController.h"
#import "SearchParameters.h"
#import "HistoryCell.h"
#import "BaoDanInfoController.h"

@implementation HistoryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self _initView];
    [self loadData];
    
    
}

-(void)_initView
{
    [self setTitle:@"事务查询"];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

-(void)loadData
{
    [super showLoading:true];
    [self searchData];
}

-(void)searchData
{
    NSLog(@"查询数据");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //----------------构造查询对象---------------
    SearchParameters *sp = [[SearchParameters alloc] init];
    NSDictionary *dict = [Globle getInstance].userInfoDic;
    [sp addParameter:@"userid" value:dict[@"id"] flag:11];
    [sp addParameter:@"cardno" value:self.cardno flag:12];
    [sp addParameter:@"sname" value:self.sname flag:12];
    [sp addParameter:@"safeno" value:self.safeno flag:12];

    sp.pageNum = [[NSNumber alloc] initWithInt:1];
    sp.pageSize = [[NSNumber alloc] initWithInt:10];;
    sp.pageCount = [[NSNumber alloc] initWithInt:10];;
    NSString *string = [sp getStringOfObject];
    [params setValue:string forKey:@"par"];
    [params setValue:@"false" forKey:@"isBupai"];
    //设置相应内容类型
    
    [[Globle getInstance].service requestWithServiceName:@"BBTone_getDataList" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result)
     {
         
         [self searchDataFinish:result];
    }];
    
}

//数据加载完成
-(void)searchDataFinish:(id)result
{
    /*
     age = "-1";
     areaid = 350000000000000000;
     atts = "[Lcom.longrise.LEAP.Base.Objects.EntityBean;@169d97ec";
     beanname = BBToneInfo;
     cardno = 350701198610200159;
     cardtype = 01;
     checkstatus = 0;
     companycode = 350000003001;
     companyname = "\U4eba\U4fdd\U8d22\U9669";
     companyno = 3001;
     createtime = "2015-05-28 16:08:14.983";
     creator = "\U95fd\U5b9d\U901a";
     hyname = "\U4fdd\U5b9d\U901a\U6d4b\U8bd52";
     id = 239ae55fb2d84f75a31af29423047cee;
     isprofessional = 1;
     isqrcode = 0;
     isread = 0;
     pcardno = 350701198610200159;
     pcardtype = 01;
     personorgname = "\U6df1\U5733\U6c38\U5174\U5143\U4fdd\U5b9d\U7f51";
     personorgno = 350000005050;
     personorgtype = 2;
     pname = "\U6d4b\U8bd5";
     psafedate = "2015-05-28 00:00:00";
     psafedateend = "2017-06-29 00:00:00";
     psafepay = "42587.00";
     psafetypes = 102;
     safecost = "85245864.00";
     safeno = 5636974;
     safetype = 1;
     sex = "-1";
     sname = "\U6d4b\U8bd5";
     syscode = "34.001001000000000000000000000000000";
     upversion = "androidv1.1.6";
     userid = b8cbbbc5f22b4570b3c879966df7a241;
     version = "androidv1.1.6";
     */
    if (result == nil) {
        [super showNotice:true];
    }
    [super showLoading:false];
    NSDictionary *dic = (NSDictionary *)result;
    _array = [dic objectForKey:@"result"];
    
    [_tableView reloadData];
}

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if(cell == nil)
    {
        cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    //获取数据
    NSDictionary *data = [_array objectAtIndex:indexPath.row];
    [cell setData:data];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取数据
    NSDictionary *data = [_array objectAtIndex:indexPath.row];
    return [HistoryCell getCellheight:data];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%d",indexPath.row);
    BaoDanInfoController *bdInfoVc = [[BaoDanInfoController alloc] init];
    bdInfoVc.dict = _array[indexPath.row];
    [self.navigationController pushViewController:bdInfoVc animated:YES];
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
