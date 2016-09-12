//
//  AppDelegate.h
//  MFB
//
//  Created by llc on 15/8/3.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GuideViewController.h"
#define APPKEY @"55cc68c9e0f55a23a5002521"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    NSTimer *_timer;
    int count;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) CFAbsoluteTime resignTime;  //记录进入后台的时间
@property (nonatomic, assign) CFAbsoluteTime currentTime;  //记录进入后台的时间


@property (nonatomic, assign) BOOL appLaunchCheckVersion;  //启动app后是否检查更新


@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic,strong) GuideViewController *guideCtrl;

-(void)authenticationView;
@end

