//
//  CHButton.h
//  TBRJL
//
//  Created by 陈浩 on 16/1/22.
//  Copyright © 2016年 陈浩. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BtnClickBlock)();

@interface CHButton : UIView

@property (nonatomic ,strong) UILabel *label;

@property (nonatomic ,copy) BtnClickBlock btnBlock;

@end
