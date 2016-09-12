//
//  AppDelegate.m
//  MFB
//
//  Created by llc on 15/8/3.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import "UMFeedback.h"
#import "MobClick.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialData.h"
//#import "UMessage.h"
#import "UMSocialConfig.h"
#import "UMSocial.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import "WebViewController.h"
#import "LoginViewController.h"
#import "FMDBHandle.h"
#import "Harpy.h"


#import "GuideViewController.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000

//手机APP登陆URL

@interface AppDelegate (){

    FMDBHandle *fmdbHandle;
    
    
}
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,strong)NSDate *now;
@property (nonatomic,strong)NSTimer *myTimer;
@end

@implementation AppDelegate
@synthesize guideCtrl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [NSThread sleepForTimeInterval:1];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    fmdbHandle =[FMDBHandle shareHandle];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    NSLog(@"ceshi-----------");
    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
    BOOL flag = YES;
    BOOL isForget = NO;
    BOOL isCall = NO;
    BOOL isAddMoney=NO;
    BOOL isHeardResh = NO;
    BOOL isOutMoney = NO;
    [defualt setBool:isOutMoney forKey:@"isOutMoney"];
    [defualt setBool:isHeardResh forKey:@"isHeardResh"];
    [defualt setBool:isAddMoney forKey:@"isAddMoney"];
    [defualt setBool:isForget forKey:@"isForget"];
    [defualt setBool:flag forKey:@"flag1"];
    [defualt setBool:isCall forKey:@"isMore"];
    [defualt synchronize];
    /* 判断，当前用户是否登录存在，如果不存在则跳入主页，至于登录不登录取决于用户；如果存在，则判断个当前用户指纹或者手势是否开启，然后跳入到指纹或手势验证界面进行验证，适用于双击home键杀掉程序，然后重新启动程序。*/
    
    //增加标识，用于判断是否是第一次启动应用...
    /*
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        GuideViewController *guideCtrl = [[GuideViewController alloc] init];
        self.window.rootViewController = guideCtrl;
        //[AdaptInterface tipMessageTitle:@"App需要访问您的通讯录和短信" view:guideCtrl.view];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.window.rootViewController = [[MainViewController alloc] init];

    }
     */
    
    
    NSString *key = (NSString *)kCFBundleVersionKey;
    //新版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //老版本号
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults]valueForKey:@"firstLanch"];
    guideCtrl = [[GuideViewController alloc] init];
    if ([version isEqualToString:oldVersion])
    {
        self.window.rootViewController = [[MainViewController alloc] init];
    }
    else
    {
        self.window.rootViewController = guideCtrl;
        [[NSUserDefaults standardUserDefaults]setValue:version forKey:@"firstLanch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
        
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *sessionId=[userDefaults objectForKey:@"sessionId"];
    NSString *nameAccount = [userDefaults objectForKey:@"PhoneText"];
    //在登录状态下
    if (self.window.rootViewController!=guideCtrl) {
        if (IS_NOT_EMPTY(nameAccount) && IS_NOT_EMPTY(sessionId)){
            BOOL beBreak=[defualt boolForKey:@"beBreak"];
            if (beBreak) {
                [self authenticationView];
            }
        }else{
            
        }
    }

    //集成友盟的相关功能
    [self connectUM];
    
    //友盟推送
    //[UMessage startWithAppkey:APPKEY launchOptions:launchOptions];
    
    //[Harpy checkVersion];
    
    return YES;
}

//集成友盟的相关功能
- (void)connectUM
{

///////////////////////////////////////////////////////////////

    //用户反馈
    [UMFeedback setAppkey:APPKEY];
    
    //统计分析
    //REALTIME = 0,       //实时发送              (只在测试模式下有效)
    //BATCH = 1,          //启动发送
    //SEND_INTERVAL = 6,  //最小间隔发送           ([90-86400]s, default 90s)

    [MobClick startWithAppkey:APPKEY reportPolicy:BATCH channelId:@"Web"];
    //在线参数配置
    [MobClick updateOnlineConfig];
    
    //版本标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];

    [MobClick startWithAppkey:APPKEY reportPolicy:BATCH channelId:@"Web"];
    //在线参数配置
    [MobClick updateOnlineConfig];

    


    //版本标识
    //NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //[MobClick setAppVersion:version];

    
    //友盟分享
    [UMSocialData setAppKey:APPKEY];
    //1.微信分享
    //2.朋友圈分享
    [UMSocialWechatHandler setWXAppId:@"wxde403b8167629954" appSecret:@"26ccf3af902567b824b6561f5f3c91c0" url:@"http://www.umeng.com/social"];
    
    //3.新浪微博分享
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"4251635269" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];;
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //4.QQ分享
    [UMSocialQQHandler setQQWithAppId:@"1104850152" appKey:@"KxLyE5r6RS6DxalD" url:@"http://www.umeng.com/social"];
    
    //由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];

    /*
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if (UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //注册远程通知类型
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title = @"Accept";
        //当点击的时候启动程序
        action1.activationMode = UIUserNotificationActivationModeForeground;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2_identifier";
        action2.title = @"Reject";
        //当点击的时候不启动程序，在后台处理
        action2.activationMode = UIUserNotificationActivationModeBackground;
        //需要解锁才能处理，如果
        action2.authenticationRequired = YES;
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        //这组动作的唯一标示
        category.identifier = @"category";
        [category setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObject:category]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }
    else
    {
        [UMessage registerForRemoteNotificationTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert];
    }
#else
    [UMessage registerForRemoteNotificationTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert];
#endif
    // 设置应用的日志输出的开关（默认关闭)
    [UMessage setLogEnabled:YES];
    */
    ///////////////////////////////////////////////////////////////
}

//注册远程推送
/*
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"--------%@",deviceToken);
    [UMessage registerDeviceToken:deviceToken];
}
*/

//接收到远程推送
/*
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    NSString *urlString = userInfo[@"aps"][@"alert"];
    NSLog(@"+++++++%@",urlString);
    if ([urlString hasPrefix:@"http"])
    {
 
        //UIWebView *webView = [[UIWebView alloc] init];
        //NSURL *url =[NSURL URLWithString:urlString];
        //NSURLRequest *request =[NSURLRequest requestWithURL:url];
        //webView.scalesPageToFit = YES;
        //[webView loadRequest:request];
 
        WebViewController *helpCenter = [[WebViewController alloc] init];
        helpCenter.urlstring = urlString;
        self.window.rootViewController = helpCenter;

    }
    
    
}
*/

//注册失败
/*
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to get token, error: %@",error);
}
*/

//新浪微博系统回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
}

@end
