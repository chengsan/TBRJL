//
//  ChooseView.h
//  TBRJL
//
//  Created by 陈浩 on 16/1/20.
//  Copyright © 2016年 陈浩. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChooseBlock)(NSString *title);

@interface ChooseView : UIView

@property (nonatomic ,copy) ChooseBlock block;

//   数据容器
@property (nonatomic ,strong) NSArray *dataSoures;

-(void)presentToWindowWithDuration:(NSTimeInterval)duration;
@end
