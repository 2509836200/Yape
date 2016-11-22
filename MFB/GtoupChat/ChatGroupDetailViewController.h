//
//  ChatGroupDetailViewController.h
//  OA
//
//  Created by snowflake1993922 on 16/6/16.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  群组成员类型
 */
typedef enum{
    GroupOccupantTypeOwner,//创建者
    GroupOccupantTypeMember,//成员
}GroupOccupantType;

@interface ChatGroupDetailViewController : BaseViewController<EMGroupManagerDelegate, UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

- (instancetype)initWithGroup:(EMGroup *)chatGroup;

- (instancetype)initWithGroupId:(NSString *)chatGroupId;

@end
