//
//  HistoryCell.m
//  TBRJL
//
//  Created by 程三 on 15/6/18.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "HistoryCell.h"
#import "UIViewExt.h"
#import "TBRJL-Prefix.pch"
#import "PublicClass.h"
@implementation HistoryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self _initView];
    }
    
    return self;
}

//初始化UI
-(void)_initView
{
    _kindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _kindLabel.text = @"险种:";
    _kindLabel.textColor = [PublicClass colorWithHexString:@"#04a3fe"];
    _kindLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_kindLabel];
    
    _psafetypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _psafetypeLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    _psafetypeLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_psafetypeLabel];
    
    
    _personLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _personLabel.text = @"投保人:";
    _personLabel.textColor = [PublicClass colorWithHexString:@"#04a3fe"];
    _personLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_personLabel];
    
    _snameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _snameLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    _snameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_snameLabel];
    
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _numLabel.text = @"保单号:";
    _numLabel.textColor =[PublicClass colorWithHexString:@"#04a3fe"];
    _numLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_numLabel];
    
    _safenoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _safenoLabel.textColor = [PublicClass colorWithHexString:@"#636363"];
    _safenoLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_safenoLabel];
    
    
    
}

-(void)setData:(NSDictionary *)data
{
    _data = data;
    if(data != nil)
    {
        
        
        NSString *kind = [data objectForKey:@"safetype"];
        if([@"1" hasPrefix:kind])
        {
            _psafetypeLabel.text = @"寿险";
        }
        else
        {
            _psafetypeLabel.text = @"产险";
        }
        

        _snameLabel.text = [data objectForKey:@"sname"];
        _safenoLabel.text = [data objectForKey:@"safeno"];
        
       
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int leftMarg = 20;
    int height = [@"险种:寿险" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].height;
    _kindLabel.frame = CGRectMake(leftMarg, 10, 60, height);
    
    _psafetypeLabel.frame = CGRectMake(CGRectGetMaxX(_kindLabel.frame), 10, 100, height);
    
    _personLabel.frame = CGRectMake(leftMarg, _kindLabel.bottom, 60, height);
    _snameLabel.frame = CGRectMake(CGRectGetMaxX(_personLabel.frame), _kindLabel.bottom, 100, height);
    
    _numLabel.frame = CGRectMake(leftMarg, _personLabel.bottom,60, height);
    _safenoLabel.frame = CGRectMake(CGRectGetMaxX(_numLabel.frame), _personLabel.bottom, 100, height);
}

+(CGFloat)getCellheight:(NSDictionary *)data
{
    int height = [@"险种:寿险" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].height;
    
    NSString *sname = [data objectForKey:@"sname"];
    height += [[NSString stringWithFormat:@"投保人:%@",sname] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].height;
    
    NSString *safeno = [data objectForKey:@"safeno"];
    height += [[NSString stringWithFormat:@"保单号:%@",safeno] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].height;
    
    return height + 20;
}

@end
