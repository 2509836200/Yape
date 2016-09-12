//
//  LoginViewController.m
//  MFB
//
//  Created by weibinbin on 15/8/14.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LostPasswordViewController.h"
#import "Dock.h"
#import "FMDBHandle.h"

#define NUMBERS @"0123456789\n"

#import "AppDelegate.h"

@interface LoginViewController ()
{
    UIImageView *imageView;
    FMDBHandle *fmdbHandle;
    NSString *gestureWord;// 从数据库取出的手势密码
    NSString *isHandString;// 从数据库取出手势状态;
     NSString *isTouchString;// 从数据库取出指纹状态;
    BOOL isForget;//点击忘记密码标识
}
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
    //手机号输入框
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:11112];
    
    //密码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:11112];
    
    PhoneText.text = nil;
    PasswordText.text = nil;
    
    //隐藏尾视图
    UIView *bgView = [self.view  viewWithTag:10000001];
    bgView.hidden = YES;
    _tableView.tableFooterView.frame=CGRectMake(0,  [AdaptInterface convertHeightWithHeight:110], [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fmdbHandle=[FMDBHandle shareHandle];
    
    //进度轮类型的修改
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//蒙版类型，当进度轮开启后不能进行其他操作
    
    self.title = @"登录";
    
    isError = 0;
    
    self.view.backgroundColor = colorWithHexString(@"#f1f5f8");
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [AdaptInterface convertHeightWithHeight:10], [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height]) style:UITableViewStylePlain];
    _tableView.backgroundColor = colorWithHexString(@"#f1f5f8");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _imgArr = @[@"Register_phone",@"Register_password"];
    _titleArr = @[@"手机号/电话号",@"登录密码"];
    
    //取消滑动条
    _tableView.showsVerticalScrollIndicator = NO;
    //取消滑动
    _tableView.scrollEnabled = NO;
    
    [self _initViews];
    
    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
    BOOL flag= [defualt boolForKey:@"flag1"];
    
    if(!flag){
        
        BOOL flag = YES;
        [defualt setBool:flag forKey:@"flag1"];
        [defualt synchronize];
        
    }else {
        //返回按钮
        [self _initBackButton];
    }
}

- (void)_initBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectZero;
    [button addTarget:self action:@selector(popViews) forControlEvents:UIControlEventTouchUpInside];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:(44-48)/2], [AdaptInterface convertHeightWithHeight:(44-30)/2], [AdaptInterface convertWidthWithWidth:20], [AdaptInterface convertHeightWithHeight:20])];
    if (iPhone4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:(44-38)/2], [AdaptInterface convertHeightWithHeight:(44-20)/2], [AdaptInterface convertWidthWithWidth:20], [AdaptInterface convertHeightWithHeight:20])];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"common_back"];
    [button addSubview:imageView];
    
    button.frame = CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:44], [AdaptInterface convertHeightWithHeight:44]);
    [button sizeToFit];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}
- (void)popViews
{
    
    [self notificationCenter];
    
    /**
     * 判断是否登录,如果登录，就走验证的方法，此时dismiss掉登录页面和指纹验证页面；如果没登陆，就走登录方法，登录后直接进入主页面
     *  这里用了AppDelegate  然后当验证界面dismiss掉之后，因为他们的指针还存在，所以把指针也置为空！
     */
    /*
    //手机号输入框

   
    [self dismissViewControllerAnimated:YES completion:^{


    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:11111];
   
    [PhoneText resignFirstResponder];
    
    //密码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:11111];
   
    [PasswordText resignFirstResponder];
    
    //验证码输入框
    UITextField *VerText = (UITextField *)[self.view viewWithTag:111119];
    
    [VerText resignFirstResponder];
    */
    
    //[SVProgressHUD dismiss];
       
}

