//
//  CHButton.m
//  TBRJL
//
//  Created by 陈浩 on 16/1/22.
//  Copyright © 2016年 陈浩. All rights reserved.
//

#import "CHButton.h"
#import "UIView+Extension.h"
@interface CHButton ()
@property (nonatomic ,strong) UIButton *btn;



@property (nonatomic ,strong) UIImageView *imgView;

@end


@implementation CHButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}


-(void)initView{
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.btn = btn;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"闽";
    [btn addSubview:label];
    self.label = label;
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.backgroundColor = [UIColor lightGrayColor];
    imgView.image = [UIImage imageNamed:@"select_compary_icon"];
    [btn addSubview:imgView];
    self.imgView = imgView;
}



-(void)btnClick{
    if (self.btnBlock) {
        self.btnBlock();
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.btn.frame = self.bounds;
    
    self.label.frame = CGRectMake(0, 0, self.btn.w *0.7, self.h);
    
    self.imgView.frame = CGRectMake(CGRectGetMaxX(self.label.frame), 0, self.btn.w - self.label.w, self.h);
    
}





@end
