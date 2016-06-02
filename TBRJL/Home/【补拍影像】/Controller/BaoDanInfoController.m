//
//  BaoDanInfoController.m
//  TBRJL
//
//  Created by user on 15/11/11.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaoDanInfoController.h"
#import "BaoDanCell.h"
@interface BaoDanInfoController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) NSMutableArray *arr;

@end

@implementation BaoDanInfoController
-(NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"保单详情";
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 40)];
    tableView.tableFooterView = footView;
}


-(void)setDict:(NSMutableDictionary *)dict{
    _dict = dict;
    NSLog(@" -------%@",dict);
    if (dict[@"trunbackreason"] != nil) {
    BaoDanModel *model = [[BaoDanModel alloc] init];
    model.result =  dict[@"trunbackreason"];
    model.title = @"补拍原因";
    [self.arr addObject:model];
    }
    if (dict[@"bulureason"] != nil){
        BaoDanModel *model = [[BaoDanModel alloc]init];
        model.result = dict[@"bulureason"];
        model.title = @"补录原因";
        [self.arr addObject:model];
    }
    
    if (dict[@"safeno"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"safeno"];
        model.title = @"保单号";
        [self.arr addObject:model];
    }
    if (dict[@"sname"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"sname"];
        model.title = @"投保人姓名";
        [self.arr addObject:model];
    }
    if (dict[@"cardno"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"cardno"];
        model.title = @"投保人证件号";
        [self.arr addObject:model];
    }
    if (dict[@"pname"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"pname"];
        model.title = @"被保险人姓名";
        [self.arr addObject:model];
    }
    if (dict[@"pcardno"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"pcardno"];
        model.title = @"被保险人证件号名";
        [self.arr addObject:model];
    }
    if (dict[@"psafetypes"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  [self setSafeTypesWithResult:dict[@"psafetypes"]];
        model.title = @"险种";
        [self.arr addObject:model];
    }
    if (dict[@"pcarno"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"pcarno"];
        model.title = @"车牌";
        [self.arr addObject:model];
    }
    if (dict[@"pwin"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"pwin"];
        model.title = @"车架号";
        [self.arr addObject:model];
    }
    if (dict[@"sex"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        if ([dict[@"sex"] isEqualToString:@"0"]) {
             model.result =  @"女";
        }else{
            model.result = @"男";
        }
        model.title = @"性别";
        [self.arr addObject:model];
    }
    
    if (dict[@"age"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"age"];
        model.title = @"年龄";
        [self.arr addObject:model];
    }
  
    if (dict[@"safecost"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"safecost"];
        model.title = @"保费(元)";
        [self.arr addObject:model];
    }
    if (dict[@"psafepay"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"psafepay"];
        model.title = @"保额(元)";
        [self.arr addObject:model];
    }
    if (dict[@"psafedate"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"psafedate"];
        model.title = @"保险起期";
        [self.arr addObject:model];
    }
    if (dict[@"psafedateend"] != nil) {
        BaoDanModel *model = [[BaoDanModel alloc] init];
        model.result =  dict[@"psafedateend"];
        model.title = @"保险止期";
        [self.arr addObject:model];
    }
    
}




//  返回对应的险种字符串
-(NSString *)setSafeTypesWithResult:(NSString *)result{

    NSString *txt = nil;
    if([@"001" isEqualToString:result])
    {
        txt = @"普通寿险";
    }
    else if ([@"002" isEqualToString:result])
    {
        txt = @"分红型寿险";
    }
    else if ([@"003" isEqualToString:result])
    {
        txt = @"投资连结保险";
    }
    else if ([@"004" isEqualToString:result])
    {
        txt = @"健康保险";
    }
    else if ([@"005" isEqualToString:result])
    {
        txt = @"万能保险";
    }
    else if ([@"006" isEqualToString:result])
    {
        txt = @"意外伤害保险";
    }
    else if ([@"101" isEqualToString:result])
    {
        txt = @"车险";
    }
    else if ([@"102" isEqualToString:result])
    {
        txt = @"家财险";
    }
    else if ([@"103" isEqualToString:result])
    {
        txt =@"责任险";
    }
    else if ([@"104" isEqualToString:result])
    {
        txt = @"意外险";
    }
    else
    {
        txt = @"";
    }
    if(txt != nil && ![@"" isEqualToString:txt])
    {
        return txt;
    }
    return nil;
}






-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaoDanCell *cell = [BaoDanCell cellForTableView:tableView];
    cell.model = self.arr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BaoDanModel *model = self.arr[indexPath.row];
    
    if (model.cellHeight > 44) {
        
        return model.cellHeight;
    }
    
    return 44;
   
  }


//
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
