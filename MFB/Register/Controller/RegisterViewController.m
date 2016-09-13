//
//  RegisterViewController.m
//  MFB
//
//  Created by weibinbin on 15/8/14.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "RegisterViewController.h"

#import <AVFoundation/AVFoundation.h>
#define NUMBERS @"0123456789\n"

@interface RegisterViewController ()
{
    UIView *backView;
    NSArray *keyArr;
    UITextField *weiChatNU;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.view.backgroundColor = colorWithHexString(@"#f1f5f8");
    
    keyArr =@[@"微信号",@"性别",@"城市",@"年龄",@"身高",@"体型"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:self.view.frame.size.height-[AdaptInterface convertWidthWithWidth:65]]) style:UITableViewStylePlain];
    _tableView.backgroundColor = colorWithHexString(@"#f1f5f8");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self tableHeadView];
    _tableView.tableFooterView =[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    //取消滑动条
    _tableView.showsVerticalScrollIndicator = NO;
    //取消滑动
    _tableView.scrollEnabled = NO;
    
    

}

- (UIView *)tableHeadView {
   
    CGFloat leftMargin =[AdaptInterface convertWidthWithWidth:10];
    CGFloat topMargin =[AdaptInterface convertWidthWithWidth:4];
    backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [AdaptInterface convertHeightWithHeight:58+110])];
    backView.backgroundColor =[UIColor grayColor];
    UILabel *textLB=[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, topMargin, self.view.frame.size.width-2*leftMargin, 50)];
    textLB.text = @"请以红色数字进行个人照片验证,验证照片只有管理员审核查看,其他用户无法查看。";
    textLB.font =[UIFont systemFontOfSize:14.5];
    textLB.textColor =[UIColor whiteColor];
    textLB.numberOfLines =0;
    [self.view addSubview:backView];
    [backView addSubview:textLB];
    
    UILabel *lineLB =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textLB.frame)+0.5, self.view.frame.size.width, 0.5)];
    lineLB.backgroundColor = [UIColor blackColor];
    [backView addSubview:lineLB];
    
    UIButton *imageBT =[[UIButton alloc]initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(lineLB.frame)+10, [AdaptInterface convertWidthWithWidth:85], [AdaptInterface convertWidthWithWidth:85])];
    imageBT.backgroundColor =[UIColor blueColor];
    [backView addSubview:imageBT];
    
    UILabel *registNum=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageBT.frame)+leftMargin, CGRectGetMidY(imageBT.frame)-10, self.view.frame.size.width-CGRectGetMaxX(imageBT.frame)-CGRectGetWidth(imageBT.frame)-3*leftMargin, [AdaptInterface convertWidthWithWidth:25])];
    registNum.text = @"验证数字:1003400";
    registNum.textAlignment = NSTextAlignmentCenter;
    registNum.font = [UIFont systemFontOfSize:14.5];
    [backView addSubview:registNum];
    
    UIButton *imageBT2 =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(registNum.frame)+leftMargin, CGRectGetMaxY(lineLB.frame)+10, [AdaptInterface convertWidthWithWidth:85], [AdaptInterface convertWidthWithWidth:85])];
    imageBT2.backgroundColor =[UIColor blueColor];
    [backView addSubview:imageBT2];
    return backView;
}
#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
        UILabel *keyLB =[[UILabel alloc]initWithFrame:CGRectMake(leftMargin, topMargin, 80, [AdaptInterface convertWidthWithWidth:25])];
        keyLB.tag = 100;
        keyLB.font = [UIFont systemFontOfSize:14.5];
        [cell.contentView addSubview:keyLB];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *keyLB =(UILabel *)[cell.contentView viewWithTag:100];
    keyLB.text =keyArr[indexPath.row];
    if(indexPath.row==0){
        
    }
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

@end
