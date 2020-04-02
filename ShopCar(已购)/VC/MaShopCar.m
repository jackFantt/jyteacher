//
//  MaShopCar.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MaShopCar.h"
#import <ZFPlayer.h>
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFUtilities.h"
#import "UIImageView+ZFCache.h"
#import "AppDelegate.h"

#import "BarrageHeader.h"
#import "UIImage+Barrage.h"

static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface MaShopCar ()<BarrageRendererDelegate>
{
     BarrageRenderer * _renderer;
    NSInteger _index;
}
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic,strong) UIButton * onSwitchBtn;

@end

@implementation MaShopCar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"社区" withBackButton:self.hasBack viewColor:WhiteBackColor];
     _index = 0;
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.playBtn];
    [self.view addSubview:self.changeBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.onSwitchBtn];
    [self setupAvplayer];
    
    //增加监听-->监听截图事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleSceenShot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
   // 创建网络监听者管理者对象

    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //-设置网络监听

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

    switch (status) {

    case AFNetworkReachabilityStatusUnknown:

    NSLog(@"未识别的网络");

    break;

    case AFNetworkReachabilityStatusNotReachable:

    NSLog(@"不可达的网络(未连接)");

    break;

    case AFNetworkReachabilityStatusReachableViaWWAN:

    NSLog(@"2G,3G,4G...的网络");

    break;

    case AFNetworkReachabilityStatusReachableViaWiFi:

    NSLog(@"wifi的网络");

    break;

    default:

    break;

    }

    }];

    //3.开始监听

    [manager startMonitoring];

   
   
}

#pragma mark--截屏、录屏监听事件
-(void)handleSceenShot{
    NSLog(@"进行截屏后操作");
    UIAlertController * alertVc =[UIAlertController alertControllerWithTitle:@"信息提示" message:@"为保证用户名,密码安全,请不要截屏或录屏!" preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction * knowAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
       [alertVc addAction:knowAction];
       [self presentViewController:alertVc animated:YES completion:nil];
}

//当用户录屏 怎么办 目前来说 只能进行提示。
-(void)tipsVideoRecord {
     [self.player stop];
    UIAlertController * alertVc =[UIAlertController alertControllerWithTitle:@"信息提示" message:@"尊重教育知识产权,请不要截屏或录屏!" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * knowAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    WEAKSELF();
    UIAlertAction * knowAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf exitApplication];
    }];
    [alertVc addAction:knowAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

- (void)exitApplication{
     #pragma clang diagnostic push
     #pragma clang diagnostic ignored "-Wundeclared-selector"
     //运行一个不存在的方法,退出界面更加圆滑
     [self performSelector:@selector(notExistCall)];
     abort();
     #pragma clang diagnostic pop
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
    
        _renderer = [[BarrageRenderer alloc]init];
        _renderer.delegate = self;
        _renderer.redisplay = YES;
    
}

#pragma mark - 弹幕描述符生产方法

/// 生成精灵描述 - 延时文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDelay:(NSTimeInterval)delay textMessage:(NSString *)message
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
//    descriptor.params[@"text"] = [NSString stringWithFormat:@"延时弹幕(延时%.0f秒):%ld",delay,(long)_index++];
    
    descriptor.params[@"text"] = [NSString stringWithFormat:@"我是第%.0f条弹幕:%@",delay,message];
    
    descriptor.params[@"textColor"] = [UIColor greenColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(1);
    descriptor.params[@"delay"] = @(delay);
    return descriptor;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
    
    //监测当前设备是否处于录屏状态
       UIScreen * sc = [UIScreen mainScreen];
       if (@available(iOS 11.0,*)) {
           if (sc.isCaptured) {
               NSLog(@"正在录制-----%d",sc.isCaptured);
               [self tipsVideoRecord];
           }
       }else {
          //ios 11之前处理 未知
       }
       
       //ios11之后才可以录屏
       if (@available(iOS 11.0,*)) {
         //检测设备
           [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tipsVideoRecord) name:UIScreenCapturedDidChangeNotification  object:nil];
       }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = m_baseTopView.height;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
    
    w = 100;
    h = 30;
    x = (CGRectGetWidth(self.view.frame)-w)/2;
    y = CGRectGetMaxY(self.containerView.frame)+50;
    self.changeBtn.frame = CGRectMake(x, y, w, h);
    
    w = 100;
    h = 30;
    x = (CGRectGetWidth(self.view.frame)-w)/2;
    y = CGRectGetMaxY(self.changeBtn.frame)+50;
    self.nextBtn.frame = CGRectMake(x, y, w, h);
    
    self.onSwitchBtn.frame = CGRectMake(x, self.nextBtn.bottom+30, w, h);
}

- (void)changeVideo:(UIButton *)sender {
    NSString *URLString = @"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4";
    self.player.assetURL = [NSURL URLWithString:URLString];
    [self.controlView showTitle:@"Apple" coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeAutomatic];
}

- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"视频标题" coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeAutomatic];
    [self.player.controlView addSubview:_renderer.view];
}

- (void)nextClick:(UIButton *)sender {
    if (!self.player.isLastAssetURL) {
        [self.player playTheNext];
        NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
        [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeAutomatic];
    } else {
        NSLog(@"最后一个视频了");
    }
    [_renderer stop];
    [_renderer start];
          NSInteger const number = 10000;
             NSMutableArray * descriptors = [[NSMutableArray alloc]init];
             for (NSInteger i = 0; i < number; i++) {
                 [descriptors addObject:[self walkTextSpriteDescriptorWithDelay:i+1 textMessage:@"曾今有一首歌，他是这样唱的：门前大桥下"]];
             }
             [_renderer load:descriptors];
    
    
}

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
        [_containerView setImageWithURLString:kVideoCover placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_changeBtn setTitle:@"Change video" forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(changeVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}
-(UIButton *)onSwitchBtn{
if (!_onSwitchBtn) {
    _onSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_onSwitchBtn setTitle:@"弹幕打开" forState:UIControlStateNormal];
    [_onSwitchBtn setTitle:@"关闭弹幕" forState:UIControlStateSelected];
    [_onSwitchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_onSwitchBtn addTarget:self action:@selector(danmuClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onSwitchBtn;
}
-(void)danmuClick:(UIButton*)sender{
    if (!sender.selected) {
        NSLog(@"打开弹幕");
        [_renderer start];
        NSInteger const number = 10000;
           NSMutableArray * descriptors = [[NSMutableArray alloc]init];
           for (NSInteger i = 0; i < number; i++) {
               [descriptors addObject:[self walkTextSpriteDescriptorWithDelay:i+1 textMessage:@"爸爸的爸爸叫爷爷"]];
           }
           [_renderer load:descriptors];
    }else{
        NSLog(@"关闭弹幕");
        [_renderer stop];
    }
    
    sender.selected = !sender.selected;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_nextBtn setTitle:@"Next" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
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

-(void)dealloc {
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    } else {
        // Fallback on earlier versions
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
