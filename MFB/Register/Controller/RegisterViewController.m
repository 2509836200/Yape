//
//  RegisterViewController.m
//  MFB
//
//  Created by weibinbin on 15/8/14.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebViewController.h"
#import "ScanCodeViewController.h"
#import "FMDBHandle.h"
#import <AVFoundation/AVFoundation.h>
#define NUMBERS @"0123456789\n"

@interface RegisterViewController ()
{
    dispatch_source_t _timer;
    
    FMDBHandle *fmdbHandle;
    NSString * gestureWord;
    NSString * isHandString;
    NSString * isTouchString;
}
@property(nonatomic,strong)NSString *strTime;
@end

@implementation RegisterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UIButton *sender = (UIButton *)[cell.contentView viewWithTag:1113];
    [sender setTitle: [NSString stringWithFormat:@"%@秒后重新发送",_strTime] forState:UIControlStateNormal];

    if ([_strTime isEqualToString:@"01"]) {
    [sender setTitle: @"重新获取验证码" forState:UIControlStateNormal];
    }else if (_strTime == 0)
    {
        [sender setTitle: @"获取验证码" forState:UIControlStateNormal];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    //创建数据库
    fmdbHandle =[FMDBHandle shareHandle];
    
    self.view.backgroundColor = colorWithHexString(@"#f1f5f8");
    
    //导航栏左侧按钮
    [self createLeftItemWithImage:@"common_back" highlightedImageName:@"" target:self action:@selector(popToLogin)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [AdaptInterface convertHeightWithHeight:20/2], [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height]) style:UITableViewStylePlain];
    _tableView.backgroundColor = colorWithHexString(@"#f1f5f8");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //取消滑动条
    _tableView.showsVerticalScrollIndicator = NO;
    //取消滑动
    _tableView.scrollEnabled = NO;
    
    //慢富宝协议按钮
    [self _initViews];
    
    _imgArr = @[@"Register_phone",@"Register_password",@"Register_verify",@"Register_invite"];
    _titleArr = @[@"手机号",@"登录密码",@"验证码",@"邀请码"];
    
    //进度轮类型的修改
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//黑色底部
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//进度轮转动的类型
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//蒙版类型，当进度轮开启后不能进行其他操作

}

