//
//  QueryViewController.m
//  TBRJL
//
//  Created by 陈浩 on 15/12/18.
//  Copyright © 2015年 陈浩. All rights reserved.
//

#import "QueryViewController.h"
#import "HistoryViewController.h"
#import "SearchParameters.h"
#import "HistoryCell.h"
#import "BaoDanInfoController.h"
@interface QueryViewController ()<UITableViewDelegate,UITableViewDataSource>
//  投保人
@property (weak, nonatomic) IBOutlet UITextField *snameTextField;
//  保单号
@property (weak, nonatomic) IBOutlet UITextField *safenoTextField;
//  身份证
@property (weak, nonatomic) IBOutlet UITextField *cardnoTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


@property (nonatomic ,strong) NSArray *array;
- (IBAction)resetBtnClick;
- (IBAction)selectBtnClick;

@end

@implementation QueryViewController
-(NSArray *)array{
    if (!_array) {
        _array = [NSArray array];
    }
    return _array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询事务";
    self.resetBtn.layer.cornerRadius = 5;
    self.resetBtn.layer.masksToBounds = YES;
    self.resetBtn.backgroundColor =  [UIColor colorWithRed:76/255.0 green:129/255.0 blue:190/255.0 alpha:1];
    self.selectBtn.layer.cornerRadius = 5;
    self.selectBtn.layer.masksToBounds = YES;
    self.selectBtn.backgroundColor =  [UIColor colorWithRed:76/255.0 green:129/255.0 blue:190/255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//     获取数据
    [super showLoading:YES];
    [self getData];
    
}

-(void)getData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //----------------构造查询对象---------------
    SearchParameters *sp = [[SearchParameters alloc] init];
    NSDictionary *dict = [Globle getInstance].userInfoDic;
    [sp addParameter:@"userid" value:dict[@"id"] flag:11];
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

-(void)searchDataFinish:(id)result{
    if (result == nil) {
        [super showNotice:true];
    }
    [super showLoading:false];
    NSDictionary *dic = (NSDictionary *)result;
    _array = [dic objectForKey:@"result"];
    
    [_tableView reloadData];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

    BaoDanInfoController *bdInfoVc = [[BaoDanInfoController alloc] init];
    bdInfoVc.dict = _array[indexPath.row];
    [self.navigationController pushViewController:bdInfoVc animated:YES];
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
