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
@property (nonatomic, strong)UIColor *selectedColor;
@property (nonatomic, strong)UIColor *unSelectedColor;
@end
@implementation TopChangeView

-(instancetype)initWithFrame:(CGRect)frame andTitlesArray:(NSArray<NSString *>*)titlesArray selectedColor:(UIColor *)selectedColor unSelectedColor:(UIColor *)unSelectedColor selectedIndex:(NSInteger)selectedIndex
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedColor = selectedColor;
        self.unSelectedColor = unSelectedColor;
        [self creatItemUIWithTitlesArray:titlesArray selectedIndex:selectedIndex];
       
    }
    return self;
}

-(void)creatItemUIWithTitlesArray:(NSArray *)titlesArray selectedIndex:(NSInteger)selectedIndex

{//self和所有item所需要的width相等
    self.itemsArray = [NSMutableArray array];
    CGFloat itemWidth = self.frame.size.width/4.0;
    int i = 0;
    for (NSString *title in titlesArray) {
                UIButton *item = [PublicTool initButtonWithFrame:CGRectMake(0 + itemWidth*i, 5, itemWidth, 40) text:title font:[UIFont systemFontOfSize:15] normalTextColor:self.selectedColor normalBgColor:self.unSelectedColor tag:141 + i superView:self target:self action:@selector(changeView:)];
        item.layer.borderWidth = 2;
        item.layer.borderColor =  self.selectedColor.CGColor;
        [self.itemsArray addObject:item];
        if (selectedIndex == i) {
            [item setTitleColor:self.unSelectedColor forState:UIControlStateNormal];
            [item setBackgroundColor:self.selectedColor];
        }

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
