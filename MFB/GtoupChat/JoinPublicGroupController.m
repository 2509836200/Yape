//
//  JoinPublicGroupController.m
//  MFB
//
//  Created by 翟凤禄 on 16/9/22.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "JoinPublicGroupController.h"
#import "PublicGroupDetailViewController.h"
@interface JoinPublicGroupController ()<UITableViewDataSource , UITableViewDelegate>
@property (nonatomic, strong) NSString *cursor;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;
@end

#define FetchPublicGroupsPageSize   50

@implementation JoinPublicGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"加入公开群";
    self.view.backgroundColor =[UIColor whiteColor];
    [self createLeftItemWithImage:@"common_back" highlightedImageName:nil target:self action:@selector(pop)];
    self.dataSource = [NSMutableArray array];
    [self getGroupsDate];
}
-(void)getGroupsDate{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMCursorResult *result = [[EMClient sharedClient].groupManager getPublicGroupsFromServerWithCursor:weakSelf.cursor pageSize:FetchPublicGroupsPageSize error:&error];
        if (weakSelf)
        {
            JoinPublicGroupController *strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf hideHud];
                
                if (!error)
                {
                    NSMutableArray *oldGroups = [self.dataSource mutableCopy];
                    [self.dataSource removeAllObjects];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [oldGroups removeAllObjects];
                    });
                    [strongSelf.dataSource addObjectsFromArray:result.list];
                    [strongSelf.tableView reloadData];
                    strongSelf.cursor = result.cursor;
                }else{
                    _dataSource = (NSMutableArray *)result.list;
                }
            });
        }
    });
    
    [self creatTableView];
}
-(void)creatTableView
{
    self.tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
    if (group.subject && group.subject.length > 0) {
        cell.textLabel.text = group.subject;
    }
    else {
        cell.textLabel.text = group.groupId;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    PublicGroupDetailViewController *detailController = [[PublicGroupDetailViewController alloc] initWithGroupId:group.groupId];
    detailController.title = group.subject;
    [self.navigationController pushViewController:detailController animated:YES];
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
