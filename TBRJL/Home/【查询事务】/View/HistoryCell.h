//
//  HistoryCell.h
//  TBRJL
//
//  Created by 程三 on 15/6/18.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property(nonatomic,retain)NSDictionary *data;
@property(nonatomic,retain)UILabel *kindLabel;
@property(nonatomic,retain)UILabel *personLabel;
@property(nonatomic,retain)UILabel *numLabel;
@property (nonatomic ,strong)UILabel *psafetypeLabel;
@property (nonatomic ,strong)UILabel *snameLabel;
@property (nonatomic ,strong)UILabel *safenoLabel;

-(void)setData:(NSDictionary *)data;
+(CGFloat)getCellheight:(NSDictionary *)data;

@end