- (void)_initViews
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height])];
    _tableView.tableFooterView = bgView;
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake([AdaptInterface convertWidthWithWidth:iphone6Width] - [AdaptInterface convertWidthWithWidth:200], [AdaptInterface convertHeightWithHeight:10], [AdaptInterface convertWidthWithWidth:100], [AdaptInterface convertHeightWithHeight:30]);
    [_registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:colorWithRGB(14, 131, 251) forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_registerButton];
    
    _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetButton.frame = CGRectMake([AdaptInterface convertWidthWithWidth:iphone6Width] - [AdaptInterface convertWidthWithWidth:100], [AdaptInterface convertHeightWithHeight:10], [AdaptInterface convertWidthWithWidth:100], [AdaptInterface convertHeightWithHeight:30]);
    [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetButton setTitleColor:colorWithRGB(246, 67, 73) forState:UIControlStateNormal];
    [_forgetButton addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_forgetButton];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeButton.frame = CGRectMake(0, CGRectGetMaxY(_forgetButton.frame) + [AdaptInterface convertWidthWithWidth:20], [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:47]);
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    _completeButton.backgroundColor = colorWithHexString(@"ff6666");
    [bgView addSubview:_completeButton];
}
#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat leftMargin =[AdaptInterface convertWidthWithWidth:15];
    CGFloat topMargin =[AdaptInterface convertWidthWithWidth:15];
    
    static NSString *iden = @"Cell_PHONE1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        
        //图片
        _Image = [[UIImageView alloc] initWithFrame:CGRectZero];
        _Image.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:_Image];
        
        //输入框
        UITextField *NumberText = [[UITextField alloc] initWithFrame:CGRectZero];
        NumberText.returnKeyType = UIReturnKeyDone;
        NumberText.delegate = self;
        NumberText.tag = 11112;
        [cell.contentView addSubview:NumberText];
    }
    
    _Image.frame = CGRectMake(leftMargin, topMargin, [AdaptInterface convertWidthWithWidth:24], [AdaptInterface convertHeightWithHeight:24]);
    _Image.image = [UIImage imageNamed:_imgArr[indexPath.row]];
    
    UITextField *NumberText = (UITextField *)[cell.contentView viewWithTag:11112];
    
    NumberText.placeholder = _titleArr[indexPath.row];
    
    if (indexPath.row == 0) {
        NumberText.keyboardType = UIKeyboardTypeNumberPad;
        NumberText.frame = CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:7], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:40]);
    }else if (indexPath.row == 1)
    {
        NumberText.keyboardType = UIKeyboardTypeDefault;
        
        NumberText.frame = CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:7], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:40]);
        
        NumberText.secureTextEntry = YES;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AdaptInterface convertHeightWithHeight:55];
}

