//
//  WebViewController.m
//  MFB
//
//  Created by xinping-2 on 15/8/14.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView *_webViews;
    WKWebView *_wkWebView;
    UIProgressView *progressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        [_progressView removeFromSuperview];
        [_webViews stopLoading];
        _webViews.delegate = nil;
        _progressProxy.webViewProxyDelegate = nil;
        _progressProxy.progressDelegate = nil;
    }
    else
    {
        [progressView removeFromSuperview];
        [_wkWebView stopLoading];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航栏左侧按钮
    [self createLeftItemWithImage:@"common_back" highlightedImageName:@"" target:self action:@selector(pop)];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlstring]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if (iPhone4) {
            _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height]-150)];
        }
        else{
            _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height] - 60)];
        }
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        _wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
        
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        progressView = [[UIProgressView alloc] initWithFrame:barFrame];
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        progressView.tintColor = [UIColor redColor];
        progressView.trackTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:progressView];
        
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
        [self.view addSubview:_wkWebView];
        
        if ([AdaptInterface isConnected])
        {
            [_wkWebView loadRequest:request];
        }
        else
        {
            [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
        }
        
        
    }
    else
    {
        if (iPhone4) {
            _webViews = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height]-150)];
        }
        else{
            _webViews = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:iphone6Height] - 60)];
        }
        
        _webViews.scalesPageToFit = YES;
        
        //隐藏拖拽UIWebView时上下的两个阴影效果
        UIScrollView *scrollView = [_webViews.subviews objectAtIndex:0];
        if (scrollView)
        {
            for (UIView *view in [scrollView subviews])
            {
                if ([view isKindOfClass:[UIImageView class]])
                {
                    view.hidden = YES;
                }
            }
        }
        
        _webViews.delegate = self;
        
        //禁用UIWebView拖拽时的反弹效果
        [(UIScrollView *)[[_webViews subviews] objectAtIndex:0] setBounces:NO];
        
        
        _webViews.scrollView.showsVerticalScrollIndicator = NO;
        _webViews.scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:_webViews];

        _progressProxy = [[NJKWebViewProgress alloc] init];
        _webViews.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
       
        if ([AdaptInterface isConnected])
        {
            [_webViews loadRequest:request];
        }
        else
        {
            [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
        }
        
        
    }

    
}
#pragma mark WKWebView createWebViewWithConfiguration
/**
 *  此方法不写,所有的 webview 里面的 navigation 跳转都没有作用
 */
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)setUrlString:(NSString *)urlString
{
    _urlstring = urlString;
}

-(void)pop{
    if([_flag isEqualToString:@"rechergeVC"]){
        [self.navigationController popViewControllerAnimated:YES];
        if (_backRechargeBlock) {
            _backRechargeBlock();
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    if ([self.title isEqualToString:@"<null>"]|| self.title == nil)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
        //获取当前页面的title
        self.title = [_webViews stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '85%'"];//调整webView body 字体的大小，修改百分比即可
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        
        if (object == _wkWebView)
        {
            [progressView setAlpha:1.0f];
            [progressView setProgress:_wkWebView.estimatedProgress animated:YES];
            
            if(_wkWebView.estimatedProgress >= 1.0f)
            {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    progressView.hidden = YES;
                    //[progressView setProgress:0.0f animated:NO];
                }];
                
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == _wkWebView)
        {
            self.title = _wkWebView.title;
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    }
    else
    {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView removeObserver:self forKeyPath:@"title"];
}


@end
