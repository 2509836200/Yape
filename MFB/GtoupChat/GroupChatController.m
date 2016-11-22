//
//  GroupChatController.m
//  MFB
//
//  Created by 翟凤禄 on 16/9/13.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "GroupChatController.h"
#import "CreateGroupViewController.h"
#import "ChatViewController.h"
#import "JoinPublicGroupController.h"
@interface GroupChatController ()<EMGroupManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation GroupChatController
- (void)dealloc
{
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {                  
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"群聊";
//#warning 把self注册为SDK的delegate
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    _tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _dataSource = [NSMutableArray array];
    //获取所有群组
    [self reloadDataSource];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section ==0){
        return 2;
    }else{
        return _dataSource.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indent =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:indent];
    if(!cell){
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indent];
    }
    if(indexPath.section ==0){
        if(indexPath.row==0){
            cell.textLabel.text = NSLocalizedString(@"group.create.group",@"Create a group");
            cell.imageView.image = [UIImage imageNamed:@"group_creategroup"];

        }else{
            cell.textLabel.text = NSLocalizedString(@"group.create.join",@"Join public group");
            cell.imageView.image = [UIImage imageNamed:@"group_joinpublicgroup"];
        }
    }else{
         EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        NSString *imageName = @"group_header";
        cell.imageView.image = [UIImage imageNamed:imageName];
        if (group.subject && group.subject.length > 0) {
            cell.textLabel.text = group.subject;
        }
        else {
            cell.textLabel.text = group.groupId;
        }

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section ==0){
        switch (indexPath.row) {
            case 0:
                [self createGroup];
                break;
            case 1:
                [self showPublicGroupList];
                break;
            default:
                break;
        }
    }else{
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc]initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
        chatController.title = group.subject;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}
#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:groupList];
    [_tableView reloadData];
}
#pragma mark - data

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    EMError *error = nil;
    NSArray *rooms = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
    [self.dataSource addObjectsFromArray:rooms];
    
    [_tableView reloadData];
}
#pragma mark - action

- (void)showPublicGroupList
{
    JoinPublicGroupController *publicController = [[JoinPublicGroupController alloc] init];
    [self.navigationController pushViewController:publicController animated:YES];
}

- (void)createGroup
{
    CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
    [self.navigationController pushViewController:createChatroom animated:YES];
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