#pragma mark - 尾视图
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    BOOL error = [[NSUserDefaults standardUserDefaults] boolForKey:@"PhoneError"];
    BOOL err = [[NSUserDefaults standardUserDefaults] boolForKey:@"doneError"];
    if (error) {
        //密码输入框
        UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:11112];
        [PasswordText becomeFirstResponder];
    }else if (err)
    {
        //验证码输入框
        UITextField *VerText = (UITextField *)[self.view viewWithTag:111119];
        [VerText becomeFirstResponder];
    }else
    {
        //手机号输入框
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:11112];
        [PhoneText becomeFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (isError == 3)
    {
        static dispatch_once_t disOnce;
        dispatch_once(&disOnce,  ^ {
            [self LoadVerifyNumber];
        });
        
        return [AdaptInterface convertHeightWithHeight:55];
    }else
    {
        return [AdaptInterface convertHeightWithHeight:0];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.tag = 10000001;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:15], 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:1])];
    lineView.backgroundColor = colorWithRGB(220, 220, 223);
    [bgview addSubview:lineView];
    
    //图片
    _Image = [[UIImageView alloc] initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:15], [AdaptInterface convertHeightWithHeight:15], [AdaptInterface convertWidthWithWidth:24], [AdaptInterface convertHeightWithHeight:24])];
    _Image.contentMode = UIViewContentModeScaleAspectFit;
    _Image.image = [UIImage imageNamed:@"Register_verify"];
    [bgview addSubview:_Image];
    
    //输入框
    UITextField *vifyText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_Image.frame) + [AdaptInterface convertWidthWithWidth:5], [AdaptInterface convertHeightWithHeight:7], [AdaptInterface convertWidthWithWidth:200], [AdaptInterface convertHeightWithHeight:40])];
    vifyText.returnKeyType = UIReturnKeyDone;
    vifyText.delegate = self;
    vifyText.tag = 111119;
    vifyText.placeholder = @"验证码";
    [bgview addSubview:vifyText];
    
    //验证码
    _verifyNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyNumber.frame = CGRectMake([AdaptInterface convertWidthWithWidth:iphone6Width] - [AdaptInterface convertWidthWithWidth:110], [AdaptInterface convertHeightWithHeight:7], [AdaptInterface convertWidthWithWidth:100], [AdaptInterface convertHeightWithHeight:40]);
    [_verifyNumber addTarget:self action:@selector(LoadVerifyNumber) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:_verifyNumber];
    
    return bgview;
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
    UITextField *VerText = (UITextField *)[self.view viewWithTag:111119];
    
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
        
        if ([toBeString length] > 14) { //如果输入框内容大于20则不允许输入
            textField.text = [toBeString substringToIndex:14];
            return NO;
        }
        
        NSString *keyword = [PhoneText.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        
        if ([keyword length] == 7 || [keyword length] == 8 || [keyword length] == 9 || [keyword length] == 10 || [keyword length] == 11 || [keyword length] == 12 || [keyword length] == 13 || [keyword length] == 14) {
            
            //验证手机号码是否正确
//            BOOL isPhone = [AdaptInterface isTelephoneNumber:keyword];
            BOOL isPhone = [self isPhoneNumber:keyword];
            if (!isPhone) {
                [AdaptInterface tipMessageTitle:@"请输入正确的手机号" view:self.view];
                return YES;
            }else
            {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
                
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                
                NSDictionary *param = @{@"loginName":keyword};
               
                //取出该账号的手势密码
                NSMutableArray *gestureWordArrary =[NSMutableArray array];
                NSMutableArray *isHandArray=[NSMutableArray array];
                NSMutableArray *isTouchArray=[NSMutableArray array];
                gestureWordArrary = [fmdbHandle selectHandlePassWordWithAccount:keyword];
                isHandArray =[fmdbHandle selectIsHandWithAccount:keyword];
                isTouchArray=[fmdbHandle selectIsTouchWithAccount:keyword];
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
                
                if ([AdaptInterface isConnected] == YES)
                {
                    if (manager.requestSerializer.timeoutInterval >= 15)
                    {
                        [AdaptInterface tipMessageTitle:@"网络连接失败" view:self.view];
                        return YES;
                    }
                    else
                    {
                        //请求验证错误次数，达到三次要求验证
                        [manager POST:[kRequestIP stringByAppendingString:@"/mfb/usermobilemember/getloginerrorcount.html"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
                         {
                             NSLog(@"%@",operation.responseString);
                             NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                             NSError *err;
                             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                 options:NSJSONReadingMutableContainers
                                                                                   error:&err];
                             
                             int code = [dic[@"code"] intValue];
                             NSString *result = dic[@"result"];
                             
                             UIView *bgView = [self.view viewWithTag:10000001];
                             
                             if (code == 0)
                             {
                                 if ([result integerValue] >= 3)
                                 {
                                     isError = 3;
                                     bgView.hidden = NO;
                                     
                                     BOOL phoneError = YES;
                                     [[NSUserDefaults standardUserDefaults] setBool:phoneError forKey:@"PhoneError"];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     
                                     [_tableView reloadData];
                                 }else
                                 {
                                     isError = 0;
                                     bgView.hidden = YES;
                                     _tableView.tableFooterView.frame=CGRectMake(0,  [AdaptInterface convertHeightWithHeight:110], [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height]);
                                 }
                             }else
                             {
                                 isError = 0;
                                 bgView.hidden = YES;
                                 _tableView.tableFooterView.frame=CGRectMake(0,  [AdaptInterface convertHeightWithHeight:110], [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height]);
                             }
                             
                         }failure:^(AFHTTPRequestOperation *operation, NSError *error)
                         {
                             [AdaptInterface tipMessageTitle:@"操作失败" view:self.view];
                         }];
                    }
                }else
                {
                    [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
                }
            }
        }
    }
    else if (PasswordText == textField)
    {
        if ([toBeString length] >18) {
            textField.text = [toBeString substringToIndex:18];
            return NO;
        }
    }else if (VerText == textField)
    {
        if ([toBeString length] >4) {
            textField.text = [toBeString substringToIndex:4];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 按钮点击事件
//立即注册按钮点击事件
- (void)registerButtonAction:(UIButton *)sender
{
    //手机号输入框
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:11112];
    
    //密码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:11112];
    
    //验证码输入框
    UITextField *VerText = (UITextField *)[self.view viewWithTag:111119];
    
    [PhoneText resignFirstResponder];
    [PasswordText resignFirstResponder];
    [VerText resignFirstResponder];
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//忘记密码按钮点击事件
- (void)forgetAction:(UIButton *)sender
{
    //手机号输入框
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:11112];
    
    //密码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:11112];
    
    //验证码输入框
    UITextField *VerText = (UITextField *)[self.view viewWithTag:111119];
    
    [PhoneText resignFirstResponder];
    [PasswordText resignFirstResponder];
    [VerText resignFirstResponder];
    
    LostPasswordViewController *lostPasswordVC = [[LostPasswordViewController alloc] init];
    [self.navigationController pushViewController:lostPasswordVC animated:YES];
}

//ios 判断字符串为空和只为空格解决办法
- (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//完成按钮点击事件
- (void)completeAction:(UIButton *)sender
{
    NSLog(@"登录");
    
    //手机号输入框
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:11112];
    
    //密码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:11112];
    
    //验证码输入框
    UITextField *VerText = (UITextField *)[self.view viewWithTag:111119];
    
    [PhoneText resignFirstResponder];
    [PasswordText resignFirstResponder];
    [VerText resignFirstResponder];
    
    UIView *bgView = [self.view viewWithTag:10000001];
    
    if ([PhoneText.text isEqualToString:@""])
    {
        [AdaptInterface tipMessageTitle:@"手机号不能为空" view:self.view];
       
        return;
    } //验证手机号码是否正确
//    BOOL isPhone = [AdaptInterface isTelephoneNumber:PhoneText.text];
    BOOL isPhone = [self isPhoneNumber:PhoneText.text];
    if (!isPhone) {
        [AdaptInterface tipMessageTitle:@"请输入正确的手机号" view:self.view];
        
        return;
    }
    else if ([self isBlankString:PasswordText.text])
    {
        [AdaptInterface tipMessageTitle:@"密码不能为空" view:self.view];
        PasswordText.text = nil;
        [PasswordText becomeFirstResponder];
        
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *locationString = [[NSUserDefaults standardUserDefaults] objectForKey:@"Time"];
    
    NSDictionary *params = nil;
    
    if (isError < 3)
    {
        params = @{@"loginName":PhoneText.text,@"password":PasswordText.text,@"imei":[AdaptInterface getUUID]};
    }else
    {
        params = @{@"loginName":PhoneText.text,@"password":PasswordText.text,@"verifyCode":VerText.text,@"nowTime":locationString,@"imei":[AdaptInterface getUUID]};
    }
    
    [SVProgressHUD show];
    if ([AdaptInterface isConnected] == YES)
    {
        
        if (manager.requestSerializer.timeoutInterval >=5)
        {
            [AdaptInterface tipMessageTitle:@"网络连接失败" view:self.view];
            [SVProgressHUD dismiss];
            return;
        }
        else
        {
            [manager POST:[kRequestIP stringByAppendingString:@"/mfb/usermobilemember/savelogin.html"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"----------------%@",operation.responseString);
                NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                int code = [dic[@"code"] intValue];
                NSString *message = dic[@"message"];
                if ([dic[@"result"] isKindOfClass:[NSNull class]]) {
                    [AdaptInterface tipMessageTitle:message view:self.view];
                    [SVProgressHUD dismiss];
                    return;
                }
                NSInteger result = [dic[@"result"] integerValue];
                NSString *sessionId = dic[@"sessionId"];
                
                if (![sessionId isKindOfClass:[NSNull class]])
                {
                    _sessionId = dic[@"sessionId"];
                }
                
                if (code == 0)
                {
                    NSDate *senddate=[NSDate date];
                    
                    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                    
                    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    
                    NSString *locationString=[dateformatter stringFromDate:senddate];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:PhoneText.text forKey:@"PhoneText"];
                    
                    //MD5加密当前时间和手机号作为动态密钥
                    NSString *newStr = [NSString stringWithFormat:@"%@%@",locationString,PhoneText.text];
                    NSString *newText = [AdaptInterface getMd5_32Bit_String:newStr];
                    
                    //AES加密密码
                    NSString *string = [SecurityUtil encryptAESData:PasswordText.text app_key:newText];
                    
                    [userDefaults setObject:newText forKey:@"Dynamic"];
                    NSLog(@"nnnnnnnnnnn------------%@",newText);
                    [userDefaults setObject:string forKey:@"MFB"];
                    [userDefaults setObject:_sessionId forKey:@"sessionId"];
                    //设置实名认证默认tag值为0.当用户再次登录时重置为0；只要用户跳出登陆框则重置tag值为0，此时实名认证就会重新请求接口，获取数据
                    NSInteger realNameTag =0;
                    [userDefaults setInteger:realNameTag forKey:@"realNameTag"];
                    
                    [userDefaults synchronize];
                    
                    //将账号和手势密码,手势开关状态,指纹状态存入数据库
                    [fmdbHandle insertNumAccount:PhoneText.text HPassWord:gestureWord IsHand:isHandString IsTouch:isTouchString];
                    //respondsToSelector 方法来判断是否实现了某个方法
                    if ([self.delegate respondsToSelector:@selector(LoginSuccess)])
                    {
                        [self.delegate LoginSuccess];
                    }
                    
                    [self popViews];
                }else
                {
                    [self LoadVerifyNumber];
                    
                    if (result == 3)
                    {
                        isError = result;
                        bgView.hidden = NO;
                        
                        BOOL doneError = YES;
                        [[NSUserDefaults standardUserDefaults] setBool:doneError forKey:@"doneError"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [_tableView reloadData];
                    }
                    
                    [AdaptInterface tipMessageTitle:message view:self.view];
                    
                    if ([message isEqualToString:@"没有找到用户"]) {
                        [AdaptInterface tipMessageTitle:@"用户名或密码错误" view:self.view];
                        PasswordText.text = nil;
                        [PasswordText becomeFirstResponder];
                        [SVProgressHUD dismiss];
                        return;
                    }else if ([message isEqualToString:@"用户名或密码错误"])
                    {
                        PasswordText.text = nil;
                        VerText.text = nil;
                        [PasswordText becomeFirstResponder];
                        [SVProgressHUD dismiss];
                        return;
                    }else if ([message isEqualToString:@"验证码错误"])
                    {
                        VerText.text = nil;
                        [VerText becomeFirstResponder];
                        [SVProgressHUD dismiss];
                        return;
                    }
                    [SVProgressHUD dismiss];
                    return;
                }
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:self.view];
                [SVProgressHUD dismiss];
                return;
            }];
        }
    }
    else
    {
        [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
        [SVProgressHUD dismiss];
        return;
    }
}

-(void)notificationCenter
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"money" object:nil userInfo:nil];
}

