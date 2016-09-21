//
//  MyController.m
//  MFB
//
//  Created by 翟凤禄 on 16/9/12.
//  Copyright © 2016年 xinpingTech. All rights reserved.
//

#import "MyController.h"
#import "UserCenterItemCell.h"

#define kUserCenterItemIdentifier  @"userCenterItem"
@interface MyController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *customUserCenterCollectionView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *weixinAccountLable;
@property (nonatomic, strong) UILabel *YapeIDLable;
@property (nonatomic, strong) UILabel *ageLable;
@property (nonatomic, strong) UILabel *addressLable;
@property (nonatomic, strong) UILabel *supportCountLable;
@property (nonatomic, strong) UILabel *lookCountLable;
@property (nonatomic, strong) NSArray *itemDataArr;

@end

@implementation MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户中心";
    self.view.backgroundColor =[UIColor blueColor];
    self.itemDataArr = [NSArray array];
    [self initItemDataArr];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //设置section的header的尺寸
//    flowLayout.headerReferenceSize=CGSizeMake(50, 50);
    //设置section的footer的尺寸
//    flowLayout.footerReferenceSize=CGSizeMake(10, 50);
    //每行的最小间距，默认是10（纵向滑动表示上下距离，横向滑动表示左右距离）
    flowLayout.minimumLineSpacing=2;
    //每列的最小间距，默认是10（纵向滑动表示左右距离，横向滑动表示上下距离）
    flowLayout.minimumInteritemSpacing=1;
    //设置item的大小，默认是（50，50）
    flowLayout.itemSize=CGSizeMake((currentViewWidth - 4)/3.0, 100);
    //设置滚动方向 默认是纵向的   UICollectionViewScrollDirectionHorizontal表示横向滑动
    //UICollectionViewScrollDirectionVerical 比奥斯纵向滑动
    
//    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    self.customUserCenterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, currentViewWidth, normalScreenHeight) collectionViewLayout:flowLayout];
    self.customUserCenterCollectionView.backgroundColor = [UIColor whiteColor];
    self.customUserCenterCollectionView.dataSource = self;
    self.customUserCenterCollectionView.delegate = self;
    self.customUserCenterCollectionView.contentInset = UIEdgeInsetsMake(250, 0, 0, 0);
   [self.customUserCenterCollectionView registerClass:[UserCenterItemCell class] forCellWithReuseIdentifier:kUserCenterItemIdentifier];    [self.view addSubview:self.customUserCenterCollectionView];
   UIImageView *userCenterBgImageView = [PublicTool initImageViewWithFrame:CGRectMake(0, -250, currentViewWidth, 250) imageStr:@"UserCenter_backgroundView.jpg" superView:self.customUserCenterCollectionView tag:121];

    
    UILabel *promptLable = [PublicTool initLableWithFrame:CGRectMake(0, CGRectGetHeight(userCenterBgImageView.frame) - 30, 80,15) text:@"点击上传头像" textColor:colorWithHexString(@"ffffff") font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentCenter superView:userCenterBgImageView tag:131];
    self.headImageView = [PublicTool initImageViewWithFrame:CGRectMake(0 , CGRectGetMinY(promptLable.frame) - 80, 80, 80) imageStr:@"UserCenter_headImage.jpg" superView:userCenterBgImageView tag:122];
    self.headImageView.userInteractionEnabled = YES;
    self.weixinAccountLable = [PublicTool initLableWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 10, CGRectGetMinY(self.headImageView.frame), currentViewWidth - CGRectGetMaxX(self.headImageView.frame) - 10, 25) text:@"306593892" textColor:colorWithHexString(@"ffffff") font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft superView:userCenterBgImageView tag:132];
    self.YapeIDLable = [PublicTool initLableWithFrame:CGRectMake(CGRectGetMinX(self.weixinAccountLable.frame), CGRectGetMaxY(self.weixinAccountLable.frame), CGRectGetWidth(self.weixinAccountLable.frame), 25) text:@"ID:581986" textColor:colorWithHexString(@"ffffff") font:fontWithFontSize(15) textAlignment:NSTextAlignmentLeft superView:userCenterBgImageView tag:133];
    self.ageLable = [PublicTool initLableWithFrame:CGRectMake(CGRectGetMinX(self.YapeIDLable.frame), CGRectGetMaxY(self.YapeIDLable.frame), 40, 25) text:@"25" textColor:colorWithHexString(@"ffffff") font:fontWithFontSize(15) textAlignment:NSTextAlignmentLeft superView:userCenterBgImageView tag:134];
    self.addressLable = [PublicTool initLableWithFrame:CGRectMake(CGRectGetMaxX(self.ageLable.frame), CGRectGetMinY(self.ageLable.frame), CGRectGetWidth(self.YapeIDLable.frame) - 40, 25) text:@"北京 北京" textColor:colorWithHexString(@"ffffff") font:fontWithFontSize(15) textAlignment:NSTextAlignmentLeft superView:userCenterBgImageView tag:135];
    
}

-(void)initItemDataArr
{
    self.itemDataArr = @[
                         @{
                           @"IconImageStr":@"UserCenter_icon01.png",
                           @"title":@"剩余1天",//动态可变
                           @"isShowNowbuy":@1
                          },
                         @{
                             @"IconImageStr":@"UserCenter_icon01.png",
                             @"title":@"道具商城",
                             @"isShowNowbuy":@1
                             
                          },
                         @{
                             @"IconImageStr":@"UserCenter_icon01.png",
                             @"title":@"积分兑换",
                             @"isShowNowbuy":@0
                          },
                         @{
                             @"IconImageStr":@"UserCenter_icon01.png",
                             @"title":@"修改资料",
                             @"isShowNowbuy":@0
                          },
                         @{
                             @"IconImageStr":@"UserCenter_icon01.png",
                             @"title":@"我的相册",
                             @"isShowNowbuy":@0
                          },
                         @{
                             @"IconImageStr":@"UserCenter_icon01.png",
                             @"title":@"设置中心",
                             @"isShowNowbuy":@0
                         }
                    ];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserCenterItemCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:kUserCenterItemIdentifier forIndexPath:indexPath];
    item.backgroundColor = [UIColor redColor];
    [item setContentWithDictionary:self.itemDataArr[indexPath.row]];
    return item;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
