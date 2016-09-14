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
@property (nonatomic, strong)UIColor *selectedColor;
@property (nonatomic, strong)UIColor *unSelectedColor;
@property (nonatomic, strong)ChangeViewBlock changeViewBlock;
@property (nonatomic, assign)NSInteger selectedIndex;

-(instancetype)initWithFrame:(CGRect)frame andTitlesArray:(NSArray<NSString *>*)titlesArray;

@end
