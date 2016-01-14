//
//  BPXXCell.h
//  TBRJL
//
//  Created by 程三 on 15/8/15.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBPUtil.h"
typedef void (^BpBtnClickBlock)();

@interface BPXXCell : UITableViewCell
{
    UIButton *infoBtn;
    UIButton *bpBtn;
    
    UILabel *kindLabel;
    UILabel *personLabel;
    UILabel *numLabel;
    
    UILabel *psafetypeLabel;
    UILabel *snameLabel;
    UILabel *safenoLabel;
    
    
    NSDictionary *dataDic;
}
@property (nonatomic ,copy)BpBtnClickBlock clickBlock;
-(void)setDataDic:(NSDictionary *)dic;
+(CGFloat)getCellheight;


@end
