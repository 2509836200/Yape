//
//  MainViewController.m
//  MFB
//
//  Created by llc on 15/8/3.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#define  KBarBtnColor kGetColor(77, 167, 238)
#define KDockHeight 48

#import "MainViewController.h"
#import "DockItem.h"
#import "YapeController.h"
#import "FriendController.h"
#import "MyController.h"
#import "Harpy.h"
#import "GroupChatController.h"
@interface MainViewController ()
{
    UIImageView *_tabBarView;
    UIViewController *_selectedViewController;
    
    
    int Selected;
    
    int lastSelected;
    
    Reachability *hostReach;
}
@end

@implementation MainViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@"" forKey:@"isHomeCall"];//清空首页电话标识
    [userDefaults setObject:@"" forKey:@"isProduct"];
    [userDefaults setObject:@"" forKey:@"isMore"]; //清空更多电话标识
    [userDefaults setObject:@"" forKey:@"isMyAssetsCall"];
    [userDefaults synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Selected = 0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    //self.tabBar.hidden= YES;  //隐藏原来的tabbar
    CGFloat _tabBarViewY =self.view.frame.size.height - KDockHeight;
    _dockView = [[Dock alloc] initWithFrame:CGRectMake(0, _tabBarViewY, [AdaptInterface convertWidthWithWidth:iphone6Width], KDockHeight)];
    _dockView.contentMode = UIViewContentModeBottom;
    
    _dockView.backgroundColor =colorWithRGB(250, 250, 250);
    _dockView.userInteractionEnabled = YES;
    [self.view addSubview:_dockView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], 0.5)];
    lineView.backgroundColor = colorWithHexString(@"e1e1e1");
    [_dockView addSubview:lineView];
    
    
    __weak MainViewController *main = self;
    __weak Dock *dock = _dockView;
    __block int select = Selected;
    __block int lastselect = lastSelected;
    //按钮点击进入相应的控制器
    _dockView.dockItemClick = ^(int tag){
        
//        if (select != tag) {
//            lastselect = select;
//        }
//        
//        select = tag;
// 
//        NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
//        NSString *phone = [defualt objectForKey:@"PhoneText"];
//        NSString *sessionId = [defualt objectForKey:@"sessionId"];
//        
//        if (!IS_NOT_EMPTY(phone) && !IS_NOT_EMPTY(sessionId) && tag == 2)
//        {
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            loginVC.delegate = main;
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//            
//            [main presentViewController:nav animated:YES completion:^{
//                    
//            [dock setSelectedIndex:lastselect];
//            }];
//        }
//        else
//        {
            [main selectedControllerAtIndex:tag];
//        }
    };
    
    // 3.创建控制器
    [self createChildViewController];

    // 监听状态栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarChange) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(reachabilityChanged:)
     
                                                 name: kReachabilityChangedNotification
     
                                               object: nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop

    
}

//监测 navigationBar 高度
-(void)statusBarChange
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    BOOL isMore =[userDefaults boolForKey:@"isMore"];
    BOOL isHomeCall = [userDefaults boolForKey:@"isHomeCall"];
    BOOL isMyAssetsCall = [userDefaults boolForKey:@"isMyAssetsCall"];
    BOOL isProduct = [userDefaults boolForKey:@"isProduct"];
    if(isMore){
        UIViewController *newViewController = self.childViewControllers[3];
        
        [_selectedViewController.view removeFromSuperview];
        
        newViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - KDockHeight);
        
        [self.view addSubview:newViewController.view];
        _selectedViewController = newViewController;
        
    }
    else if (isHomeCall)
    {
        UIViewController *newViewController = self.childViewControllers[0];
        
        [_selectedViewController.view removeFromSuperview];
        
        newViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - KDockHeight);
        
        [self.view addSubview:newViewController.view];
        _selectedViewController = newViewController;
        
    }
    else if (isMyAssetsCall)
    {
        UIViewController *newViewController = self.childViewControllers[2];
        
        [_selectedViewController.view removeFromSuperview];
        
        newViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - KDockHeight);
        
        [self.view addSubview:newViewController.view];
        _selectedViewController = newViewController;
        
    }
    else if (isProduct)
    {
        UIViewController *newViewController = self.childViewControllers[1];
        
        [_selectedViewController.view removeFromSuperview];
        
        newViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - KDockHeight);
        
        [self.view addSubview:newViewController.view];
        _selectedViewController = newViewController;
        
    }
    else {
        
        UIViewController *newViewController = self.childViewControllers[Selected];
        
        [_selectedViewController.view removeFromSuperview];
        
        newViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - KDockHeight);
        
        [self.view addSubview:newViewController.view];
        _selectedViewController = newViewController;
        
    }
    
    
}

