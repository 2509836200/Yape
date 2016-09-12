//
//  ScanCodeViewController.h
//  MFB
//
//  Created by libaozi on 15/9/18.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
typedef void(^QRUrlBlock)(NSString *urlString);

@interface ScanCodeViewController : BaseViewController{
    UIAlertView *QRCodealertView;
}
@property (nonatomic, copy) QRUrlBlock qrUrlBlock;
@property (nonatomic,copy) NSString *stringValue;

-(void)scanCode:(QRUrlBlock)qeUrl;
@end
