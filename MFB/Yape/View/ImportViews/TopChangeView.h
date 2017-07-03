//
//  TopChangeView.h
//  MFB
//
//  Created by 李霞 on 16/9/14.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeViewBlock)(NSInteger index);
@interface TopChangeView : UIView

@property (nonatomic, strong)ChangeViewBlock changeViewBlock;
@property (nonatomic, assign)NSInteger selectedIndex;

-(instancetype)initWithFrame:(CGRect)frame andTitlesArray:(NSArray<NSString *>*)titlesArray selectedColor:(UIColor *)selectedColor unSelectedColor:(UIColor *)unSelectedColor selectedIndex:(NSInteger)selectedIndex;//selectedIndex默认选择的index

@end
