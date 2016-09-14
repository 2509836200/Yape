//
//  PublicTool.h
//  MFB
//
//  Created by 李霞 on 16/9/13.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicTool : NSObject
+(UITableView *)initTableViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView tag:(NSInteger)tag;
+(UIImageView *)initImageViewWithFrame:(CGRect)frame imageStr:(NSString *)imageStr superView:(UIView *)superView tag:(NSInteger)tag;
+(UILabel *)initLableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment superView:(UIView *)superView tag:(NSInteger)tag;
+(UIButton *)initButtonWithFrame:(CGRect)frame text:(NSString *)text
                            font:(UIFont *)font
                 normalTextColor:(UIColor *)normalTextColor
                   normalBgColor:(UIColor *)normalBgColor
                             tag:(NSInteger)tag
                       superView:(UIView *)superView
                          target:(id)target
                          action:(SEL)action;
@end