- (void)_initViews
{
    //背景视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height])];
    _tableView.tableFooterView = bgView;
    
    //协议按钮
    _protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _protocolButton.frame = CGRectMake([AdaptInterface convertWidthWithWidth:iphone6Width] - [AdaptInterface convertWidthWithWidth:190] , [AdaptInterface convertHeightWithHeight:20],[AdaptInterface convertWidthWithWidth:190],[AdaptInterface convertHeightWithHeight:30]);
    if (iPhone4 || iPhone5) {
        _protocolButton.frame = CGRectMake([AdaptInterface convertWidthWithWidth:iphone6Width] - [AdaptInterface convertWidthWithWidth:220] , [AdaptInterface convertHeightWithHeight:20],[AdaptInterface convertWidthWithWidth:220],[AdaptInterface convertHeightWithHeight:30]);
    }
    _protocolButton.tag = 1111;
    _protocolButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_protocolButton setTitle:@"同意《慢富宝注册服务协议》" forState:UIControlStateNormal];
    [_protocolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_protocolButton addTarget:self action:@selector(LinkAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_protocolButton];
    
    //同意图标
    _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeButton.frame = CGRectMake([AdaptInterface convertWidthWithWidth:iphone6Width] - CGRectGetWidth(_protocolButton.frame) - [AdaptInterface convertWidthWithWidth:38/2], [AdaptInterface convertHeightWithHeight:25], [AdaptInterface convertWidthWithWidth:38/2], [AdaptInterface convertHeightWithHeight:38/2]);
    [_agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_agreeButton setImage:[UIImage imageNamed:@"Register_select"] forState:UIControlStateNormal];
    [bgView addSubview:_agreeButton];
    
    //完成按钮
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeButton.frame = CGRectMake(0, CGRectGetMaxY(_protocolButton.frame) + [AdaptInterface convertHeightWithHeight:30], [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:47]);
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    _completeButton.backgroundColor = colorWithHexString(@"ff6666");
    [bgView addSubview:_completeButton];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat leftMargin =[AdaptInterface convertWidthWithWidth:15];
    CGFloat topMargin =[AdaptInterface convertWidthWithWidth:15];
    
    static NSString *iden = @"Cell_PHONE";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        
        //图片
        _Image = [[UIImageView alloc] initWithFrame:CGRectZero];
        _Image.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:_Image];
        
        //输入框
        _NumberText = [[UITextField alloc] initWithFrame:CGRectZero];
        _NumberText.returnKeyType = UIReturnKeyDone;
        _NumberText.delegate = self;
        _NumberText.tag = 11112;
        [cell.contentView addSubview:_NumberText];
        
        //验证码按钮
        _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyButton.layer.cornerRadius = 3;
        _verifyButton.tag = 1113;
        _verifyButton.backgroundColor = colorWithHexString(@"ff6666");
        _verifyButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [cell.contentView addSubview:_verifyButton];
        
        //二维码按钮
        _QRCodesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _QRCodesButton.tag = 1114;
        _QRCodesButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_QRCodesButton setTitle:@"扫一扫" forState:UIControlStateNormal];
        [_QRCodesButton setTitleColor:colorWithHexString(@"ff6666") forState:UIControlStateNormal];
        [cell.contentView addSubview:_QRCodesButton];
    }
    
    _Image.frame = CGRectMake(leftMargin, topMargin, [AdaptInterface convertWidthWithWidth:24], [AdaptInterface convertHeightWithHeight:24]);
    _Image.image = [UIImage imageNamed:_imgArr[indexPath.row]];
    
    _NumberText.placeholder = _titleArr[indexPath.row];
    
    if (indexPath.row == 0) {
        _NumberText.keyboardType = UIKeyboardTypeDecimalPad;
        
        _NumberText.frame = CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:4], [AdaptInterface convertWidthWithWidth:300], cell.frame.size.height);
    }
    else if (indexPath.row == 1)
    {
        _NumberText.frame = CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:4], [AdaptInterface convertWidthWithWidth:300], cell.frame.size.height);
        
        _NumberText.secureTextEntry = YES;
    }
    else if (indexPath.row == 2) {
        
        _NumberText.frame = CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:4], [AdaptInterface convertWidthWithWidth:200], cell.frame.size.height);
        
        _NumberText.keyboardType = UIKeyboardTypeDecimalPad;
        
        _verifyButton.frame = CGRectMake([AdaptInterface convertWidthWithWidth:iphone6Width] - [AdaptInterface convertWidthWithWidth:130], topMargin, [AdaptInterface convertWidthWithWidth:120], [AdaptInterface convertHeightWithHeight:30]);
        [_verifyButton addTarget:self action:@selector(verifyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (indexPath.row == 3) {
        
        _NumberText.frame = CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:0], currentViewWidth-[AdaptInterface convertWidthWithWidth:80+40], cell.frame.size.height);
         _NumberText.keyboardType = UIKeyboardTypeDecimalPad;
        _NumberText.secureTextEntry = NO;
        
        _QRCodesButton.frame = CGRectMake([AdaptInterface convertWidthWithWidth:iphone6Width] - [AdaptInterface convertWidthWithWidth:80], [AdaptInterface convertHeightWithHeight:10], [AdaptInterface convertWidthWithWidth:80], [AdaptInterface convertHeightWithHeight:30]);
        
        _verifyButton.hidden =YES;
        
        [_QRCodesButton addTarget:self action:@selector(QRLinkAction) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AdaptInterface convertHeightWithHeight:55];
}

