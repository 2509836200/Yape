//
//  BaseViewController.h
//  MFB
//
//  Created by llc on 15/8/19.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/*!
 @method
 @abstract   创建导航条返回按钮
 @discussion
 @result    N/A
 */
-(void)createBackItemWithTarget:(id)target;

/*!
 @method
 @abstract   创建导航条左按钮
 @discussion
 @param 	imageName 	按钮图片
 @param 	selectedImageName 	按钮高亮的图片
 @param 	target 	按钮点击事件响应对象
 @param 	selector 	按钮点击事件响应方法
 @result    N/A
 */
- (void)createLeftItemWithImage:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)selector;

/*!
 @method
 @abstract   返回事件
 @discussion
 @result    N/A
 */
-(void)pop;


/*!
 @method
 @abstract   创建导航条右边按钮
 @discussion
 @param 	target 	按钮点击事件响应对象
 @param 	selector 	按钮点击事件响应方法
 title_  按钮的名字
 @result    N/A
 */
- (void)createRightItemWithTitle:(NSString*)title action:(SEL)selector target:(id)target;

#pragma mark 去掉多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView;

@end
