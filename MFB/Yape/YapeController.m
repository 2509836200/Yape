//
//  YapeController.m
//  MFB
//
//  Created by 翟凤禄 on 16/9/12.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "YapeController.h"
#import "YapeCell.h"
#import "HttpManager.h"
@interface YapeController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *customTableView;
@property (nonatomic, strong)NSArray *contentArray;
@end

@implementation YapeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Yape";
    self.view.backgroundColor =[UIColor greenColor];
    self.customTableView = [PublicTool initTableViewWithFrame:CGRectMake(0, 0, currentViewWidth, normalScreenHeight) bgColor:colorWithHexString(@"ffffff") superView:self.view tag:110];
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    [self initContentArr];
}

-(void)initContentArr
{
    self.contentArray = @[@{@"title":@"发起邀约",
                            @"englishTitle":@"Issued dating",
                            @"bgImage":@"Yape_makeInvitation.jpg"
                            },
                          @{
                            @"title":@"查看邀约",
                            @"englishTitle":@"Check the dating",
                            @"bgImage":@"Yape_lookInvitation.jpg"
                              },
                          @{
                              @"title":@"自我推荐",
                              @"englishTitle":@"Self recommendation",
                              @"bgImage":@"Yape_recommendSelf.jpg"
                              }
                          ];
}
#pragma UITableViewDelegate&&DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"YapeCell";
    YapeCell *yapeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!yapeCell) {
        yapeCell = [[YapeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        yapeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [self.contentArray objectAtIndex:indexPath.row];
    [yapeCell SetContentWithDictionary:dic];
    return yapeCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return normalScreenHeight/3.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
   [HttpManager afRequestWithURL2:@"https://www.baidu.com" httpHeaders:nil params:nil data:nil tipMessage:self.view httpMethod:@"GET" completion:^(id result, long timeDiff, NSString *networkTime) {
       NSLog(@"%@",result);
   } failure:^(id result) {
       NSLog(@"%@",result);
   }];
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
