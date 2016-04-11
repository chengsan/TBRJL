//
//  ScanViewController.m
//  TBRJL
//
//  Created by Charls on 15/12/15.
//  Copyright (c) 2015年 陈浩. All rights reserved.
//

#import "ScanViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <ZXingObjC/ZXingObjC.h>
#import "SMS4.h"
#import "TBPUtil.h"
#import "TBRJL-swift.h"
@interface ScanViewController ()<ZXCaptureDelegate>
@property (weak, nonatomic) IBOutlet UILabel *decodedLabel;
@property (weak, nonatomic) IBOutlet UIView *scanRectView;
@property (nonatomic ,strong) ZXCapture *capture;
@property (nonatomic ,weak) UIImageView *scanLine;  // 扫描线
@property (nonatomic ,strong) CADisplayLink *link; // 定时器
@end

@implementation ScanViewController
-(CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    return _link;
}

- (void)dealloc {

    [self.capture.layer removeFromSuperlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    self.capture.delegate = self;
    self.capture.layer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 40);
    [self.view.layer addSublayer:self.capture.layer];
    self.scanRectView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.scanRectView.layer.borderWidth = 2;
    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
    
    UIImageView *scanLine = [[UIImageView alloc] init];
    scanLine.image = [UIImage imageNamed:@"qrcode_scanline_qrcode"];
    CGRect scanLineFrm = self.scanRectView.bounds;
    scanLineFrm.origin.y = -self.scanRectView.bounds.size.height;
    scanLine.frame = scanLineFrm;
    [self.scanRectView addSubview:scanLine];
    self.scanRectView.clipsToBounds = YES;
    self.scanLine = scanLine;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

-(void)update{
    //更改扫描线的y
    CGRect scanLineFrm = self.scanLine.frame;
    scanLineFrm.origin.y += 5;
    
    // 边框高度
    CGFloat borderViewH = CGRectGetHeight(self.scanRectView.frame);
    if (scanLineFrm.origin.y >= borderViewH) {
        scanLineFrm.origin.y = -borderViewH;
    }
    
    self.scanLine.frame = scanLineFrm;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    开启定时器
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    self.capture.delegate = self;
//    self.capture.layer.frame = self.view.bounds;
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame, captureSizeTransform);

    
}




-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    关闭定时器
    [self.link invalidate];
    [self.capture stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
   [self.capture stop]; 


    TBPJIEMI* jiem = [TBPJIEMI new];
    NSString* str= [jiem JIEMI:result.text];
    NSLog(@" 解码 %@",str);
    if (self.resultBlock != nil ) {
        self.resultBlock(str);
    }
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);


    [self dismissViewControllerAnimated:NO completion:NULL];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

//    });

    return;
}



-(void)cancelBtnClick{
    [self dismissViewControllerAnimated:NO completion:NULL];
    
}


@end
