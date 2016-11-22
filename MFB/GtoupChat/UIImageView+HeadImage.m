/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import "UIImageView+HeadImage.h"

@implementation UIImageView (HeadImage)

- (void)imageWithUsername:(NSString *)username placeholderImage:(UIImage*)placeholderImage
{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed:@"group"];
    }
//    FMDBHandle *fmdb = [FMDBHandle sharedFMDBHandle];
//    NSArray *data = [fmdb queryUser:username];
//    if (data && data.count > 0)
//    {
//        if (IS_NOT_EMPTY(data[0][@"HeadImg"]))
//        {
//            NSString *image = data[0][@"HeadImg"];
//            [self sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"group"]];
//
//        }
//    }
//    else
//    {
//        [self sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"group"]];
//
//    }
    

}

@end

@implementation UILabel (Prase)

- (void)setTextWithUsername:(NSString *)username
{
//    FMDBHandle *fmdb = [FMDBHandle sharedFMDBHandle];
//    NSArray *data = [fmdb queryUser:username];
//    if (data && data.count > 0)
//    {
//        if (IS_NOT_EMPTY(data[0][@"Name"]))
//        {
//            [self setText:data[0][@"Name"]];
//        }
//    }
//    else
//    {
//        [self setText:username];
//
//    }
    
}

@end
