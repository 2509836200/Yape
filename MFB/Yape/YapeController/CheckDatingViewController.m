//
//  CheckDatingViewController.m
//  MFB
//
//  Created by 李霞 on 16/9/14.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "CheckDatingViewController.h"
#import "TopChangeView.h"
@interface CheckDatingViewController ()

@end

@implementation CheckDatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看邀约";
    self.view.backgroundColor = [UIColor orangeColor];
    TopChangeView *topChangeView = [[TopChangeView alloc] initWithFrame:CGRectMake(10, 0, currentViewWidth - 10*2, 50) andTitlesArray:@[@"今日邀约",@"所有邀约",@"我的关注",@"我的邀约"] selectedColor:[UIColor redColor] unSelectedColor:[UIColor whiteColor] selectedIndex:0];
    [self.view addSubview:topChangeView];
    //这里需要预先加载默认的view或数据
    topChangeView.changeViewBlock = ^(NSInteger index)
    {
        //变换View
        NSLog(@"chage View = %ld",(long)index);
    };
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
