//
//  JYCourseDetailsVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/27.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYCourseDetailsVC.h"
#import "ZWMSegmentController.h"
#import "JYCoureDetailVC.h"
#import "JYCourseCatalogVC.h"
#import "JYCourseEvaluationVC.h"
#import "JYClassPayMentVC.h"
#import <UShareUI/UShareUI.h>

@interface JYCourseDetailsVC ()
@property (nonatomic,strong) UIImageView * topImage;

@property (nonatomic, strong) ZWMSegmentController *segmentVC;
@property (nonatomic,strong) NSArray * toptitleArr;
@property (nonatomic,strong) UIButton * payBtn;
@property (nonatomic,strong) UIButton * shareBtn;
@end

@implementation JYCourseDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"课程详情" withBackButton:YES viewColor:WhiteBackColor];
    [self.view addSubview:self.topImage];
    [self createBottomSgmentVC];
    [self.view addSubview:self.payBtn];
       if ([WXApi isWXAppInstalled]) {
             [self.view addSubview:self.shareBtn];
        }
   
}

#pragma mark--底部滚动模块
-(void)createBottomSgmentVC{
    
    self.segmentVC = [[ZWMSegmentController alloc]initWithFrame:CGRectMake(0, self.topImage.bottom, ScreenWidth, ScreenHeight- self.topImage.bottom - BottomSafebarHeight - 50) titles:self.toptitleArr];
    self.segmentVC.segmentView.backgroundColor = WhiteTextColor;
      self.segmentVC.segmentView.showSeparateLine = YES;
    self.segmentVC.showSegmentViewLine = YES;
    self.segmentVC.segmentView.segmentNormalColor = RGBA(153, 153, 153, 1.0);
      self.segmentVC.segmentView.segmentTintColor = RGBA(218, 171, 119, 1.0);
    
    NSArray * vcArr = @[ [JYCoureDetailVC new],
                         [JYCourseCatalogVC new],
                         [JYCourseEvaluationVC new]
                       ];
      self.segmentVC.viewControllers = vcArr;
      self.segmentVC.segmentView.style = ZWMSegmentStyleDefault;
      [self addSegmentController:self.segmentVC];
      [self.segmentVC setSelectedAtIndex:0];
}

#pragma mark--click
-(void)payClassClick:(UIButton *)sender{
    JYClassPayMentVC * payvc = [[JYClassPayMentVC alloc]init];
    [self.navigationController pushViewController:payvc animated:YES];
}
-(void)shareClassClick:(UIButton *)sender{
    [self sharePlatForm];
}

-(void)sharePlatForm{
    
    WEAKSELF();
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        if(platformType ==UMSocialPlatformType_WechatSession){
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
                   
            }
        
        if(platformType ==UMSocialPlatformType_WechatTimeLine){
                  [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
                         
            }
        NSLog(@"weixin");
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);

            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark--LZ
-(UIImageView *)topImage{
    if (!_topImage) {
        _topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, 211)];
        _topImage.image = [UIImage imageNamed:@"CourseDetailstopImage"];
    }
    return _topImage;
}
-(NSArray *)toptitleArr{
    if (_toptitleArr == nil) {
        _toptitleArr = @[@"课程详情",@"课程目录",@"课程评价"];
    }
    return _toptitleArr;
}
-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton wh_buttonWithTitle:@"购买课程￥998" backColor:RGBA(218, 171, 119, 1.0) backImageName:@"" titleColor:WhiteTextColor fontSize:14 frame:CGRectMake(MARGIN_OX, ScreenHeight-BottomSafebarHeight-45, ScreenWidth-MARGIN_OX*4-44, 35) cornerRadius:17.5];
        [_payBtn addTarget:self action:@selector(payClassClick:) forControlEvents:UIControlEventTouchUpInside];
        _payBtn.titleLabel.font = [UIFont mediumWithSize:14];
    }
    return _payBtn;
}
-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton wh_buttonWithTitle:@"" backColor:nil backImageName:@"" titleColor:nil fontSize:0 frame:CGRectMake(ScreenWidth-MARGIN_OX-44, ScreenHeight-BottomSafebarHeight-50, 30, 30) cornerRadius:0];
        [_shareBtn setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
         [_shareBtn addTarget:self action:@selector(shareClassClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    UILabel * titleLabel = [UILabel wh_labelWithText:@"分享" textFont:14 textColor:RGBA(215, 181, 144, 1.0) frame:CGRectMake(_shareBtn.centerX-30, _shareBtn.bottom, 60, 18)];
    titleLabel.font = [UIFont regularWithSize:14];
    [self.view addSubview:titleLabel];
    return _shareBtn;
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
