//
//  EMRemarkImageView.h
//  OA
//
//  Created by snowflake1993922 on 16/6/16.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMRemarkImageView : UIView
{
    UILabel *_remarkLabel;
    UIImageView *_imageView;
    
    NSInteger _index;
    BOOL _editing;
}

@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL editing;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) UIImage *image;

@end
