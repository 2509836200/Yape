//
//  YapeController.m
//  MFB
//
//  Created by 翟凤禄 on 16/9/12.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "YapeController.h"
#import "RegisterViewController.h"
@interface YapeController ()

@end

@implementation YapeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Yape";
    self.view.backgroundColor =[UIColor greenColor];
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(100, 200, 100, 100);
    button.backgroundColor =[UIColor redColor];
    [button addTarget:self action:@selector(aa) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)aa{
    RegisterViewController *regist=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
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
