//
//  SZTableViewCell.m
//  TBRJL
//
//  Created by user on 15/11/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "SZTableViewCell.h"
@interface SZTableViewCell ()


/**
 *  分割线
 */
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic ,strong) UIImageView *arrowView;

@property (nonatomic ,strong) UILabel *label;

@property (nonatomic ,strong) UITextField *textField;

@property (nonatomic ,strong) UISwitch *switchBtn;

@end

@implementation SZTableViewCell

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentRight;
        
    }
    return _label;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.3;
    }
    return _lineView;
}

-(UIImageView *)arrowView{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }
    return _arrowView;
}

-(UISwitch *)switchBtn{
    if (!_switchBtn ) {
        _switchBtn = [[UISwitch alloc] init];
        [_switchBtn addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

/**
 *  监听开关值的改变
 */
- (void)valueChanged{
   
    SZSettingSwitch *itemSwitch = (SZSettingSwitch *)self.item;
    
    itemSwitch.on = self.switchBtn.on;
    
    if ([itemSwitch.title isEqualToString:@"记住密码"] && itemSwitch.on) {
        NSLog(@"记住密码");
    }else if([itemSwitch.title isEqualToString:@"自动登录"] && itemSwitch.on){
        NSLog(@"自动登录");
    }else if([itemSwitch.title isEqualToString:@"退出时清除缓存"] && itemSwitch.on){
        NSLog(@"清除缓存");
    }else{
       
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellForTableView:(UITableView *)tableView{
    static NSString *ID = @"SZTableViewCell";
    SZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SZTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lineView];
    }
    return self;
}


// 赋值cell

-(void)setItem:(SZSettingItem *)item{
    _item = item;
    self.textLabel.text = item.title;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.selectionStyle = ([item isKindOfClass:[SZSettingSwitch class]] || [item isKindOfClass:[SZSettingLabel class]]) ? UITableViewCellSelectionStyleNone:UITableViewCellSelectionStyleDefault;
    
    if ([item isKindOfClass:[SZSettingSwitch class]]) {
        SZSettingSwitch *itemSwitch = (SZSettingSwitch *)item;
        self.switchBtn.on = itemSwitch.on;
        self.accessoryView = self.switchBtn;
        
    }else if([item isKindOfClass:[SZSettingArrow class]]){
               
        self.accessoryView = self.arrowView;
        
    }else if([item isKindOfClass:[SZSettingLabel class]]){
        
        SZSettingLabel *label = (SZSettingLabel *)item;
        self.label.text = label.text;
        self.accessoryView = self.label;
        
    }else{
        self.accessoryView = nil;
    }
}

//   是否隐藏分割线
-(void)setShowLine:(BOOL)showLine{
    _showLine = showLine;
    self.lineView.hidden = showLine;
}


//  布局
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat lineX = self.textLabel.frame.origin.x;
    CGFloat lineH = 1;
    CGFloat lineY = self.frame.size.height - lineH;
    CGFloat lineW = self.frame.size.width - lineX;
    self.lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
}
@end
