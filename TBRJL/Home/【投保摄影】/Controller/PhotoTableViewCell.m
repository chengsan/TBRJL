//
//  PhotoTableViewCell.m
//  TBRJL
//
//  Created by 程三 on 15/7/12.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "PhotoTableViewCell.h"
#import "UIViewExt.h"
#import "TBRJL-Prefix.pch"

@implementation PhotoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self _initView];
    }
    
    return self;
}

-(void)_initView
{
    //固定高度60
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tbsy_1.png"]];
    iconImageView.frame = CGRectZero;
    iconImageView.left = 5;
    iconImageView.top = (60 - 40)/2;
    iconImageView.height = 40;
    iconImageView.width = 40;
    [self addSubview:iconImageView];
    
    //标题
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.left = iconImageView.right + 10;
    titleLabel.top = 0;
    titleLabel.width = ScreenWidth - iconImageView.right - 70 - 10;
    titleLabel.height = 60;
    titleLabel.text = @"标题";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    
    //红色必拍标记值
    markLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    markLabel.left = titleLabel.right;
    markLabel.top = 0;
    markLabel.width = 40;
    markLabel.height = 60;
    markLabel.text = @"*";
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.font = [UIFont systemFontOfSize:30];
    markLabel.textColor = [UIColor redColor];
    markLabel.hidden = YES;
    self.markLabel = markLabel;
    [self addSubview:markLabel];
    
    //是否已拍标记
    photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tbsy_bj.png"]];
    photoImageView.width = 30;
    photoImageView.height = 30;
    photoImageView.left = ScreenWidth - photoImageView.width;
    photoImageView.top = (60 - photoImageView.height)/2;
    photoImageView.hidden = YES;
    [self addSubview:photoImageView];
}

-(void)setData:(EntityBean *)data
{
    if(nil != [data objectForKey:@"photoname"])
    {
        titleLabel.text = (NSString *)[data objectForKey:@"photoname"];
    }
    else if(nil != [data objectForKey:@"title"])
    {
        titleLabel.text = (NSString *)[data objectForKey:@"title"];
    }
    else
    {
        titleLabel.text = (NSString *)[data objectForKey:@"phototype"];
    }
    
    
    //类型：0 新建／1:缓存／2:补拍／3:补录  补录和不怕进来的图片都是必拍的
    if(currentType == 2 || currentType == 3)
    {
        if(nil != markLabel)
        {
            markLabel.hidden = NO;
        }
    }
    else
    {
        //nullable是否必填  1是0否
        NSString *nullable = (NSString *)[data objectForKey:@"nullable"];
        if([@"1" isEqualToString:nullable])
        {
            if(nil != markLabel)
            {
                markLabel.hidden = NO;
            }
        }
        else
        {
            if(nil != markLabel)
            {
                markLabel.hidden = YES;
            }
        }

    }
    
    NSString *filename = (NSString *)[data objectForKey:@"filename"];
    NSLog(@"filename的名字%@",filename);
    if(nil != filename && filename.length > 0)
    {
        NSString *path = (NSString *)[data objectForKey:@"path"];
        
        NSLog(@"获取路径path = %@",path);
        if(path != nil && path.length > 0)
        {
            NSString *fullPath = [path stringByAppendingPathComponent:filename];
            NSLog(@" 文件夹的路径  %@",fullPath);
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
            {
                if(nil != photoImageView)
                {
                    photoImageView.hidden = NO;
                    return;
                }
            }
        }
    }
    
    if(nil != photoImageView)
    {
        photoImageView.hidden = YES;
    }
}


#pragma mark 设置当前类型
-(void)setCurrentType:(int)type
{
    currentType = type;
}
@end
