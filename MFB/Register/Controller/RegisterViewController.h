//
//  RegisterViewController.h
//  MFB
//
//  Created by xinping-2 on 15/8/14.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface RegisterViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,retain) UITableView *tableView;

@end
