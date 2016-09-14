//
//  TopChangeView.m
//  MFB
//
//  Created by 李霞 on 16/9/14.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "TopChangeView.h"

@interface TopChangeView ()
@property (nonnull, strong)NSMutableArray *itemsArray;
@end
@implementation TopChangeView

-(UIColor *)selectedColor
{
    if (!_selectedColor) {
        _selectedColor = [UIColor blackColor];
    }
    return _selectedColor;
}

-(UIColor *)unSelectedColor
{
    if (!_unSelectedColor) {
        _unSelectedColor = [UIColor whiteColor];
    }
    return _unSelectedColor;
}

-(instancetype)initWithFrame:(CGRect)frame andTitlesArray:(NSArray<NSString *>*)titlesArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatItemUIWithTitlesArray:titlesArray];
    }
    return self;
}

-(void)creatItemUIWithTitlesArray:(NSArray *)titlesArray
{//self和所有item所需要的width相等
    self.itemsArray = [NSMutableArray array];
    CGFloat itemWidth = self.frame.size.width/4.0;
    int i = 0;
    for (NSString *title in titlesArray) {
        UIButton *item = [PublicTool initButtonWithFrame:CGRectMake(0 + itemWidth*i, 5, itemWidth, 40) text:title font:[UIFont systemFontOfSize:15] normalTextColor:self.selectedColor normalBgColor:self.unSelectedColor tag:141 + i superView:self target:self action:@selector(changeView:)];
        [self.itemsArray addObject:item];
        i++;
    }
}

-(void)changeView:(UIButton *)button
{
    //index从1开始，0的话不能比较
    if (self.selectedIndex == button.tag - 140 && self.selectedIndex) {
        return;
    }
    self.selectedIndex = button.tag - 140;
    for (UIButton *item in self.itemsArray) {
        if (item.tag == button.tag) {
            [item setTitleColor:self.unSelectedColor forState:UIControlStateNormal];
            item.backgroundColor = self.selectedColor;

        }else
        {
            [item setTitleColor:self.selectedColor forState:UIControlStateNormal];
            item.backgroundColor = self.unSelectedColor;
        }
    }
       self.changeViewBlock(button.tag - 140);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
