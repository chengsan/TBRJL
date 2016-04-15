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
+(instancetype)cellForTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
