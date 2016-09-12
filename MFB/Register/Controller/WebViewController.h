//
//  WebViewController.h
//  MFB
//
//  Created by xinping-2 on 15/8/14.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : BaseViewController<UIWebViewDelegate,NJKWebViewProgressDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) NSString *urlstring;
@property (nonatomic, copy) NSString *flag;//标识从哪里传过来的
@property (nonatomic,copy) void (^backRechargeBlock)();//充值返回
@end
