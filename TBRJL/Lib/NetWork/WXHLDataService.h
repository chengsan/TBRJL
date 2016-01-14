//
//  WXHLDataService.h
//  WXWeibo
//
//  Created by 程三 on 15/5/6.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestFinishBlock)(id result);

@interface WXHLDataService : NSObject

+(ASIHTTPRequest *)requestWithURL:(NSString *)url
                           params:(NSMutableDictionary *)params
                           httpMethod:(NSString *)httpMethod
                           completeBlock:(RequestFinishBlock)block;
@end
