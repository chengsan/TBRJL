//
//  BPXXViewController.h
//  TBRJL
//
//  Created by 程三 on 15/8/15.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaseViewController.h"

@interface BPXXViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *bpxxTableView;
    NSArray *dataArray;
}
@end
