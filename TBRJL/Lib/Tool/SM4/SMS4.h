//
//  SMS4.h
//  SMS4
//
//  Created by 张旭 on 15/3/2.
//  Copyright (c) 2015年 3lang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMS4 : NSObject

//加密
- (NSString*) EncodeSMS4: (NSString*)src withKey: (NSString*)key;

//解密
- (NSString*) DecodeSMS4: (NSString*)src withKey: (NSString*)key;
@end
//        NSString* jiemi2 = [sms4 DecodeSMS4:jiami2 withKey:@"ad37d033dac44f6b919ff66a3477613a"];
