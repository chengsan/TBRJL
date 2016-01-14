//
//  SetServiceURLViewController.h
//  TBRJL
//
//  Created by 程三 on 15/5/30.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sureBtnClickBlock)();
@interface SetServiceURLViewController : UIViewController

@property (nonatomic ,copy)sureBtnClickBlock clickBlock;
@end
