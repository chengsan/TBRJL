//
//  CustomCarmeraControllerViewController.h
//  TBRJL
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaseViewController.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Resize.h"

@class CustomCarmeraController;

@protocol CustomCarmeraDelagate <NSObject>

//必须实现该接口
@optional
-(void)DidTakePhotoCustomCarmeraController:(CustomCarmeraController *)customCarmeraController Image:(UIImage *)image;

@end

@interface CustomCarmeraController : BaseViewController


@property (nonatomic,copy)          NSString *waterText;//水印内容
@property (nonatomic,assign)        int      waterTextSize;//水印字体大小
@property (nonatomic,retain)        UIColor  *waterTextColor;//水印内容颜色

@property (nonatomic, strong)       AVCaptureSession            * session;//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong)       AVCaptureDeviceInput        * videoInput;//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong)       AVCaptureStillImageOutput   * stillImageOutput;//照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了
@property (nonatomic, strong)       AVCaptureVideoPreviewLayer  * previewLayer;//预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong)       UIBarButtonItem             * toggleButton;//切换前后镜头的按钮
@property (nonatomic, strong)       UIButton                    * okButton;//确定按钮
@property (nonatomic, strong)       UIButton                    * shutterButton;//拍照按钮
@property (nonatomic, strong)       UIButton                    * againButton;//重拍按钮
@property (nonatomic, strong)       UIImageView                 *photoImgView; //预览照片
@property (nonatomic, strong)       UIImage                     *selectedImage;//图片对象
@property (nonatomic, strong)       id<CustomCarmeraDelagate>   delegate;//协议
@property (nonatomic ,copy) NSString *titleName;

@end
