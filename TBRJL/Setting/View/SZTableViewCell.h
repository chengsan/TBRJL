//
//  SZTableViewCell.h
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZSettingItem.h"
#import "SZSettingLabel.h"
#import "SZSettingSwitch.h"
#import "SZSettingArrow.h"
@interface SZTableViewCell : UITableViewCell

@property (nonatomic ,strong) SZSettingItem *item;

+ (instancetype) cellForTableView:(UITableView *)tableView;

@property (nonatomic,assign) BOOL showLine;
@end
