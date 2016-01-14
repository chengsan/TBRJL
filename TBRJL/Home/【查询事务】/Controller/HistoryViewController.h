//
//  HistoryViewController.h
//  TBRJL
//
//  Created by 程三 on 15/6/16.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaseViewController.h"

@interface HistoryViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic ,copy) NSString *sname;
@property (nonatomic ,copy) NSString *safeno;
@property (nonatomic ,copy) NSString *cardno;

@end
