//
//  BaoDanModel.m
//  TBRJL
//
//  Created by Charls on 15/12/10.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaoDanModel.h"

@implementation BaoDanModel



-(CGFloat)cellHeight{
 
    NSLog(@"%s",__func__);
    if (!_cellHeight) {
    
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 85, MAXFLOAT);
        
        CGFloat textH = [self.result boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        _cellHeight = textH;
        
    }
    return _cellHeight;
}





@end
