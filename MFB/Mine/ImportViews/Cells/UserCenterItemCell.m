//
//  UserCenterItemCell.m
//  MFB
//
//  Created by 李霞 on 16/9/19.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "UserCenterItemCell.h"

@interface UserCenterItemCell ()
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *nowBuyLable;

@end
@implementation UserCenterItemCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self creatItemUI];
    }
    return self;
}

-(void)creatItemUI
{
    self.iconImageView = [PublicTool initImageViewWithFrame:CGRectMake((self.frame.size.width - 30)/2.0, 30, 30, 30) imageStr:nil superView:self tag:135];
    self.titleLable = [PublicTool initLableWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame) + 5, self.frame.size.width, 15) text:@"" textColor:colorWithHexString(@"000000") font:fontWithFontSize(17) textAlignment:NSTextAlignmentCenter superView:self tag:125];
    self.nowBuyLable = [PublicTool initLableWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLable.frame) + 10, CGRectGetWidth(self.frame), 10) text:@"立即购买>>" textColor:colorWithHexString(@"000000") font:fontWithFontSize(13) textAlignment:NSTextAlignmentRight superView:self tag:126];
    self.nowBuyLable.hidden = YES;
}

//@"IconImageStr":@"UserCenter_icon01.png",
//@"title":@"积分兑换",
//@"isShowNowbuy":@0

-(void)setContentWithDictionary:(NSDictionary *)itemDic
{
    self.iconImageView.image = [UIImage imageNamed:itemDic[@"IconImageStr"]];
    self.titleLable.text = itemDic[@"title"];
    if ([itemDic[@"isShowNowbuy"] boolValue]== YES) {
        self.nowBuyLable.hidden = NO;
    }
}
@end
