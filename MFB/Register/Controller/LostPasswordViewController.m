//
//  LostPasswordViewController.m
//  MFB
//
//  Created by weibinbin on 15/8/27.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "LostPasswordViewController.h"

#define NUMBERS @"0123456789\n"

@interface LostPasswordViewController ()
{
    dispatch_source_t _timer;
}
@property(nonatomic,strong)NSString *strTime;
@end

@implementation LostPasswordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UIButton *sender = (UIButton *)[cell.contentView viewWithTag:11113];
    [sender setTitle: [NSString stringWithFormat:@"%@秒后重新发送",_strTime] forState:UIControlStateNormal];
    if (_strTime==0) {
        [sender setTitle: @"获取验证码" forState:UIControlStateNormal];
    }else if ([_strTime isEqualToString:@"01"])
    {
        [sender setTitle: @"重新获取验证码" forState:UIControlStateNormal];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"忘记密码";
    
    self.view.backgroundColor = colorWithHexString(@"#f1f5f8");
    
    //导航栏左侧按钮
    [self createLeftItemWithImage:@"common_back" highlightedImageName:@"" target:self action:@selector(pop)];
    
    [self creatViews];
    
    _titleArr = @[@"手机号",@"验证码",@"新密码"];
    _imgArr = @[@"Register_phone",@"Register_verify",@"Register_password"];

    //进度轮类型的修改
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//黑色底部
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//进度轮转动的类型
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_timer != nil) {
        
        dispatch_source_cancel(_timer);
    }
}

