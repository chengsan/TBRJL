//
//  ChooseView.m
//  TBRJL
//
//  Created by 陈浩 on 16/1/20.
//  Copyright © 2016年 陈浩. All rights reserved.
//

#import "ChooseView.h"

@interface ChooseView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIButton *coverBtn;
//@property (nonatomic ,strong) NSArray *arrs;
@end


@implementation ChooseView

-(NSArray *)dataSoures{
    if (!_dataSoures) {
        _dataSoures = [NSArray array];
    }
    return _dataSoures;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
        
    }
    return self;
}

-(void)initView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:window.bounds];
    coverBtn.backgroundColor = [UIColor blackColor];
    coverBtn.alpha = 0.3;
    [coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:coverBtn];
    self.coverBtn = coverBtn;
    
    UITableView *tv = [[UITableView alloc] initWithFrame:self.bounds];
    tv.backgroundColor = [UIColor lightGrayColor];
    tv.delegate = self;
    tv.dataSource = self;
    [self addSubview:tv];
    
}

-(void)coverBtnClick{
    self.coverBtn.hidden = YES;
    self.hidden = YES;
    
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoures.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"carno";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.dataSoures[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *title = self.dataSoures[indexPath.row];
    if (self.block != nil) {
        self.block(title);
    }
    self.coverBtn.hidden = YES;
    self.hidden = YES;
}


//   动画展现moreMenuView
-(void)presentToWindowWithDuration:(NSTimeInterval)duration{
    
    self.hidden = NO;
    self.coverBtn.hidden = NO;
    self.alpha = 1.0;
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = duration;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
    
}
@end
