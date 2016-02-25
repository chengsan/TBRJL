//
//  ZCCell.m
//  TBRJL
//
//  Created by lili on 15/11/9.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "ZCCell.h"
#import "PublicClass.h"
#define KWHeight 100
#define KHeight 30
#define LeftMargin 20
#define UIScreenW [UIScreen mainScreen].bounds.size.width
@interface ZCCell()

@property (strong, nonatomic) UILabel *safeType;

@property (strong, nonatomic) UILabel *sname;
@property (strong, nonatomic) UILabel *safeno;

@property (strong, nonatomic) UILabel *safeLabel;

@property (strong, nonatomic) UILabel *snameLabel;

@property (strong, nonatomic) UILabel *safeNoLabel;

@property (nonatomic ,strong) UIButton *editBtn;
@property (nonatomic ,strong) UIButton *scanBtn;
@property (nonatomic ,strong) UIButton *deleBtn;


@end


@implementation ZCCell
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ZC";
    ZCCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}



//  代码创建cell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}


- (void)initView{
    _safeType = [[UILabel alloc] init];
    _safeType.textColor = [PublicClass colorWithHexString:@"#04a3fe"];
    _safeType.font = [UIFont systemFontOfSize:14];
    _safeType.text = @"险种:";
    [self.contentView addSubview:_safeType];
    _sname = [[UILabel alloc] init];
    _sname.textColor = [PublicClass colorWithHexString:@"#04a3fe"];
    _sname.font = [UIFont systemFontOfSize:14];
    _sname.text = @"投保人:";
    [self.contentView addSubview:_sname];
    _safeno = [[UILabel alloc] init];
    _safeno.textColor = [PublicClass colorWithHexString:@"#04a3fe"];
    _safeno.font = [UIFont systemFontOfSize:14];
    _safeno.text = @"保单号:";
    [self.contentView addSubview:_safeno];

   
    _safeLabel = [[UILabel alloc] init];
    _safeLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    _safeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_safeLabel];
    
    _snameLabel = [[UILabel alloc] init];
    _snameLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    _snameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_snameLabel];
    
    _safeNoLabel = [[UILabel alloc] init];
    _safeNoLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    _safeNoLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_safeNoLabel];
    
    _editBtn = [[UIButton alloc] init];
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_sglr_normal"] forState:UIControlStateNormal];
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_sglr_press"] forState:UIControlStateHighlighted];
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    _scanBtn = [[UIButton alloc] init];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_camera_normal"] forState:UIControlStateNormal];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_camera_press"] forState:UIControlStateHighlighted];
    [_scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_scanBtn];

    _deleBtn = [[UIButton alloc] init];
    [_deleBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_del_normal"] forState:UIControlStateNormal];
    [_deleBtn setBackgroundImage:[UIImage imageNamed:@"tbsy_del_press"] forState:UIControlStateHighlighted];
    [_deleBtn addTarget:self action:@selector(deleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleBtn];
}


-(void)setBean:(EntityBean *)bean{
    _bean = bean;
    NSString *txt = nil;
    NSString *psafetypes = (NSString *)[bean objectForKey:@"psafetypes"];
        NSLog(@"psafetypes  %@",psafetypes);
        if([@"001" isEqualToString:psafetypes])
        {
            txt = @"普通寿险";
        }
        else if ([@"002" isEqualToString:psafetypes])
        {
            txt = @"分红型寿险";
        }
        else if ([@"003" isEqualToString:psafetypes])
        {
            txt = @"投资连结保险";
        }
        else if ([@"004" isEqualToString:psafetypes])
        {
            txt = @"健康保险";
        }
        else if ([@"005" isEqualToString:psafetypes])
        {
            txt = @"万能保险";
        }
        else if ([@"006" isEqualToString:psafetypes])
        {
            txt = @"意外伤害保险";
        }
        else if ([@"101" isEqualToString:psafetypes])
        {
            txt = @"车险";
        }
        else if ([@"102" isEqualToString:psafetypes])
        {
            txt = @"家财险";
        }
        else if ([@"103" isEqualToString:psafetypes])
        {
            txt =@"责任险";
        }
        else if ([@"104" isEqualToString:psafetypes])
        {
            txt = @"意外险";
        }
        else
        {
            txt = @"";
        }
        if(txt != nil && ![@"" isEqualToString:txt])
        {
            self.safeLabel.text = txt;
            
        }
        self.snameLabel.text = (NSString *)[bean objectForKey:@"sname"];
        self.safeNoLabel.text = (NSString *)[bean objectForKey:@"safeno"];
       

    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    _safeType.frame = CGRectMake(LeftMargin, 10, 60, KHeight);
    _safeLabel.frame = CGRectMake(CGRectGetMaxX(_safeType.frame), 10, 100, KHeight);
    _sname.frame = CGRectMake(LeftMargin, CGRectGetMaxY(_safeType.frame), 60, KHeight);
    _snameLabel.frame = CGRectMake(CGRectGetMaxX(_sname.frame), CGRectGetMaxY(_safeType.frame), UIScreenW - CGRectGetMaxX(_sname.frame), KHeight);
    _safeno.frame = CGRectMake(LeftMargin, CGRectGetMaxY(_sname.frame),60, KHeight);
    _safeNoLabel.frame = CGRectMake(CGRectGetMaxX(_safeno.frame), CGRectGetMaxY(_sname.frame), UIScreenW - CGRectGetMaxX(_safeno.frame) , KHeight);
    
    
    float marg = (UIScreenW - KHeight * 3 - 2* 40)/2;
    _editBtn.frame = CGRectMake(40, CGRectGetMaxY(_safeno.frame) + 10, KHeight, KHeight);
    
    _scanBtn.frame = CGRectMake(CGRectGetMaxX(_editBtn.frame) + marg,CGRectGetMaxY(_safeno.frame)+ 10, KHeight, KHeight);
    
    _deleBtn.frame = CGRectMake(CGRectGetMaxX(_scanBtn.frame) + marg, CGRectGetMaxY(_safeno.frame) + 10, KHeight                                                                                                     , KHeight);

    
    
    
    
}

//    编辑保单信息
- (void)editBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(didBtnClickWithTag:Type:)]) {
        btn.tag = self.tag;
         [self.delegate didBtnClickWithTag:btn.tag Type:ZCCellBtnTypePolicy];
    }
   
    
}

// 扫描保单信息
- (void)scanBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(didBtnClickWithTag:Type:)]) {
        btn.tag = self.tag;
        [self.delegate didBtnClickWithTag:btn.tag Type:ZCCellBtnTypeScanf];
    }
    
}


//   删除保单
- (void)deleBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(didBtnClickWithTag:Type:)]) {
        btn.tag = self.tag;
        [self.delegate didBtnClickWithTag:btn.tag Type:ZCCellBtnTypeDel];
    }
    
}

+(CGFloat)getCellheight
{
    return 10 + 30 *3 + 40 + 10;
}
@end
