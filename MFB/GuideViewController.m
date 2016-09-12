//
//  GuideViewController.m
//  MFB
//
//  Created by yinxuehua on 15/9/16.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "GuideViewController.h"
#import "MainViewController.h"

#define KImageCount 4

@interface GuideViewController ()
{
    UIImageView *_bgImageView;
    UIPageControl *_pageControl;
    UIButton *_sharedWeibo;
    
    NSString *imageNames;
}
@end

@implementation GuideViewController
-(void)loadView
{
    _bgImageView =[[UIImageView alloc] init];
    _bgImageView.frame = [UIScreen mainScreen].bounds;
    _bgImageView.backgroundColor = [UIColor whiteColor];
    
    self.view = _bgImageView;  //由于设置控制器的View为UIImageView,所以不能和用户交互，那么需要设置userInteractionEnabled为Yes，那么他上面的子View才可以与用户交互
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat imageViewWidth = _bgImageView.frame.size.width;
    
    // 1.添加UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = _bgImageView.frame;   //表示在屏幕上显示该scrollView的边框大小
    scrollView.contentSize = CGSizeMake(imageViewWidth * KImageCount, 0); //表示在（x轴和Y轴）滚动的大小
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;  //允许分页
    scrollView.delegate = self;      //设置代理，实现协议
    scrollView.tag = 7777;
    [_bgImageView addSubview:scrollView];
    
    
    // 2.添加背景图片上的新特性imageView
    for (int i=0; i<KImageCount; i++) {
        [self addImageWithIndex:i AboveView:scrollView];
    }
    
    //3.UIPageControl自定义
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [AdaptInterface convertHeightWithHeight:iphone6Height - 50], [AdaptInterface convertWidthWithWidth:iphone6Width], 20)];
    if (iPhone4)
    {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [AdaptInterface convertHeightWithHeight:iphone6Height - 130], [AdaptInterface convertWidthWithWidth:iphone6Width], 20)];
    }
    _pageControl.numberOfPages = KImageCount;
    _pageControl.currentPage = 0;
    //未被选中点的颜色
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    //当前点的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [_pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    [_bgImageView addSubview:_pageControl];
     
    

}


- (void)pageAction:(UIPageControl *)page
{
    //令UIScrollView做出相应的滑动显示
    UIScrollView *scrollView = (UIScrollView *)[_bgImageView viewWithTag:7777];
    //取得当前的页数
    NSInteger index = page.currentPage;
    
    CGPoint p = CGPointMake((_bgImageView.frame.size.width)*index, 0);
    
    //设置scrollView的偏移量
    [scrollView setContentOffset:p animated:YES];
    
}

-(void) addImageWithIndex:(int) index AboveView:(UIView *) superView
{
    CGFloat imageViewWidth = _bgImageView.frame.size.width;
    CGFloat imageViewHeight= _bgImageView.frame.size.height;
    
    // 1.创建UIImageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(index*imageViewWidth, 0, imageViewWidth, imageViewHeight);
    // 2.设置Image
    imageNames = [NSString stringWithFormat:@"ios%d.png",index+1];
    if (iPhone4)
    {
        imageNames = [NSString stringWithFormat:@"iphone%d.png",index+1];
    }
    imageView.image = [UIImage imageNamed:imageNames];
    // 3.添加到scrollView上面
    [superView addSubview:imageView];
    //4.设置“分享，立即体验”按钮
    if (index == 3) {
        // 1.设置该View可用交互
        imageView.userInteractionEnabled = YES;
        
        // 3.设置分享按钮
        UIButton *shared= [UIButton buttonWithType:UIButtonTypeCustom];
        shared.center = CGPointMake(imageViewWidth *0.5, imageViewHeight * 0.89);
        shared.bounds = CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:430/2], [AdaptInterface convertHeightWithHeight:94/2]);
         shared.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:94/2/2];
        if (iPhone4)
        {
            shared.center = CGPointMake(imageViewWidth *0.5, imageViewHeight * 0.92);
            shared.bounds = CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:430/2], [AdaptInterface convertHeightWithHeight:94/2 - 10]);
             shared.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:(94/2 - 10)/2];
        }

        [shared setTitle:@"立即体验" forState:UIControlStateNormal];
        shared.titleLabel.font = [UIFont systemFontOfSize:17.0];
        shared.layer.borderWidth = 1;
        shared.layer.borderColor = [UIColor whiteColor].CGColor;
        shared.layer.masksToBounds = YES;

        [shared addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        //设置高亮状态下不改变按钮颜色
        shared.adjustsImageWhenHighlighted = NO;
        //设置默认选中状态
        shared.selected = YES;
        [imageView addSubview:shared];
        
    }
    
}

#pragma mark 改变分享按钮状态
-(void) changeStatus:(UIButton *)btn
{
    self.view.window.rootViewController = [[MainViewController alloc] init];
}
#pragma mark - 设置pageControl滚动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}



@end