#pragma mark - TextFileDalegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    //手机号输入框
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:11112];
    
    //密码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:11112];
    
    //验证码输入框
    UITableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITextField *VerText = (UITextField *)[cell3.contentView viewWithTag:11112];
    
    //邀请码输入框
    UITableViewCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UITextField *InviteText = (UITextField *)[cell4.contentView viewWithTag:11112];
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    NSCharacterSet *cs;
    
    if (PhoneText == textField)  //判断是否时我们想要限定的那个输入框
    {
        //过滤非数字
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            return NO;
        }
        
        if ([toBeString length] > 11) { //如果输入框内容大于11则不允许输入
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
        
        if (_timer != nil || [toBeString isEqualToString:@""]) {
            if (_timer == nil) {
                
            }else
            {
                dispatch_source_cancel(_timer);
                _strTime = 0;
            }
            
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            UIButton *sender = (UIButton *)[cell.contentView viewWithTag:1113];
            
            //设置界面的按钮显示 根据自己需求设置
            [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
            sender.backgroundColor = colorWithHexString(@"ff6666");
            
            sender.userInteractionEnabled = YES;
        }
        
    }else if (PasswordText == textField)
    {
        if ([toBeString length] >18) {
            textField.text = [toBeString substringToIndex:18];
            return NO;
        }
    }else if (VerText == textField)
    {
        if ([toBeString length] >6) {
            textField.text = [toBeString substringToIndex:6];
            return NO;
        }
        //过滤非数字
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            return NO;
        }
    }else if (InviteText == textField)
    {
        //过滤非数字
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            return NO;
        }
        
        if ([toBeString length] > 14) { //如果输入框内容大于14则不允许输入
            textField.text = [toBeString substringToIndex:14];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 按钮点击事件
//验证按钮
- (void)verifyButtonAction
{
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UIButton *sender = (UIButton *)[cell.contentView viewWithTag:1113];
    
        //手机号输入框
        UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UITextField *PhoneText = (UITextField *)[cell1.contentView viewWithTag:11112];
        [PhoneText resignFirstResponder];
    
        //密码输入框
        UITableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITextField *PasswordText = (UITextField *)[cell2.contentView viewWithTag:11112];
        [PasswordText resignFirstResponder];
    
        //验证码输入框
        UITableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UITextField *VerText = (UITextField *)[cell3.contentView viewWithTag:11112];
        [VerText resignFirstResponder];
    
        //邀请码输入框
        UITableViewCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        UITextField *InviteText = (UITextField *)[cell4.contentView viewWithTag:11112];
        InviteText.userInteractionEnabled=YES;
        [InviteText resignFirstResponder];
    
        if ([PhoneText.text isEqualToString:@""]) {
            [AdaptInterface tipMessageTitle:@"手机号不能为空" view:self.view];
            return;
        }
    
        //验证手机号码是否正确
        BOOL isPhone = [AdaptInterface isTelephoneNumber:PhoneText.text];
        if (!isPhone) {
            [AdaptInterface tipMessageTitle:@"请输入正确的手机号" view:self.view];
            return;
        }else
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
            NSDictionary *params = @{@"mobile":PhoneText.text,@"codeType":@"register"};

            [SVProgressHUD show];
            if ([AdaptInterface isConnected] == YES)
            {
                if (manager.requestSerializer.timeoutInterval >= 15)
                {
                    [AdaptInterface tipMessageTitle:@"网络连接失败" view:self.view];
                    [SVProgressHUD dismiss];
                    return;
                }else
                {
                    [manager POST:[kRequestIP stringByAppendingString:@"/mfb/message/public/sendmobileverifycode.html"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
                     {
                         NSLog(@"%@",operation.responseString);
                
                         NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                         NSError *err;
                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                         int code = [dic[@"code"] intValue];
                         NSString *message = dic[@"message"];
                         NSLog(@"%d",code);
                
                         if (code == 0)
                         {
                             [AdaptInterface tipMessageTitle:@"验证码发送成功" view:self.view];
                    
                             __block int timeout=60; //倒计时时间
                             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                             _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                             dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                             dispatch_source_set_event_handler(_timer, ^
                    {
                        if(timeout<=0){ //倒计时结束，关闭
                            dispatch_source_cancel(_timer);
                            
                            dispatch_async(dispatch_get_main_queue(), ^
                            {
                                //设置界面的按钮显示 根据自己需求设置
                                [sender setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                                sender.backgroundColor = colorWithHexString(@"ff6666");
                                
                                sender.userInteractionEnabled = YES;
                            });
                        }else{
                            
                            int seconds = timeout % 60;
                            if (seconds == 0)
                            {
                                seconds = 60;
                            }
                            self.strTime = [NSString stringWithFormat:@"%.2d", seconds];
                            dispatch_async(dispatch_get_main_queue(), ^
                            {
                                //设置界面的按钮显示 根据自己需求设置
                                NSLog(@"____%@",_strTime);
                                
                                [sender setTitle: [NSString stringWithFormat:@"%@秒后重新发送",_strTime] forState:UIControlStateNormal];
                                sender.backgroundColor = [UIColor lightGrayColor];
                                
                                sender.userInteractionEnabled = NO;
                            });
                            timeout--;
                        }
                    });
                    dispatch_resume(_timer);
                }else
                {
                    [AdaptInterface tipMessageTitle:message view:self.view];
                    [SVProgressHUD dismiss];
                    return;
                }
                    [SVProgressHUD dismiss];
                    return;
                }failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                [AdaptInterface tipMessageTitle:@"操作失败" view:self.view];
                [SVProgressHUD dismiss];
                return;
            }];
        }
        }else
        {
            [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
            [SVProgressHUD dismiss];
            return;
        }
    }
}

//同意图标点击事件
- (void)agreeButtonAction:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"Register_selected"] forState:UIControlStateSelected];
    sender.selected = !sender.selected;
}
#pragma mark 二维码扫描方法
- (void)QRLinkAction
{
    //判断有没有打开相机权限
    AVAuthorizationStatus authStatus= [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted||authStatus == AVAuthorizationStatusDenied) {
        //无权限
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"您已关闭相机使用权限，请至手机“设置->隐私->相机”中打开" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        //打开相机权限
        ScanCodeViewController *scanQRCodeVC=[[ScanCodeViewController alloc]init];
        
        [scanQRCodeVC scanCode:^(NSString *urlString) {
            //个人写法，创建出需要使用的textfield，然后赋值
            UITableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            UITextField *InviteText = (UITextField *)[cell3.contentView viewWithTag:11112];
            InviteText.text=urlString;
            InviteText.userInteractionEnabled=NO;
            InviteText.textColor=[UIColor lightGrayColor];
            
        }];
        
        [self.navigationController pushViewController:scanQRCodeVC animated:YES];
    
    }
    
}

