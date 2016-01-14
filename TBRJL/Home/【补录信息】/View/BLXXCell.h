//
//  BLXXCell.h
//  TBRJL/Users/charls/Desktop/TBRJL原始版本副本 3/TBRJL.xcodeproj
//
//  Created by 程三 on 15/8/15.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVCustomAlertView.h"
#import "SGLRViewController.h"
#import "BLXXViewController.h"
#import "EntityBean.h"
#import "TBPUtil.h"

@interface BLXXCell : UITableViewCell
{
    UIButton *infoBtn;
    UIButton *sglrBtn;
    UIButton *ewmBtn;
    
 
    UILabel *kindLabel;
    UILabel *personLabel;
    UILabel *numLabel;
    
    UILabel *psafetypeLabel;
    UILabel *snameLabel;
    UILabel *safenoLabel;

  
    NSDictionary *dataDic;
    
    //加载提示
    FVCustomAlertView *customAlert;
    
    BLXXViewController *blxxViewController;
}

-(void)setDataDic:(NSDictionary *)dic;
-(void)setBLXXViewController:(BLXXViewController *)viewController;
+(CGFloat)getCellheight;

@end
