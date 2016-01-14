//
//  Util.m
//  TBRJL
//
//  Created by 程三 on 15/6/20.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "Util.h"
#import "ZipArchive.h"


@implementation Util

/*
 NSUserDefaults可以存储的数据类型包括：NSData、NSString、NSNumber、NSDate、NSArray、NSDictionary。如果要存储其他类型，则需要转换为前面的类型，才能用NSUserDefaults存储。
 */


+(void)setObject:(NSObject *)object key:(NSString *)key
{
    if(key == nil)
    {
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:object forKey:key];
    //用synchronize方法把数据持久化到standardUserDefaults数据库
    [userDefault synchronize];
    
}

+(NSObject *)getValue:(NSString *)key
{
    NSObject *obj = nil;
    if(key != nil)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        obj = [userDefault objectForKey:key];
    }
    
    return obj;
}

+(BOOL)writeData:(NSData *)data path:(NSString *)path fileName:(NSString *)fileName
{
    BOOL b = false;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断目录是否存在
    if(![fileManager fileExistsAtPath:path])
    {
         //创建文件夹路径
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //判断文件是否存在
    NSString *fullPath = [path stringByAppendingPathComponent:fileName];
    if([fileManager fileExistsAtPath:fullPath])
    {
        //存在就先删除
        [fileManager removeItemAtPath:fullPath error:nil];
    }
    
    b = [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    
    
    return b;
}

//根据数据读取路径
+(NSData *)getDataForPath:(NSString *)fullPath
{
    NSData *data = nil;
    if(fullPath == nil || fullPath.length == 0)
    {
        return data;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    data = [fileManager contentsAtPath:fullPath];
    
    return data;
}

//按比例缩放图片，参数：图片对象/缩放比例
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//获取当前时间字典，里面包含年月日时分秒
+(NSDictionary *)getCurrentTime
{
    NSDate *now =[NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = [dateComponent year];
    int month = [dateComponent month];
    int day = [dateComponent day];
    int hour = [dateComponent hour];
    int minute = [dateComponent minute];
    int second = [dateComponent second];
    
    NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
    [dateDic setValue:[[NSNumber alloc] initWithInt:year] forKey:@"year"];
    [dateDic setValue:[[NSNumber alloc] initWithInt:month] forKey:@"month"];
    [dateDic setValue:[[NSNumber alloc] initWithInt:day] forKey:@"day"];
    [dateDic setValue:[[NSNumber alloc] initWithInt:hour] forKey:@"hour"];
    [dateDic setValue:[[NSNumber alloc] initWithInt:minute] forKey:@"minute"];
    [dateDic setValue:[[NSNumber alloc] initWithInt:second] forKey:@"second"];

    return dateDic;
}

//保存图片到本地
+(BOOL)saveImgToDic:(NSString *)dicPath fileName:(NSString *)fileName UIImage:(UIImage *)image
{
    NSLog(@"图片保存的地址%@",dicPath);
    BOOL b = false;
    if(dicPath == nil || fileName == nil || image == nil)
    {
        return b;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断目录是否存在
    if(![fileManager fileExistsAtPath:dicPath])
    {
        BOOL success = [fileManager createDirectoryAtPath:dicPath withIntermediateDirectories:YES attributes:nil error:NULL];
        if(!success)
        {
            return b;
        }
    }
    
    //判断文件是否存在
    NSString *fullPath = [dicPath stringByAppendingPathComponent:fileName];
    NSLog(@"fullPath ==   %@",fullPath);
    if([fileManager fileExistsAtPath:fullPath])
    {
        BOOL success = [fileManager removeItemAtPath:fullPath error:nil];
        if(!success)
        {
            return b;
        }
    }
    else
    {
        BOOL success = [fileManager createFileAtPath:fullPath contents:nil attributes:nil];
        
        if(!success)
        {
            return b;
        }
    }
    
    //将图片写入本地
    //由此产生的JPEG图像的质量,表示为一个值从0.0降至1.0。0.0的值代表了最大压缩(或最低质量),而值1.0代表了至少压缩(或质量)。
    NSData *data = UIImageJPEGRepresentation(image, 1);
    b = [data writeToFile:fullPath atomically:YES];
    
    return b;
}

//压缩文件，参数：需要压缩的目录/zip包存放的路径
+ (BOOL)addFileToZip:(NSString *)pathDic zipFullPath:(NSString *)zipFullPath
{
    BOOL success = false;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@" 目录地址  %@",pathDic);
    //判断压缩目录是否存在
    if(![fileManager fileExistsAtPath:pathDic])
    {
        NSLog(@"目录不存在");
        return success;
    }
    //判断ZIP文件是否存在，存在就删除
    if([fileManager fileExistsAtPath:zipFullPath])
    {
        NSLog(@"目录存在，删除目录");
        [fileManager removeItemAtPath:zipFullPath error:nil];
    }
    
    //创建一个ZipArchive实例，并创建一个内存中的zip文件。需要注意的是，只有当你调用了CloseZipFile2方法之后，zip文件才会从内存中写入到磁盘中去。
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFullPath];
    
    //循环压缩目录
    NSArray *dicArray = [fileManager contentsOfDirectoryAtPath:pathDic error:nil];
    if(dicArray == nil || dicArray.count <= 0)
    {
        return success;
    }
    
    for (NSString *filename in dicArray)
    {
        NSString *fullpath = [pathDic stringByAppendingPathComponent:filename];
        if([fileManager fileExistsAtPath:fullpath])
        {
            //把要压缩的文件加入到zip对象中去，加入的文件数量没有限制，也可以加入文件夹到zip对象中去。
            BOOL b = [za addFileToZip:fullpath newname:filename];
            if(!b)
            {
                return success;
            }
        }
    }
    //把zip从内存中写入到磁盘中去。
    success = [za CloseZipFile2];
    NSLog(@"zip从内存中写入到磁盘中结果: %d",success);
    
    return success;
}

//删除指定目录
+(BOOL)delForDic:(NSString *)path
{
    if(path == nil || [@"" isEqualToString:path])
    {
        return false;
    }
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    //判断目录是否存在
    if(![fileManger fileExistsAtPath:path])
    {
        return false;
    }
    
    //删除目录
    BOOL b = [fileManger removeItemAtPath:path error:nil];
    
    
    return b;
}

//对象序列化成字符串
+ (NSString*)objectToJson:(NSObject *)object
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(CGSize)getSizeWithString:(NSString *)content textSize:(float)size width:(float)width
{
    CGSize cgsize = CGSizeMake(0,0);
    if(content == nil || [@"" isEqualToString:content] || size <= 0)
    {
        return cgsize;
    }
    
//    [content boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]

    cgsize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    
    //cgsize = [content sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(width, 0)];
    //cgsize=[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}];
    return cgsize;
}
@end
