//
//  BaoDanCell.h
//  TBRJL
//
//  Created by Charls on 15/12/10.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoDanModel.h"
@interface BaoDanCell : UITableViewCell
@property (nonatomic ,strong) BaoDanModel *model;



@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *detailLabel;

+ (instancetype)cellForTableView:(UITableView *)tableView;


@end
