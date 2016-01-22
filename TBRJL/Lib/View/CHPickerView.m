//
//  CHPickerView.m
//  TBRJL
//
//  Created by lili on 15/10/14.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "CHPickerView.h"

@interface CHPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
/**
 *  工具条
 */
@property (nonatomic,weak) CZKeyboardTool *keyboardTool;

/**
 *  遮盖按钮
 */
@property (nonatomic,strong) UIButton *cover;



/**
 *  选择器
 */
@property (nonatomic,weak) UIPickerView *pickerView;
@end

@implementation CHPickerView

-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (UIButton *)cover {
    if (_cover == nil) {
        _cover = [[UIButton alloc] init];
        _cover.backgroundColor = [UIColor clearColor];
        [_cover addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cover;
}


/**
 *  创建日期选择器
 *
 */
+(instancetype)pickerView{
    return [[CHPickerView alloc] init];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}
/**
 *  创建子控件
 */
- (void)setup{
    // 创建键盘工具条
    CZKeyboardTool *keyboardTool = [CZKeyboardTool keyboardTool];
    [self addSubview:keyboardTool];
    
    __weak typeof(self) weakSelf = self;
    keyboardTool.clickBlock = ^(CZKeyboardToolButtonType buttonType){
        // 隐藏工具条
        [weakSelf dismiss];
        if ([weakSelf.delegate respondsToSelector:@selector(PickerView:didClickBtnType:)]) {
            [weakSelf.delegate PickerView:weakSelf didClickBtnType:buttonType];
        }
     
    };
    self.keyboardTool = keyboardTool;
    
    // 创建日期选择器
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
    self.pickerView = pickerView;
}




/**
 *  布局子控件
 */
-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.keyboardTool.frame;
    frame.size.width = self.frame.size.width;
    frame.size.height = 44;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.keyboardTool.frame = frame;
    
    CGFloat pickerY = CGRectGetMaxY(self.keyboardTool.frame);
    CGFloat pickerW = self.frame.size.width;
    CGFloat pickerH = 216;
    self.pickerView.frame = CGRectMake(0, pickerY, pickerW, pickerH);
}

/**
 *  显示日期选择器
 */
-(void)show{
    // 获得窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 获得窗口的宽高
    CGFloat windowH = CGRectGetHeight(window.frame);
    CGFloat windowW = CGRectGetWidth(window.frame);
    // 设置当前view的高度
    CGFloat height = 260;
    
    // 添加遮盖按钮
    self.cover.frame = window.bounds;;
    [window addSubview:self.cover];
    
    self.frame = CGRectMake(0, windowH, windowW, height);
    [window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = windowH - height;
        self.frame = frame;
    }];
    
}
/**
 *  隐藏日期选择器
 */
-(void)dismiss{
    // 获得窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 获得窗口的高
    CGFloat windowH = CGRectGetHeight(window.frame);
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = windowH;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        // 移除遮盖
        [self.cover removeFromSuperview];
        _cover = nil;
    }];
}


#pragma mark - UIPickerViewDataSource 数据源方法
//  列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//  每列个数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
     
}



#pragma mark - UIPickerViewDelegate 代理方法
//   每列高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
       self.title = [self.dataSource objectAtIndex:component];
    }
    
    return [self.dataSource objectAtIndex:row];
   
}

//  选中选中的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.title = [self.dataSource objectAtIndex:row];
   
}



@end
