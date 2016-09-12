//
//  ScanCodeViewController.m
//  MFB
//
//  Created by libaozi on 15/9/18.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RegisterViewController.h"
#import "QRView.h"

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@end

@implementation ScanCodeViewController
@synthesize device,input,output,session,preview;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"扫描二维码";
    
    self.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    //导航栏左侧按钮
    [self createLeftItemWithImage:@"common_back" highlightedImageName:@"" target:self action:@selector(popToRegister)];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:30])];
    lab.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2+75);
    lab.text=@"将二维码放入框内，即可自动扫描";
    lab.font=[UIFont systemFontOfSize:13];
    lab.textColor=[UIColor greenColor];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.backgroundColor=[UIColor clearColor];
    
    [self setupScanView];
    [self.view addSubview:lab];
}
- (void)setupScanView
{
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([session canAddInput:self.input])
    {
        [session addInput:self.input];
    }
    
    if ([session canAddOutput:self.output])
    {
        [session addOutput:self.output];
    }
    
    // 支持二维码，条形码扫描，模拟器不支持扫描
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // Preview
    preview =[AVCaptureVideoPreviewLayer layerWithSession:session];
    preview.videoGravity =AVLayerVideoGravityResize;
    preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:preview atIndex:0];
    
    
    
    [session startRunning];
    
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    QRView *qrRectView = [[QRView alloc] initWithFrame:screenRect];
    qrRectView.transparentArea = CGSizeMake(200, 200);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2-64);
    
    [self.view addSubview:qrRectView];
    
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,
                                 (screenHeight - qrRectView.transparentArea.height) / 2-64,
                                 qrRectView.transparentArea.width,
                                 qrRectView.transparentArea.height);
    
    [output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                         cropRect.origin.x / screenWidth,
                                         cropRect.size.height / screenHeight,
                                         cropRect.size.width / screenWidth)];

  
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    //NSLog(@"stringValue=%@",stringValue);
    NSArray *temAry;//临时替换数组；
    NSString *temString;//临时赋值替换的string;
    if ([stringValue containsString:@"register/"]) {
        //字符串根据指定的某一个字段分割字符串为一个数组，然后取截取数组之后的电话号码
        temAry=[stringValue componentsSeparatedByString:@"register/"];
        NSString *temStr = [temAry lastObject];
        temString=[temStr substringToIndex:temStr.length];//下标从0开始，取到下标是11的数字，但不包含下标为11的数字
        
    }else{
        [self presentAlert];
    }
   
    
    if (self.qrUrlBlock!=nil) {
        self.qrUrlBlock(temString);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
//扫描二维码block方法传值
-(void)scanCode:(QRUrlBlock)qeUrl{
    self.qrUrlBlock=qeUrl;
}
#pragma mark 邀请码不正确提示框
-(void)presentAlert{
    QRCodealertView=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"邀请码不正确" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [QRCodealertView show];
}
#pragma mark 定时器自动取消邀请码警示框提示
-(void)performDismiss:(NSTimer *)timer{
    [QRCodealertView dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)popToRegister
{
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
