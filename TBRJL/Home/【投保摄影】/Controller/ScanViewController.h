//
//  ScanViewController.h
//  TBRJL
//
//  Created by Charls on 15/12/15.
//  Copyright (c) 2015年 陈浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^jieMiResultBlock)(NSString *result);
@interface ScanViewController : BaseViewController
@property (nonatomic ,copy)jieMiResultBlock resultBlock;
@end