- (void)creatViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [AdaptInterface convertHeightWithHeight:10], [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height]) style:UITableViewStylePlain];
    _tableView.backgroundColor = colorWithHexString(@"#f1f5f8");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //取消滑动条
    _tableView.showsVerticalScrollIndicator = NO;
    //取消滑动
    _tableView.scrollEnabled = NO;
    
    //背景视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height])];
    _tableView.tableFooterView = bgView;
    
    //完成按钮
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeButton.frame = CGRectMake([AdaptInterface convertWidthWithWidth:0], [AdaptInterface convertHeightWithHeight:40], [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:47]);
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    _completeButton.backgroundColor = colorWithHexString(@"ff6666");
    [bgView addSubview:_completeButton];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"Cell_LOST";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        
        //图片
        _Image = [[UIImageView alloc] initWithFrame:CGRectZero];
        _Image.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:_Image];
        
        //输入框
        _NumberText = [[UITextField alloc] initWithFrame:CGRectZero];
        _NumberText.delegate = self;
        _NumberText.tag = 111112;
        _NumberText.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:_NumberText];
        
        //验证码按钮
        _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyButton.layer.cornerRadius = 3;
        _verifyButton.tag = 11113;
        _verifyButton.backgroundColor = colorWithHexString(@"ff6666");
        _verifyButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [cell.contentView addSubview:_verifyButton];
    }
    
    _Image.frame = CGRectMake([AdaptInterface convertWidthWithWidth:15], [AdaptInterface convertHeightWithHeight:15], [AdaptInterface convertWidthWithWidth:24], [AdaptInterface convertHeightWithHeight:24]);
    _Image.image = [UIImage imageNamed:_imgArr[indexPath.row]];
    
    _NumberText.placeholder = _titleArr[indexPath.row];
    
    if (indexPath.row == 0) {
        
        _NumberText.frame = CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:4], [AdaptInterface convertWidthWithWidth:300], cell.frame.size.height);
        
        _NumberText.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if (indexPath.row == 1) {
        
        _NumberText.keyboardType = UIKeyboardTypeDecimalPad;
        
        _NumberText.frame = CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:4], [AdaptInterface convertWidthWithWidth:200], cell.frame.size.height);
        
        _verifyButton.frame = CGRectMake([AdaptInterface convertWidthWithWidth:iphone6Width] - [AdaptInterface convertWidthWithWidth:130], [AdaptInterface convertHeightWithHeight:10], [AdaptInterface convertWidthWithWidth:120], [AdaptInterface convertHeightWithHeight:30]);
        [_verifyButton addTarget:self action:@selector(verifyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.row == 2)
    {
        _NumberText.frame = CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:0], [AdaptInterface convertWidthWithWidth:300], cell.frame.size.height);
        _verifyButton.hidden = YES;
        _NumberText.secureTextEntry = YES;
        _NumberText.keyboardType = UIKeyboardTypeDefault;
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
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:111112];
    
    //密码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:111112];
    
    //验证码输入框
    UITableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *verText = (UITextField *)[cell2.contentView viewWithTag:111112];
    
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
        
        if ([toBeString length] > 11) { //如果输入框内容大于20则不允许输入
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
        
        //修改手机号就可以重新发送验证码
        if (_timer != nil || [toBeString isEqualToString:@""]) {
            if (_timer == nil) {
                
            }else
            {
                dispatch_source_cancel(_timer);
                _strTime = 0;
            }
            
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UIButton *sender = (UIButton *)[cell.contentView viewWithTag:11113];
            
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
    }else if (verText == textField)
    {
        if ([toBeString length] >6) {
            textField.text = [toBeString substringToIndex:6];
            return NO;
        }
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 按钮点击事件
//验证按钮
- (void)verifyButtonAction
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UIButton *sender = (UIButton *)[cell.contentView viewWithTag:11113];
    
    //手机号输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell1.contentView viewWithTag:111112];
    [PhoneText resignFirstResponder];
    
    //验证码输入框
    UITableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *verText = (UITextField *)[cell2.contentView viewWithTag:111112];
    [verText resignFirstResponder];
    
    //新密码输入框
    UITableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITextField *NewPassword = (UITextField *)[cell3.contentView viewWithTag:111112];
    [NewPassword resignFirstResponder];
    
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
        
        NSDictionary *params = @{@"mobile":PhoneText.text,@"codeType":@"find_password"};
        
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
                                                                   NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                                                                   dispatch_async(dispatch_get_main_queue(), ^
                                                                                  {
                                                                                      //设置界面的按钮显示 根据自己需求设置
                                                                                      NSLog(@"____%@",strTime);
                                                                                      
                                                                                      [sender setTitle: [NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
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

//完成按钮事件
- (void)completeAction:(UIButton *)sender
{
    NSLog(@"设置新密码成功");
    
    //手机号输入框
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:111112];

    if ([PhoneText.text isEqualToString:@""]) {
        [AdaptInterface tipMessageTitle:@"手机号不能为空" view:self.view];
        return;
    }
    
    //验证手机号码是否正确
    BOOL isPhone = [AdaptInterface isTelephoneNumber:PhoneText.text];
    if (!isPhone) {
        [AdaptInterface tipMessageTitle:@"请输入正确的手机号" view:self.view];
        return;
    }

    //验证码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *VerText = (UITextField *)[cell1.contentView viewWithTag:111112];

    //新密码输入框
    UITableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITextField *NewPasswordText = (UITextField *)[cell3.contentView viewWithTag:111112];
    
    if ([VerText.text isEqualToString:@""]) {
        
        [AdaptInterface tipMessageTitle:@"验证码不能为空" view:self.view];
        return;
    }else if ([NewPasswordText.text isEqualToString:@""])
    {
        [AdaptInterface tipMessageTitle:@"新密码不能为空" view:self.view];
        return;
    }
    
    if (!(NewPasswordText.text.length >= 6 && NewPasswordText.text.length <= 18)) {
        
        [AdaptInterface tipMessageTitle:@"登录密码长度为6~18位" view:self.view];
        return;
    }
    
    //验证新密码
    BOOL isNew = [AdaptInterface isMatchUserNameOrPassword:NewPasswordText.text];

    if (!isNew) {
        [AdaptInterface tipMessageTitle:@"登录密码不能包含特殊符号" view:self.view];
        return;
    }else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        NSDictionary *params = @{@"mobile":PhoneText.text,@"verifyCode":VerText.text,@"newPassword":NewPasswordText.text};
        
        if ([AdaptInterface isConnected] == YES) {
            
            if (manager.requestSerializer.timeoutInterval >= 15) {
                
                [AdaptInterface tipMessageTitle:@"网络连接失败" view:self.view];
            }
            else
            {
                [manager POST:[kRequestIP stringByAppendingString:@"/mfb/usermobilemember/findpwd.html"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"%@",operation.responseString);
                    
                    NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                    
                    int code = [dic[@"code"] intValue];
                    NSString *message = dic[@"message"];
                    
                     if (code == 0)
                    {
                        [SVProgressHUD showSuccessWithStatus:message];
                        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
                        
                        [self popToLogin];
                    }else
                    {
                        [AdaptInterface tipMessageTitle:message view:self.view];
                        return;
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [AdaptInterface tipMessageTitle:@"操作失败" view:self.view];
                    return;
                }];
            }
        }else
        {
            [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
            return;
        }
    }
}

-(void)popToLogin
{
    if (_timer!=nil) {
        dispatch_source_cancel(_timer);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss{
    [SVProgressHUD dismiss];
}
@end
