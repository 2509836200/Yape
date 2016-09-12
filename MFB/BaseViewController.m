//
//  BaseViewController.m
//  MFB
//
//  Created by llc on 15/8/19.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIImageView *imageView;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 4.设置导航栏主题
    [self setNavigationBarTheme];
    //进度轮类型的修改
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//黑色底部
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//进度轮转动的类型
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];//蒙版类型，当进度轮开启后不能进行其他操作

}

#pragma mark 设置导航栏样式
-(void) setNavigationBarTheme
{
    UINavigationBar *bar =[UINavigationBar appearance];
    [bar setShadowImage:[[UIImage alloc]init]];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationBg"] forBarMetrics:UIBarMetricsDefault];
    
    //设置文字风格
    [bar setTitleTextAttributes:@{
                                  UITextAttributeTextColor:[UIColor whiteColor],
                                  UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]
                                  }];
    // 2.设置导航栏上的按钮样式
    UIBarButtonItem *barItem=[UIBarButtonItem appearance];
    //设置背景图片
    [barItem setTitleTextAttributes:@{
                                      UITextAttributeTextColor:[UIColor whiteColor],
                                      UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero],
                                      UITextAttributeFont:[UIFont systemFontOfSize:17]
                                      } forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:@{
                                      UITextAttributeTextColor:[UIColor whiteColor],
                                      UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero],
                                      UITextAttributeFont:[UIFont systemFontOfSize:17]
                                      } forState:UIControlStateHighlighted];
    
}
#pragma mark 返回
-(void)createBackItemWithTarget:(id)target
{
    // 导航栏左侧按钮
    [self createLeftItemWithImage:@"common_back" highlightedImageName:@"" target:target action:@selector(pop)];
}
/*!
 @method
 @abstract   创建导航条左按钮
 @discussion
 @param 	imageName 	按钮图片
 @param 	selectedImageName 	按钮选中后的图片
 @param 	target 	按钮点击事件响应对象
 @param 	selector 	按钮点击事件响应方法
 @result    N/A
 */
- (void)createLeftItemWithImage:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)selector
{
    /*
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake([AdaptInterface convertWidthWithWidth:2], [AdaptInterface convertHeightWithHeight:2], [AdaptInterface convertWidthWithWidth:22], [AdaptInterface convertWidthWithWidth:21])];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (highlightedImageName) {
        [btn setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }
    [btn sizeToFit];
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem=btnItem;
  */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectZero;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:(44-48)/2], [AdaptInterface convertHeightWithHeight:(44-30)/2], [AdaptInterface convertWidthWithWidth:20], [AdaptInterface convertHeightWithHeight:20])];
    if (iPhone4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:(44-38)/2], [AdaptInterface convertHeightWithHeight:(44-20)/2], [AdaptInterface convertWidthWithWidth:20], [AdaptInterface convertHeightWithHeight:20])];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:imageName];
    //imageView.userInteractionEnabled = YES;
    [button addSubview:imageView];
    
    button.frame = CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:44], [AdaptInterface convertHeightWithHeight:44]);
    [button sizeToFit];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*!
 @method
 @abstract   创建导航条右边按钮
 @discussion
 @param 	target 	按钮点击事件响应对象
 @param 	selector 	按钮点击事件响应方法
 title_  按钮的名字
 @result    N/A
 */
- (void)createRightItemWithTitle:(NSString*)title action:(SEL)selector target:(id)target
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 80, 40)];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *flexSpace =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexSpace.width = -10;
    
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:flexSpace,btnItem,nil];
}
#pragma mark 去掉多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
@end
