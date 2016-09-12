//
//  LostPasswordViewController.h
//  MFB
//
//  Created by xinping-2 on 15/8/27.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostPasswordViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain) UITableView *tableView;

@property(nonatomic,strong) UITextField *NumberText;      //手机号/验证码/身份证/新密码输入框

@property(nonatomic,strong) UIButton *verifyButton;                       //验证按钮
@property(nonatomic,strong) UILabel *verifyLabel;                           //验证按钮倒计时label

@property(nonatomic,strong) UIButton *completeButton;           //完成按钮

@property (nonatomic,retain) NSArray *titleArr;                    //手机号/验证码/身份证/新密码

@property (nonatomic,retain) NSArray *textArr;           //请输入。。

@property (nonatomic,retain) NSArray *imgArr;                   //图片数组

@property(nonatomic,strong) UIImageView *Image;               //图片
@end
