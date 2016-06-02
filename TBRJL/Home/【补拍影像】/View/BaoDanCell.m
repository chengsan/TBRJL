//
//  BaoDanCell.m
//  TBRJL
//
//  Created by Charls on 15/12/10.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaoDanCell.h"
#import "PublicClass.h"
#import "UIViewExt.h"
@interface BaoDanCell()

@property (nonatomic ,assign) CGSize cellSize;
@end
@implementation BaoDanCell



-(void)initViews{
   _titleLabel = [[UILabel alloc] init];
   _titleLabel.textColor =  [PublicClass colorWithHexString:@"#04a3fe"];
    _titleLabel.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textColor =  [PublicClass colorWithHexString:@"#636363"];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.numberOfLines = 0;
    
    
    
    [self addSubview:_titleLabel];
    [self addSubview:_detailLabel];
}


//    赋值
-(void)setModel:(BaoDanModel *)model{
    _model = model;

    _titleLabel.text = model.title;
    _detailLabel.text = model.result;
    if ([_titleLabel.text isEqualToString:@"补拍原因"] || [_titleLabel.text isEqualToString:@"补录原因"]) {
        self.detailLabel.textColor = [UIColor redColor];
     
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellForTableView:(UITableView *)tableView{
    static NSString *ID = @"BaoDanCell";
    BaoDanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BaoDanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}







-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize  selfSize = self.bounds.size;
    
    _titleLabel.frame = CGRectMake(0, 0, 80, selfSize.height);
    
    _detailLabel.frame = CGRectMake(85, 0, selfSize.width- 85, selfSize.height);
}
@end
