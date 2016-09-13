//
//  Dock.m
//  Test
//
//  Created by user on 14-7-31.
//  Copyright (c) 2014年 user. All rights reserved.
//
#define KDockItemCount 4
#import "Dock.h"
#import "DockItem.h"

@interface Dock()
{
    DockItem *currentItem;
    DockItem *button;
    
    UIButton *_redMessage;
//    UIButton *_redMessage2;
    int _noReadCount;
    int _noReadCount2;
}
@end

@implementation Dock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addDockItemWithIcon:@"main_select1" withSelect:@"main_select" withTitle:@"Yape" withMark:1];
        [self addDockItemWithIcon:@"main_product1" withSelect:@"main_product" withTitle:@"好友" withMark:2];
        [self addDockItemWithIcon:@"main_mine1" withSelect:@"main_mine" withTitle:@"用户中心" withMark:3];
        [self addDockItemWithIcon:@"main_mine1" withSelect:@"main_mine" withTitle:@"群聊" withMark:4];
    }
    return self;
}

-(void) addDockItemWithIcon:(NSString *)icon withSelect:(NSString *)selectedIcon withTitle:(NSString *)title withMark:(int)mark
{
    // 1.创建按钮，同时调用DockItem中对图片和文本重写的方法
    button= [DockItem buttonWithType:UIButtonTypeCustom];
    button.tag = mark -1;
    // 添加到dockView中
    [self addSubview:button];
    // 2.设置边框
    //[self adjustDockItemFrame];

    int dockItemWidth = self.frame.size.width /4;
    int dockItemHeight = self.frame.size.height;
    button.frame = CGRectMake((mark-1) * dockItemWidth, 0, dockItemWidth, dockItemHeight);
    
    // 3.设置图片和文字的一般状态和高亮状态
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:colorWithHexString(@"#666666") forState:UIControlStateNormal];
    [button setTitleColor:colorWithHexString(@"#ff6666") forState:UIControlStateSelected];
    //button.titleLabel.font =[UIFont systemFontOfSize:9];
    
//    if (mark == 3) {
//        _redMessage = [UIButton buttonWithType:UIButtonTypeCustom];
//        _redMessage.userInteractionEnabled = NO;
//        [_redMessage setBackgroundImage:[UIImage imageNamed:@"message_red"] forState:UIControlStateNormal];
//        [_redMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _redMessage.titleLabel.font =[UIFont systemFontOfSize:11];
//        _redMessage.frame = CGRectMake(70, 0, 7, 7);
//        _redMessage.hidden = YES;
//        [button addSubview:_redMessage];
//        
//    }
    
}

-(void) itemClick:(DockItem *)item
{
    // 1.设置当前的选择状态为NO
    currentItem.selected = NO;
    currentItem.backgroundColor =[UIColor clearColor];
    // 2.设置刚点击的状态为选中
    item.selected = YES;
    // 3.设置按钮背景
    //item.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_slider.png"]];
    // 4.设置当前状态为选中的状态
    currentItem = item;
    // 5.通知控制器
    if (_dockItemClick) {
        _dockItemClick(item.tag);
    }
}
#pragma mark 重写设置选中索引的方法
- (void)setSelectedIndex:(int)selectedIndex
{
    // 1.条件过滤
    if (selectedIndex < 0 || selectedIndex >= self.subviews.count) return;
    
    // 2.赋值给成员变量
    _selectedIndex = selectedIndex;
    
    // 3.对应的item
    DockItem *item = self.subviews[selectedIndex];
    
    // 4.相当于点击了这个item
    [self itemClick:item];
    
    
}
-(void)adjustDockItemFrame
{
    // 1.获得dock里的所有Item数量
    int dockItemCount = self.subviews.count;
    int dockItemWidth = self.frame.size.width /dockItemCount;
    int dockItemHeight = self.frame.size.height;
    for (int i=0; i < dockItemCount; i++) {
        
        DockItem *dockItem = self.subviews[i];
        //设置边框
        dockItem.frame = CGRectMake(i * dockItemWidth, 0, dockItemWidth, dockItemHeight);
        
        //设置按钮的Tag
        dockItem.tag = i;
    }
}


@end