//协议链接/邀请码链接
- (void)LinkAction:(UIButton *)sender
{
    WebViewController *webVC = [[WebViewController alloc] init];
    
    //跳转到同意协议
    if (sender.tag == 1111) {
        
        NSString *str = [kRequestIP stringByAppendingString:@"/mfb/showspecial/public/showspecialpagebypagename.html?pageName=protocol_registerProtocol"];
        webVC.urlstring = str;
        webVC.title = @"慢富宝注册服务协议";
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

//完成按钮事件
- (void)completeAction:(UIButton *)sender
{
    NSLog(@"注册");
    
    //手机号输入框
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:11112];
    
    //密码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:11112];
    
    //验证码输入框
    UITableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITextField *VerText = (UITextField *)[cell2.contentView viewWithTag:11112];
    
    //邀请码输入框
    UITableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UITextField *InviteText = (UITextField *)[cell3.contentView viewWithTag:11112];
    
   
    [PasswordText resignFirstResponder];
    [PhoneText resignFirstResponder];
    [VerText resignFirstResponder];
    [InviteText resignFirstResponder];
    
    if ([PhoneText.text isEqualToString:@""]) {

        [AdaptInterface tipMessageTitle:@"手机号不能为空" view:self.view];
        return;
    }else if ([PasswordText.text isEqualToString:@""])
    {
        [AdaptInterface tipMessageTitle:@"密码不能为空" view:self.view];
        return;
    }else if ([VerText.text isEqualToString:@""])
    {
        [AdaptInterface tipMessageTitle:@"验证码不能为空" view:self.view];
        return;
    }
    
    //验证手机号码是否正确
    BOOL isPhone = [AdaptInterface isTelephoneNumber:PhoneText.text];
    if (!isPhone) {
        [AdaptInterface tipMessageTitle:@"请输入正确的手机号" view:self.view];
        return;
    }
    if (!(PasswordText.text.length >= 6 && PasswordText.text.length <= 18)) {
        
        [AdaptInterface tipMessageTitle:@"登录密码长度为6~18位" view:self.view];
        return;
    }
    
    //验证密码格式是否正确
    BOOL isPassword = [AdaptInterface isMatchUserNameOrPassword:PasswordText.text];
    if (!isPassword) {
        [AdaptInterface tipMessageTitle:@"登录密码不能包含特殊符号" view:self.view];
        return;
    }
    
    //验证邀请码是否合法
    if (![InviteText.text isEqualToString:@""]) {
        BOOL isInvite = [self isPhoneNumber:InviteText.text];
        if (!isInvite) {
            [AdaptInterface tipMessageTitle:@"邀请码不合法" view:self.view];
            return;
        }
        if ([InviteText.text isEqualToString:PhoneText.text]) {
            [AdaptInterface tipMessageTitle:@"邀请码不可以与注册手机号相同" view:self.view];
            return;
        }
    }
    
    if (_agreeButton.selected == NO) {

        [AdaptInterface tipMessageTitle:@"请接受慢富宝注册服务协议" view:self.view];
        return;
    }else
    {
        if (isPhone == YES && isPassword == YES && (![PhoneText.text isEqualToString:PasswordText.text])) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            NSDictionary *params = @{@"mobile":PhoneText.text,@"password":PasswordText.text,@"verifyCode":VerText.text,@"inviteCode":InviteText.text,@"imei":[AdaptInterface getUUID]};
            
            if ([AdaptInterface isConnected] == YES) {
                
                [SVProgressHUD show];
                
                if (manager.requestSerializer.timeoutInterval >= 15) {
                    
                    [AdaptInterface tipMessageTitle:@"网络连接失败" view:self.view];
                }
                else
                {
                [manager POST:[kRequestIP stringByAppendingString:@"/mfb/usermobilemember/public/saveregister.html"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"%@",operation.responseString);
                    
                    NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                    
                    int code = [dic[@"code"] intValue];
                    NSString *message = dic[@"message"];
                    NSString *sessionId = dic[@"sessionId"];
                    
                    if (![sessionId isKindOfClass:[NSNull class]])
                    {
                        _sessionId = dic[@"sessionId"];
                    }
                    
                     if (code == 0)
                    {
                        //取出该账号的手势密码
                        NSMutableArray *gestureWordArrary =[NSMutableArray array];
                        NSMutableArray *isHandArray=[NSMutableArray array];
                        NSMutableArray *isTouchArray=[NSMutableArray array];
                        gestureWordArrary = [fmdbHandle selectHandlePassWordWithAccount:PhoneText.text];
                        isHandArray =[fmdbHandle selectIsHandWithAccount:PhoneText.text];
                        isTouchArray=[fmdbHandle selectIsTouchWithAccount:PhoneText.text];
                        gestureWord =[gestureWordArrary lastObject];
                        isHandString=[isHandArray lastObject];
                        isTouchString=[isTouchArray lastObject];
                        if(gestureWord==nil){
                            gestureWord=@"";
                        }
                        if(isHandString==nil){
                            isHandString=@"";
                        }
                        if(isTouchString==nil){
                            isTouchString=@"";
                        }
                        NSLog(@"取出该账号的手势密码:%@  手势状态:%@  指纹状态%@  ",gestureWord, isHandString,isTouchString);
                        //存入数据库
                        [fmdbHandle insertNumAccount:PhoneText.text HPassWord:gestureWord IsHand:isHandString IsTouch:isTouchString];

                        
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        NSString *locationString = [[NSUserDefaults standardUserDefaults] objectForKey:@"Time"];
                        
                        [userDefaults setObject:PhoneText.text forKey:@"PhoneText"];
                        NSString *newStr = [NSString stringWithFormat:@"%@%@",locationString,PhoneText.text];
                        NSString *newText = [AdaptInterface getMd5_32Bit_String:newStr];
                        
                        NSString *string = [SecurityUtil encryptAESData:PasswordText.text app_key:newText];
                        
                        [userDefaults setObject:newText forKey:@"Dynamic"];
                        NSLog(@"nnnnnnnnnnn------------%@",newText);
                        [userDefaults setObject:string forKey:@"MFB"];
                        [userDefaults setObject:_sessionId forKey:@"sessionId"];
                        [userDefaults synchronize];
                        
                        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                        
                        [self popToMainView];
                    }else {
                        [AdaptInterface tipMessageTitle:message view:self.view];
                        [SVProgressHUD dismiss];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:self.view];
                    [SVProgressHUD dismiss];
                }];
                }
            }else
            {
                [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
                 [SVProgressHUD dismiss];
            }
        }
    }
}

- (BOOL)isPhoneNumber:(NSString *)iphonenumber
{
    NSString * CT = @"^1[3|4|5|7|8][0-9]{9}$";

    NSString *phs = @"^[\\d]{7,14}$";

    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phs];
    
    if (([regextestct evaluateWithObject:iphonenumber] == YES) || ([regextestphs evaluateWithObject:iphonenumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//注册完成跳转到登录界面
-(void)popToLogin
{
    if (_timer!=nil) {
        dispatch_source_cancel(_timer);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//注册完成跳转到主界面
- (void)popToMainView
{
    if (_timer!=nil) {
        dispatch_source_cancel(_timer);
    }
    [self dismissViewControllerAnimated:YES completion:^{
         [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
    }];
}

- (void)dismiss{
    [SVProgressHUD dismiss];
}
@end
