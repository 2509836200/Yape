//
//  PublicTool.m
//  MFB
//
//  Created by 李霞 on 16/9/13.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "PublicTool.h"

@implementation PublicTool
+(UITableView *)initTableViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView tag:(NSInteger)tag
{
    UITableView *tableView = (UITableView *)[superView viewWithTag:tag];
    if (!tableView) {
        tableView = [[UITableView alloc] initWithFrame:frame];
        tableView.backgroundColor = bgColor;
        tableView.tag = tag;
        [superView addSubview:tableView];
    }
    
    return tableView;
}

+(UIImageView *)initImageViewWithFrame:(CGRect)frame imageStr:(NSString *)imageStr superView:(UIView *)superView tag:(NSInteger)tag
{
    UIImageView *imageView = (UIImageView *)[superView viewWithTag:tag];
    if (!imageView) {
        if (imageStr) {
            imageView.image = [UIImage imageNamed:imageStr];
        }
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.tag = tag;
        [superView addSubview:imageView];
    }
    
    return imageView;

}

+(UILabel *)initLableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment superView:(UIView *)superView tag:(NSInteger)tag
{
    UILabel *lable = (UILabel *)[superView viewWithTag:tag];
    if (!lable) {
        lable = [[UILabel alloc] initWithFrame:frame];
        lable.text = text;
        lable.textColor = textColor;
        lable.font = font;
        lable.textAlignment = textAlignment;
        [superView addSubview:lable];
        lable.tag = tag;
        
    }
    return lable;
}

@end
