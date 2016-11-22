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
#import "BaseViewController.h"
#import <UIKit/UIKit.h>

#import "EMGroup.h"
typedef void (^subjectChangedblock)(NSString *subjectTitle);
@interface GroupSubjectChangingViewController : BaseViewController
@property (nonatomic, copy) subjectChangedblock block;
- (instancetype)initWithGroup:(EMGroup *)group;

@end
