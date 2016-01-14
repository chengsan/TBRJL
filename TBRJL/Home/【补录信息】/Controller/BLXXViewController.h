//
//  BLXXViewController.h
//  TBRJL
//
//  Created by 程三 on 15/8/15.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaseViewController.h"
#import "FVCustomAlertView.h"

@interface BLXXViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *buxxTableView;
    //数据
    NSArray *dataArray;
    
}
@end