-(void) selectedControllerAtIndex:(int)index
{
    UIViewController *newViewController = self.childViewControllers[index];
    if (newViewController == _selectedViewController) {
        return;
    }
    
    
    [_selectedViewController.view removeFromSuperview];
    
    newViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - KDockHeight);
    
    [self.view addSubview:newViewController.view];
    
    _selectedViewController = newViewController;
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:@"isHomeCall"];//清空首页电话标识
    [userDefaults setObject:@"" forKey:@"isProduct"];
    [userDefaults setObject:@"" forKey:@"isMore"]; //清空更多电话标识
    [userDefaults setObject:@"" forKey:@"isMyAssetsCall"];
    if (index ==0) {
        [userDefaults setBool:YES forKey:@"isHomeCall"];
    }
    else if (index ==1) {
        [userDefaults setBool:YES forKey:@"isProduct"];
    }
    else if (index ==2) {
        [userDefaults setBool:YES forKey:@"isMyAssetsCall"];
    }
    [userDefaults synchronize];
    
}

-(void) createChildViewController
{
    YapeController *recommendVC =[[YapeController alloc] init];
    UINavigationController *nav1 =[[UINavigationController alloc] initWithRootViewController:recommendVC];
    nav1.delegate = self;
    [self addChildViewController:nav1];
    
    FriendController *financialVC =[[FriendController alloc] init];
    UINavigationController *nav2 =[[UINavigationController alloc] initWithRootViewController:financialVC];
    nav2.delegate = self;
    [self addChildViewController:nav2];
    
    MyController *myAssetsVC =[[MyController alloc] init];
    UINavigationController *nav3 =[[UINavigationController alloc] initWithRootViewController:myAssetsVC];
    nav3.delegate = self;
    [self addChildViewController:nav3];
   
    GroupChatController *groupVC =[[GroupChatController alloc] init];
    UINavigationController *nav4 =[[UINavigationController alloc] initWithRootViewController:groupVC];
    nav3.delegate = self;
    [self addChildViewController:nav4];
    // 4.初始化执行第一个控制器
    [self selectedControllerAtIndex:0];
    [_dockView setSelectedIndex:0];
    
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    UIViewController *root =navigationController.viewControllers[0];
    if (viewController != root) {
        navigationController.view.frame = self.view.bounds ;
        //移除dock
        [_dockView removeFromSuperview];
        
        //需要改变dock的Y值
        CGRect frame = _dockView.frame;
        
        if ([root isKindOfClass:[FriendController class]] || [root isKindOfClass:[MyController class]]  || [root isKindOfClass:[YapeController class]]) {
            if (IS_HOTSPOT_CONNECTED) {  // 如果有热点
                frame.origin.y -= KDockHeight -12;
                if (frame.origin.y != currentViewHeight-(64+48+20)) {
                    frame.origin.y =currentViewHeight-(64+48+20);
                }
            }
            else{
                frame.origin.y -= KDockHeight -12;
                if (frame.origin.y != currentViewHeight-(64+48)) {
                    frame.origin.y =currentViewHeight-(64+48);
                }
            }
            
        }
        

        
        _dockView.frame = frame;
        //NSLog(@"bbbb:%@",NSStringFromCGRect(frame));
        //NSLog(@"root.view:%@",NSStringFromCGRect(root.view.frame));
        
        //将dock添加到根控制器上
        [root.view addSubview:_dockView];
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *root =navigationController.viewControllers[0];
    if (viewController == root) {
        //更改导航控制器的frame
        navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -KDockHeight);
        
        //移除根控制器上的dock
        [_dockView removeFromSuperview];
        
        //NSLog(@"cccc:%f",self.view.frame.size.height- KDockHeight);
        //改变dock的Y值
        _dockView.frame = CGRectMake(0, self.view.frame.size.height - KDockHeight, self.view.frame.size.width, KDockHeight);
        
        //导航控制器上添加dock
        [self.view addSubview:_dockView];
        
    }
    
}

//监听到网络状态改变
- (void) reachabilityChanged: (NSNotification* )note
{
    
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
    
}


//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    //对连接改变做出响应的处理动作。
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    AppDelegate *myDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi) {
        if(myDelegate.appLaunchCheckVersion == NO){
            
            //[self checkVersion]; //暂时注释
        }
    }
    
}


//************************************检查更新************************
@end
