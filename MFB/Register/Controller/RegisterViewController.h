//
//  RegisterViewController.h
//  MFB
//
//  Created by xinping-2 on 15/8/14.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL isRegister;
    
}
@property(nonatomic,retain) UITableView *tableView;

@property(nonatomic,strong) UIImageView *Image;               //手机号图片
@property(nonatomic,strong) UITextField *NumberText;      //手机号输入框

@property(nonatomic,strong) UIButton *verifyButton;                       //验证按钮
@property(nonatomic,strong) UILabel *verifyLabel;                           //验证按钮倒计时label

@property(nonatomic,strong) UIButton *agreeButton;              //是否同意
@property(nonatomic,strong) UIButton *protocolButton;           //链接按钮(协议)
@property(nonatomic,strong) UIButton *QRCodesButton;       //链接二维码

@property(nonatomic,strong) UIButton *completeButton;           //完成按钮

@property (nonatomic,retain) NSArray *imgArr;                   //图片
@property (nonatomic,retain) NSArray *titleArr;                    //水印文字

@property (nonatomic, copy) NSString *sessionId;

@end
