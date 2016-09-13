//
//  YapeCell.m
//  MFB
//
//  Created by 李霞 on 16/9/13.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "YapeCell.h"

@interface YapeCell ()
@property (nonatomic, strong)UIImageView *photoImageView;
@property (nonatomic, strong)UILabel *titleLable;
@property (nonatomic, strong)UILabel *englishTitleLable;
@end
@implementation YapeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatYapeCellUI];
    }
    return self;
}

-(void)creatYapeCellUI
{
    self.photoImageView = [PublicTool initImageViewWithFrame:CGRectMake(0, 0, currentViewWidth, normalScreenHeight/3.0) imageStr:nil superView:self tag:120];
    
#warning 没给UI,自己随便给的
    self.titleLable = [PublicTool initLableWithFrame:CGRectMake(0, (CGRectGetHeight(self.photoImageView.frame) - 55)/2.0, currentViewWidth, 30) text:@"" textColor:colorWithHexString(@"ffffff") font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentCenter superView:self tag:130];
    self.englishTitleLable = [PublicTool initLableWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLable.frame) + 5, currentViewWidth, 20) text:@"" textColor:colorWithHexString(@"ffffff") font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentCenter superView:self tag:131];

}
//@"title":@"发起邀约",
//@"englishTitle":@"Issued dating",
//@"bgImage":@"Yape_makeInvitation.jpg"

-(void)SetContentWithDictionary:(NSDictionary *)contentDic
{
    self.photoImageView.image = [UIImage imageNamed:contentDic[@"bgImage"]];
    self.titleLable.text = contentDic[@"title"];
    self.englishTitleLable.text = contentDic[@"englishTitle"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
