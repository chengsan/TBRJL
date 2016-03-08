//
//  CustomCarmeraControllerViewController.m
//  TBRJL
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "CustomCarmeraController.h"
#import "TBRJL-Prefix.pch"
#import "UIViewExt.h"
#import "Util.h"

@implementation CustomCarmeraController

-(id)init
{
    self = [super init];
    if(self)
    {
       
        [self initialSession];
        
    }
    
    return self;
}

//创建相机所需要的对象
- (void) initialSession
{
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    //[self fronCamera]方法会返回一个AVCaptureDevice对象，因为我初始化时是采用前摄像头，所以这么写，具体的实现方法后面会介绍
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
}

//==========================这是获取前后摄像头对象的方法========================
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}


- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //在viewWillAppear方法里执行加载预览图层的方法
    [self setUpCameraLayer];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-40, 0, 40, 30)];
    [btn setImage:[UIImage imageNamed:@"change_camera"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toggleCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
     self.title = self.titleName;
    if(_waterTextColor == nil)
    {
        _waterTextColor = [UIColor lightGrayColor];
    }
    if(_waterTextSize <= 0)
    {
        _waterTextSize = 34;
    }
    
    if(_waterText != nil && _waterText.length > 0)
    {
        //显示水印
        UILabel *waterView = [[UILabel alloc] initWithFrame:CGRectZero];
        waterView.textAlignment = NSTextAlignmentCenter;
        waterView.text = _waterText;
        waterView.width = _waterTextSize * _waterText.length;
        waterView.height = _waterTextSize;
        waterView.left = (ScreenWidth - waterView.width)/2;
        waterView.top = (ScreenHeight - 22 - 44 - 60 - waterView.height)/2;
        waterView.textColor = _waterTextColor;
        waterView.font = [UIFont systemFontOfSize:25];
        [self.view addSubview:waterView];
    }
    
    
    //预览照片
    self.photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 22 - 44 - 60)];
    //[self.photoImgView sizeToFit];
    self.photoImgView.hidden = YES;
    self.photoImgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.photoImgView];
    
    
    //========================添加菜单按钮=====================
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 22 - 44 - 60, ScreenWidth, 60)];
    menuView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:menuView];
    
    //按钮的宽高
    int btnWidth = 40;
    
    self.againButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.againButton.frame = CGRectZero;
    self.againButton.top = (menuView.height - btnWidth)/2;
    self.againButton.left = (ScreenWidth - btnWidth *3)/4;
    self.againButton.width = btnWidth;
    self.againButton.height = btnWidth;
    self.againButton.enabled = NO;
    [self.againButton setTitle:@"重拍" forState:UIControlStateNormal];
    self.againButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.againButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.againButton setBackgroundImage:[UIImage imageNamed:@"shot.png"] forState:UIControlStateNormal];
    [self.againButton setBackgroundImage:[UIImage imageNamed:@"shot_h.png"] forState:UIControlStateHighlighted];
    [self.againButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

    [menuView addSubview:self.againButton];
    
    self.shutterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shutterButton.frame = CGRectZero;
    self.shutterButton.top = (menuView.height - btnWidth)/2;
    self.shutterButton.left = self.againButton.right + (ScreenWidth - btnWidth *3)/4;
    self.shutterButton.width = btnWidth;
    self.shutterButton.height = btnWidth;
    [self.shutterButton setTitle:@"拍照" forState:UIControlStateNormal];
    self.shutterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.shutterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shutterButton setBackgroundImage:[UIImage imageNamed:@"shot.png"] forState:UIControlStateNormal];
    [self.shutterButton setBackgroundImage:[UIImage imageNamed:@"shot_h.png"] forState:UIControlStateHighlighted];
    [self.shutterButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

    [menuView addSubview:self.shutterButton];
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okButton.frame = CGRectZero;
    self.okButton.top = (menuView.height - btnWidth)/2;
    self.okButton.left = self.shutterButton.right + (ScreenWidth - btnWidth *3)/4;
    self.okButton.width = btnWidth;
    self.okButton.height = btnWidth;
    self.okButton.enabled = NO;
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    self.okButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[UIImage imageNamed:@"shot.png"] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[UIImage imageNamed:@"shot_h.png"] forState:UIControlStateHighlighted];
    [self.okButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

    [menuView addSubview:self.okButton];
    
}

-(void)onClick:(UIButton *)btn
{
    if(btn == self.againButton)
    {
        _selectedImage = nil;
        if(nil != self.photoImgView)
        {
            [self.photoImgView setImage:nil];
            self.photoImgView.hidden = YES;
            self.againButton.enabled = NO;
            self.okButton.enabled = NO;
        }
        
        _shutterButton.enabled = YES;
    }
    else if(btn == self.shutterButton)
    {
        [self shutterCamera];
        self.okButton.enabled = YES;
        self.againButton.enabled = YES;
        self.shutterButton.enabled = NO;
    }
    else if(btn == self.okButton)
    {
        _shutterButton.enabled = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
        if(nil != self.delegate)
        {
            [self.delegate DidTakePhotoCustomCarmeraController:self Image:_selectedImage];
        }
        
        _selectedImage = nil;
        if(nil != self.photoImgView)
        {
            [self.photoImgView setImage:nil];
            self.photoImgView.hidden = YES;
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self onClick:_againButton];
}

- (void) setUpCameraLayer
{
//    if (_cameraAvaible == NO)
//    {
//        return;
//    }
    
    if (self.previewLayer == nil)
    {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 22 - 44 - 60);
        
//        self.cameraShowView = self.view;
//        UIView * view = self.cameraShowView;
//        CALayer * viewLayer = [view layer];
//        [viewLayer setMasksToBounds:YES];
//        
//        CGRect bounds = [view bounds];
//        [self.previewLayer setFrame:bounds];
//        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
//        
//        [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
        [[self.view layer] addSublayer:self.previewLayer];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    if (self.session) {
        [self.session startRunning];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

//实现切换前后镜头的按钮
- (void)toggleCamera
{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        else
            return;
        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

//拍照按钮的方法
- (void) shutterCamera
{
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
    {
        
        _shutterButton.enabled = NO;
        
        if(imageDataSampleBuffer == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"拍摄照片失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        CGSize size = CGSizeMake(_previewLayer.bounds.size.width * 2, _previewLayer.bounds.size.height * 2);
        
        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];
        
        CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) / 2, (scaledImage.size.height - size.height) / 2, size.width, size.height);
        UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
        
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation != UIDeviceOrientationPortrait) {
            
            CGFloat degree = 0;
            if (orientation == UIDeviceOrientationPortraitUpsideDown) {
                degree = 180;// M_PI;
            } else if (orientation == UIDeviceOrientationLandscapeLeft) {
                degree = -90;// -M_PI_2;
            } else if (orientation == UIDeviceOrientationLandscapeRight) {
                degree = 90;// M_PI_2;
            }
            croppedImage = [croppedImage rotatedByDegrees:degree];
        }
        
        croppedImage = [Util scaleImage:croppedImage toScale:480.0f/croppedImage.size.width];
        if(_waterText != nil && _waterText.length > 0)
        {
            //添加水印
            croppedImage = [croppedImage watermarkImage:_waterText textSize:_waterTextSize textColor:_waterTextColor];
        }
        
        if(nil != self.photoImgView)
        {
            [self.photoImgView setImage:croppedImage];
            self.photoImgView.hidden = NO;
        }
        
        _selectedImage = croppedImage;
        NSLog(@"_selectedImage大小：%@",[NSValue valueWithCGSize:croppedImage.size]);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
