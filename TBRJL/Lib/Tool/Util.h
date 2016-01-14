//
//  Util.h
//  TBRJL
//
//  Created by 程三 on 15/6/20.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

+(void)setObject:(NSObject *)object key:(NSString *)key;
+(NSObject *)getValue:(NSString *)key;

//数据写入文件中
+(BOOL)writeData:(NSData *)data path:(NSString *)path fileName:(NSString *)fileName;
//根据数据读取路径
+(NSData *)getDataForPath:(NSString *)fullPath;

//按比例缩放图片，参数：图片对象/缩放比例
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

//获取当前时间字典，里面包含年月日时分秒
+(NSDictionary *)getCurrentTime;

//保存图片到本地
+(BOOL)saveImgToDic:(NSString *)dicPath fileName:(NSString *)fileName UIImage:(UIImage *)image;

//压缩文件，参数：需要压缩的目录/zip包存放的路径
+ (BOOL)addFileToZip:(NSString *)pathDic zipFullPath:(NSString *)zipFullPath;

//删除指定目录
+(BOOL)delForDic:(NSString *)path;

//对象序列化成字符串
+ (NSString*)objectToJson:(NSObject *)object;

#pragma mark 计算内容的高度
+(CGSize)getSizeWithString:(NSString *)content textSize:(float)size width:(float)width;

@end