- (void)LoadVerifyNumber
{
    NSLog(@"点击了---");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    [[NSUserDefaults standardUserDefaults] setObject:locationString forKey:@"Time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *params = @{@"nowTime":locationString};
    
    [manager POST:[kRequestIP stringByAppendingString:@"/mfb/randomcode/randomcodeimage.html"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //设置验证码图片
        [_verifyNumber setImage:[UIImage imageWithData:responseObject] forState:UIControlStateNormal];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)dismiss{
    [SVProgressHUD dismiss];
}

#pragma mark - 弹出手势验证的自动登录
-(void)AutomaticLogin
{
//    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
//    NSString *phone = [defualt objectForKey:@"PhoneText"];
//    
//    /**
//     *  NSUserDefaults进行switch状态的存储和读取，这里是进行读取
//     */
//    BOOL isTouch=[defualt boolForKey:@"isTouchSwitchValue"];
//    
//    /**
//     *  NSUserDefaults进行switch状态的存储和读取，这里是进行读取
//     */
//    BOOL isHand;
//    fmdbHandle = [FMDBHandle shareHandle];
//    NSMutableArray *isHandAry=[NSMutableArray array];
//    isHandAry=[fmdbHandle selectIsHandWithAccount:phone];
//    NSString *isHandStr=[isHandAry lastObject];
//    if ([isHandStr isEqualToString:@""]) {
//        isHand = NO;
//    }
//    else{
//        
//        isHand =[isHandStr isEqual:@"0"]?NO:YES;
//    }
//        if (isTouch==YES || isHand == YES)
//        {
//            AppDelegate *myAPPdelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//            [myAPPdelegate authenticationView];//弹出手势或指纹验证
//            /*
//             如果手势或指纹验证成功，调用自动登录;如果不成功或点击忘记密码，不调用自动登录
//             */
//        }else
//        {
            [self Automatic];
//        }
}

//自动登录
-(void)Automatic
{
    [SVProgressHUD dismiss];
    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
    
    NSString *sessionId = [defualt objectForKey:@"sessionId"];
    NSString *phone = [defualt objectForKey:@"PhoneText"];
    NSString *mfb = [defualt objectForKey:@"MFB"];
    NSString *dynamic = [defualt objectForKey:@"Dynamic"];
    sessionId = @"";
    NSLog(@"sessionId ==自动 %@",sessionId);
    [defualt setObject:sessionId forKey:@"sessionId"];
    [defualt synchronize];
    
    NSData *EncryptData = [GTMBase64 decodeString:mfb]; //解密前进行GTMBase64编码
    NSString *string = [SecurityUtil decryptAESData:EncryptData app_key:dynamic];
    
    [SVProgressHUD show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSDictionary *params = @{@"loginName":phone,@"password":string,@"imei":[AdaptInterface getUUID]};
    NSLog(@"**************************%@",[AdaptInterface getUUID]);
    if ([AdaptInterface isConnected] == YES)
    {
        if (manager.requestSerializer.timeoutInterval >= 15)
        {
            [AdaptInterface tipMessageTitle:@"网络连接失败" view:self.view];
            [SVProgressHUD dismiss];
            return;
        }
        else
        {
            [manager POST:[kRequestIP stringByAppendingString:@"/mfb/usermobilemember/savelogin.html"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"---------%@",operation.responseString);
                NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                NSString *sessionId = dic[@"sessionId"];
                
                if (![sessionId isKindOfClass:[NSNull class]])
                {
                    _sessionId = dic[@"sessionId"];
                }
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_sessionId forKey:@"sessionId"];
                [userDefaults synchronize];
                
                //respondsToSelector 方法来判断是否实现了某个方法
                if ([self.delegate respondsToSelector:@selector(AutoLoginSuccess)])
                {
                    [self.delegate AutoLoginSuccess];
                }
                
                [SVProgressHUD dismiss];
                return;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:self.view];
                [SVProgressHUD dismiss];
                return;
            }];
        }
    }
    else
    {
        [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
        [SVProgressHUD dismiss];
        return;
    }
}

-(void)dealloc
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *PhoneText = (UITextField *)[cell.contentView viewWithTag:11112];
    if ([PhoneText isFirstResponder]) {
        
        [PhoneText resignFirstResponder];
    }
    
    //密码输入框
    UITableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *PasswordText = (UITextField *)[cell1.contentView viewWithTag:11112];
    if ([PasswordText isFirstResponder]) {
        
        [PasswordText resignFirstResponder];
    }
    
    //验证码输入框
    UITextField *VerText = (UITextField *)[self.view viewWithTag:111119];
    if (VerText != nil)
    {
        if ([VerText isFirstResponder])
        {
            
            [VerText resignFirstResponder];
        }
        
    }
}

- (BOOL)isPhoneNumber:(NSString *)iphonenumber
{
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189
         */
        // NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         12         */
        //NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186
         17         */
        // NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,189
         22         */
        NSString * CT = @"^1[3|4|5|7|8][0-9]{9}$";
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        NSString *phs = @"^[\\d]{7,14}$";
        
        // NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        // NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        //NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
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

@end
