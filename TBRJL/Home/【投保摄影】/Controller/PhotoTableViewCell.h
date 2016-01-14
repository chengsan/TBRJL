//
//  PhotoTableViewCell.h
//  TBRJL
//
//  Created by 程三 on 15/7/12.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityBean.h"

@interface PhotoTableViewCell : UITableViewCell
{
    UILabel *titleLabel;
    UILabel *markLabel;
    UIImageView *photoImageView;
    int currentType;//类型：0 新建／1:缓存／2:补拍／3:补录
}
@property(nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *markLabel;
-(void)setData:(EntityBean *)data;
-(void)setCurrentType:(int)type;
@end
