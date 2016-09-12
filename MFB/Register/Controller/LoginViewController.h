//
//  LoginViewController.h
//  MFB
//
//  Created by xinping-2 on 15/8/14.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate<NSObject>

- (void)LoginSuccess;

- (void)AutoLoginSuccess;
@end

@interface LoginViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSInteger isError;
}
@property(nonatomic,retain) UITableView *tableView;

@property(nonatomic,strong) UIImageView *Image;               //图片

@property(nonatomic,strong) UIButton *verifyNumber;                //验证随机数字
@property(nonatomic, strong) UIWebView *webView;                  //跳转的链接webview

@property(nonatomic,strong) UIButton *completeButton;           //完成按钮

@property(nonatomic,strong) UIButton *registerButton;              //立即注册
@property(nonatomic,strong) UIButton *forgetButton;           //忘记密码

@property (nonatomic,retain) NSArray *imgArr;                   //图片
@property (nonatomic,retain) NSArray *titleArr;                    //水印文字

@property (nonatomic,assign) id<LoginDelegate> delegate;

@property (nonatomic, copy) NSString *sessionId;

-(void)AutomaticLogin;//弹出手势自动登录
-(void)Automatic;//自动登录

@end
