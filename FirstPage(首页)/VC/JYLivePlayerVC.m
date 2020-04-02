//
//  JYLivePlayerVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/24.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYLivePlayerVC.h"

#import <ZFPlayer.h>
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFUtilities.h"
#import "UIImageView+ZFCache.h"

#import "ZWMSegmentController.h"
#import "JYInteractiveVC.h"
#import "JYIntroductionVC.h"
#import "JYVideoViewVC.h"


static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface JYLivePlayerVC (){
    NSInteger _index;
}

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) ZWMSegmentController *segmentVC;
@property (nonatomic,strong) NSArray * toptitleArr;

@end

@implementation JYLivePlayerVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"我是直播标题" withBackButton:YES viewColor:WhiteBackColor];
        _index = 0;
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.playBtn];
    [self setupAvplayer];
    [self createBottomSgmentVC];
    
    //增加监听-->监听截图事件
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleSceenShot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}



#pragma mark--底部滚动模块
-(void)createBottomSgmentVC{
    
    self.segmentVC = [[ZWMSegmentController alloc]initWithFrame:CGRectMake(0, self.containerView.bottom, ScreenWidth, ScreenHeight- self.containerView.bottom - BottomSafebarHeight) titles:self.toptitleArr];
    self.segmentVC.segmentView.backgroundColor = RGBA(211, 172, 126, 1.0);
      self.segmentVC.segmentView.showSeparateLine = YES;
      self.segmentVC.segmentView.segmentTintColor = WhiteTextColor;
    
    NSArray * vcArr = @[ [JYInteractiveVC new],
                         [JYIntroductionVC new],
                         [JYVideoViewVC new]
                       ];
      self.segmentVC.viewControllers = vcArr;
      self.segmentVC.segmentView.style = ZWMSegmentStyleDefault;
      [self addSegmentController:self.segmentVC];
      [self.segmentVC setSelectedAtIndex:0];
}

#pragma mark--播放器相关设置
-(void)setupAvplayer{
    ZFAVPlayerManager * playerManger = [[ZFAVPlayerManager alloc]init];
    //播放相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManger containerView:self.containerView];
    self.player.controlView = self.controlView;
    //设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    @weakify(self);
     self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
         @strongify(self);
         [self setNeedsStatusBarAppearanceUpdate];
     };
    
    /// 播放完成
     self.player.playerDidToEnd = ^(id  _Nonnull asset) {
         @strongify(self);
         [self.player.currentPlayerManager replay];
         [self.player playTheNext];
         if (!self.player.isLastAssetURL) {
             NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
             [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
         } else {
             [self.player stop];
         }
     };
     
     self.player.assetURLs = self.assetURLs;
    
}

- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"视频标题" coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeAutomatic];
}

#pragma mark-LZ

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}
- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        CGFloat x = 0;
        CGFloat y = m_baseTopView.height;
        CGFloat w = CGRectGetWidth(self.view.frame);
        CGFloat h = w*9/16;
        _containerView.frame = CGRectMake(x, y, w, h);
        [_containerView setImageWithURLString:kVideoCover placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat w = 44;
        CGFloat h = w;
        CGFloat x = (CGRectGetWidth(self.containerView.frame)-w)/2;
        CGFloat y = (CGRectGetHeight(self.containerView.frame)-h)/2;
           _playBtn.frame = CGRectMake(x, y, w, h);
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}


- (NSArray<NSURL *> *)assetURLs {
    if (!_assetURLs) {
            _assetURLs = @[[NSURL URLWithString:@"https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"],
          [NSURL URLWithString:@"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4"],
          [NSURL URLWithString:@"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/peter/mac-peter-tpl-cc-us-2018_1280x720h.mp4"],
          [NSURL URLWithString:@"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/grimes/mac-grimes-tpl-cc-us-2018_1280x720h.mp4"],
          [NSURL URLWithString:@"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4"],
          [NSURL URLWithString:@"http://flv3.bn.netease.com/tvmrepo/2018/6/9/R/EDJTRAD9R/SD/EDJTRAD9R-mobile.mp4"],
          [NSURL URLWithString:@"http://www.flashls.org/playlists/test_001/stream_1000k_48k_640x360.m3u8"],
          [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-video/7_517c8948b166655ad5cfb563cc7fbd8e.mp4"],
          [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/68_20df3a646ab5357464cd819ea987763a.mp4"],
          [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/118_570ed13707b2ccee1057099185b115bf.mp4"],
          [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/15_ad895ac5fb21e5e7655556abee3775f8.mp4"],
          [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/12_cc75b3fb04b8a23546d62e3f56619e85.mp4"],
          [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/5_6d3243c354755b781f6cc80f60756ee5.mp4"],
                           [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-movideo/11233547_ac127ce9e993877dce0eebceaa04d6c2_593d93a619b0.mp4"]];
    }
    return _assetURLs;
}
-(NSArray *)toptitleArr{
    if (_toptitleArr == nil) {
        _toptitleArr = @[@"互动",@"简介",@"视频"];
    }
    return _toptitleArr;
}
-(void)dealloc {
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    } else {
        // Fallback on earlier versions
    }
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
