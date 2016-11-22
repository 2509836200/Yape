//
//  CreateGroupViewController.m
//  MFB
//
//  Created by 翟凤禄 on 16/9/21.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "CreateGroupViewController.h"

@interface CreateGroupViewController ()<EMGroupManagerDelegate>
{
    UITextField *titleGroupTF;// 群组名称
    UITextField *contentGroupTF ;//群介绍
}
@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"创建群组";
    [self createLeftItemWithImage:@"common_back" highlightedImageName:nil target:self action:@selector(pop)];
    
    [self createSubView];
}
-(void)createSubView{
    CGFloat leftMargin = [AdaptInterface convertWidthWithWidth:15];
    titleGroupTF =[[UITextField alloc]initWithFrame:CGRectMake(leftMargin, 5, self.view.frame.size.width, [AdaptInterface convertWidthWithWidth:30])];
    titleGroupTF.placeholder =@"请输入群组名称";
    [self.view addSubview:titleGroupTF];
    
    contentGroupTF =[[UITextField alloc]initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(titleGroupTF.frame)+10, CGRectGetWidth(titleGroupTF.frame), [AdaptInterface convertWidthWithWidth:50])];
    contentGroupTF.placeholder = @"输入群简介";
    [self.view addSubview:contentGroupTF];
    
    UIButton *creatGroup=[UIButton buttonWithType:UIButtonTypeCustom];
    creatGroup.frame =CGRectMake(0, CGRectGetMaxY(contentGroupTF.frame)+50, CGRectGetWidth(self.view.frame), 30);
    [creatGroup setTitle:@"创建群" forState: UIControlStateNormal];
    [creatGroup setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [creatGroup addTarget:self action:@selector(creatGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatGroup];
}
-(void)creatGroup{
    [self showHudInView:self.view hint:@"创建群组..."];
    //设置群属性
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = 2000;
    setting.style = EMGroupStylePublicOpenJoin;//公开群,自由加入
    __weak CreateGroupViewController *weakSelf = self;
    //当前用户
    NSString *username = [[EMClient sharedClient] currentUsername];
    NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join groups \'%@\'"), username, titleGroupTF.text];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:titleGroupTF.text description:contentGroupTF.text invitees:nil message:messageStr setting:setting error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (group && !error) {
                [weakSelf showHint:@"群组创建成功"];
                //[AdaptInterface tipMessageTitle:NSLocalizedString(@"group.create.success", @"create group success") view:self.view];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else{
                [weakSelf showHint:@"群组创建失败"];
            }
        });
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
