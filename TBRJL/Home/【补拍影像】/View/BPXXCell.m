//
//  BPXXCell.m
//  TBRJL
//
//  Created by 程三 on 15/8/15.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BPXXCell.h"
#import "UIViewExt.h"
#import "TBRJL-Prefix.pch"
#import "PublicClass.h"
@implementation BPXXCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        //self.selectedBackgroundView.backgroundColor = [UIColor blueColor];
        
        [self _initView];
    }
    
    return self;
}

#pragma mark 初始化UI
-(void)_initView
{
    kindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    kindLabel.text = @"险种:";
    kindLabel.textColor = [PublicClass colorWithHexString:@"#04a3fe"];
    kindLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:kindLabel];
    
    psafetypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    psafetypeLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    psafetypeLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:psafetypeLabel];
    
    
    personLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    personLabel.text = @"投保人:";
    personLabel.textColor = [PublicClass colorWithHexString:@"#04a3fe"];
    personLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:personLabel];
    
    snameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    snameLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    snameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:snameLabel];
    
    
    numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    numLabel.text = @"保单号:";
    numLabel.textColor =[PublicClass colorWithHexString:@"#04a3fe"];
    numLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:numLabel];
    
    safenoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    safenoLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    safenoLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:safenoLabel];
    
    
    bpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bpBtn.frame =CGRectZero;
    [bpBtn.layer setCornerRadius:5];
    bpBtn.tag = 101;
    [bpBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_bp_press"] forState:UIControlStateNormal];
    [bpBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_bp_normal"] forState:UIControlStateHighlighted];
    [bpBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:bpBtn];
}

#pragma mark 设置数据
-(void)setDataDic:(NSDictionary *)dic
{
    dataDic = dic;
    if(dic != nil)
    {
        psafetypeLabel.text = [TBPUtil getSafeTypeNameByCode:[dic objectForKey:@"psafetypes"]];
        snameLabel.text = [dic objectForKey:@"sname"];
        safenoLabel.text = [dic objectForKey:@"safeno"];
    }
}

#pragma mark 重新设置UI的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int leftMarg = 20;
    int height = 30;
    kindLabel.frame = CGRectMake(leftMarg, 10, 60, height);
    
    psafetypeLabel.frame = CGRectMake(CGRectGetMaxX(kindLabel.frame), 10, 100, height);
    
    personLabel.frame = CGRectMake(leftMarg, kindLabel.bottom, 60, height);
    snameLabel.frame = CGRectMake(CGRectGetMaxX(personLabel.frame), kindLabel.bottom, 100, height);
    
    numLabel.frame = CGRectMake(leftMarg, personLabel.bottom,60, height);
    safenoLabel.frame = CGRectMake(CGRectGetMaxX(numLabel.frame), personLabel.bottom, 200, height);
    int widthBtn = 40;
    bpBtn.frame = CGRectMake(ScreenWidth - 50 -20, 35, widthBtn, 40);
}

#pragma mark 计算Cell的高度
+(CGFloat)getCellheight
{
    return 10 + 30 *3+10;
}

#pragma mark 点击回调方法
-(void)onClick:(UIButton *)btn
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
