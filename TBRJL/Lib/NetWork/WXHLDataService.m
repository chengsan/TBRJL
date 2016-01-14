//
//  WXHLDataService.m
//  WXWeibo
//
//  Created by 程三 on 15/5/6.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "WXHLDataService.h"
#import "JSONKit.h"
#import "Util.h"
@implementation WXHLDataService

+(ASIHTTPRequest *)requestWithURL:(NSString *)url
                           params:(NSMutableDictionary *)params
                       httpMethod:(NSString *)httpMethod
                    completeBlock:(RequestFinishBlock)block
{
    //GET和POST的区别
    //GET：设置的请求参数是加在请求路径的后面的
    //POSt：设置的请求的参数是设置在请求体中的
    
    url = [url stringByAppendingString:@"?"];
    
    //处理GET
    NSComparisonResult compareRet1 = [httpMethod caseInsensitiveCompare:@"GET"];
    if(compareRet1 == NSOrderedSame)
    {
        NSMutableString *paramString = [NSMutableString string];
        //获取所有Key
        NSArray *allKeys = [params allKeys];
        for (int i = 0;i < allKeys.count; i++)
        {
            //获取Key
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            [paramString appendFormat:@"%@=%@",key,value];
            
            //最后一个参数不加&
            if(i < params.count - 1)
            {
                [paramString appendFormat:@"&"];
            }
        }
        
        if(paramString.length > 0)
        {
            //如果是GET请求就添加其他请求参数
            url = [url stringByAppendingFormat:@"%@",paramString];
        }
        
    }
    
    
    
    NSURL *urlString = [NSURL URLWithString:url];
    //设置请求的路径
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlString];
    //设置请求超时时间
    [request setTimeOutSeconds:60];
    //设置请求方式：GET或POST
    [request setRequestMethod:httpMethod];
    
    //处理POST的参数
    NSComparisonResult compareRet2 = [httpMethod caseInsensitiveCompare:@"POST"];
    if(NSOrderedSame == compareRet2)
    {
        //获取所有Key
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i < allKeys.count; i++)
        {
            //获取Key
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            //判断是否文件上传
            if([value isKindOfClass:[NSData class]])
            {
                [request addData:value forKey:key];
                //或者为路径
                //request addFile:<#(NSString *)#> forKey:<#(NSString *)#>
            }
            else
            {
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    
    //请求完成后回调block
    [request setCompletionBlock:^{
        //获取请求回来的值
        NSData *data = request.responseData;
        
        //判断版本
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        id result = nil;
        if(version >= 5.0)
        {
            result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        else
        {
            //用JSONKit解析
            result = [data objectFromJSONData];
        }
        
        if(result == nil)
        {
            result = request.responseString;
        }
        else
        {
            //result = [Util replaceUnicode:result];
        }
        
        //回调外部的block方法
        if(block != nil)
        {
            block(result);
        }
    }];
    
    //请求出错
    [request setFailedBlock:^{
        
        NSError *error = [request error];
        //回调外部的block方法
        if(block != nil)
        {
            block([error localizedDescription]);
        }

    }];
    
    [request startAsynchronous];
    return request;
}


@end
