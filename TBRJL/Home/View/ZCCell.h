//
//  ZCCell.h
//  TBRJL
//
//  Created by lili on 15/11/9.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolicyModel.h"
#import "EntityBean.h"
typedef enum{
    ZCCellBtnTypePolicy,     //  保单编辑
    ZCCellBtnTypeScanf,      //   扫描
    ZCCellBtnTypeDel         //   删除
}ZCCellBtnType;



@class ZCCell;
@protocol ZCCellDelegate <NSObject>

-(void)didBtnClickWithTag:(NSInteger)tag Type:(ZCCellBtnType)type;


@end



@interface ZCCell : UITableViewCell

@property (nonatomic ,assign)ZCCellBtnType Btntype;

@property (nonatomic ,strong)PolicyModel *model;

@property (nonatomic ,strong)EntityBean *bean;

@property (nonatomic ,strong)id <ZCCellDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView ;

+(CGFloat)getCellheight;
@end
