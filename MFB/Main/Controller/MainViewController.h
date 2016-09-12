//
//  MainViewController.h
//  MFB
//
//  Created by llc on 15/8/3.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

#import "AppDelegate.h"

#import "Dock.h"

@interface MainViewController : BaseViewController<UINavigationControllerDelegate,UIAlertViewDelegate,LoginDelegate>

@property (nonatomic,strong)Dock *dockView;

-(void) selectedControllerAtIndex:(int)index;
@end
