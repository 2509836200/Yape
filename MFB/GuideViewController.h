//
//  GuideViewController.h
//  MFB
//
//  Created by yinxuehua on 15/9/16.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,copy) void (^endGuide)();


@end
