//
//  MaClassifyVC.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MaClassifyVC.h"
#import "BarrageHeader.h"
#import "UIImage+Barrage.h"
//#import "BarrageWalkImageTextSprite.h"

@interface MaClassifyVC ()<BarrageRendererDelegate>
{
     BarrageRenderer * _renderer;
    NSTimer * _timer;
    NSInteger _index;
    NSDate * _startTime;
    NSTimeInterval _predictedTime; //快进时间
}



@end

@implementation MaClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"学习" withBackButton:NO viewColor:WhiteBackColor];
    
//    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:@"http://47.110.236.110:8888/"];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketDidCloseNote object:nil];
    _index = 0;
    _predictedTime = 0.0f;
   
    [self topBarrageRender];
 
   
}
- (void)dealloc
{
    [_renderer stop];
}
#pragma 顶部弹幕
-(void)topBarrageRender{
    
    UIView * danmuView = [[UIView alloc]initWithFrame:CGRectMake(0, m_baseTopView.bottom, ScreenWidth, ScreenHeight-kTopHeight-TabbarHeight)];
    [self.view addSubview:danmuView];
    
    _renderer = [[BarrageRenderer alloc]init];
    _renderer.delegate = self;
    _renderer.redisplay = YES;
//    _renderer.view.backgroundColor = RedBackColor;
    [danmuView addSubview:_renderer.view];
    [self.view sendSubviewToBack:_renderer.view];
    
    _startTime = [NSDate date];
    [_renderer start];
    NSInteger const number = 10000;
       NSMutableArray * descriptors = [[NSMutableArray alloc]init];
       for (NSInteger i = 0; i < number; i++) {
           [descriptors addObject:[self walkTextSpriteDescriptorWithDelay:i+1]];
       }
       [_renderer load:descriptors];
    
}


#pragma mark - 弹幕描述符生产方法

/// 生成精灵描述 - 延时文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDelay:(NSTimeInterval)delay
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"延时弹幕(延时%.0f秒):%ld",delay,(long)_index++];
    descriptor.params[@"textColor"] = [UIColor blueColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(1);
    descriptor.params[@"delay"] = @(delay);
    return descriptor;
}

/// 图文混排精灵弹幕 - 过场图文弹幕A
- (BarrageDescriptor *)walkImageTextSpriteDescriptorAWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
//    descriptor.spriteName = NSStringFromClass([BarrageWalkImageTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"AA-图文混排/::B过场弹幕:%ld",(long)_index++];
    descriptor.params[@"textColor"] = [UIColor greenColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}

/// 图文混排精灵弹幕 - 过场图文弹幕B
- (BarrageDescriptor *)walkImageTextSpriteDescriptorBWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"AA-图文混排/::B过场弹幕:%ld",(long)_index++];
    descriptor.params[@"textColor"] = [UIColor greenColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    
    NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
    attachment.image = [[UIImage imageNamed:@"avatar"]barrageImageScaleToSize:CGSizeMake(25.0f, 25.0f)];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:
                                              [NSString stringWithFormat:@"BB-图文混排过场弹幕:%ld",(long)_index++]];
    [attributed insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:7];
    
    descriptor.params[@"attributedText"] = attributed;
    descriptor.params[@"textColor"] = [UIColor magentaColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}

- (void)updateMockVideoProgress
{
    NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:_startTime];
    interval += _predictedTime;
//    self.infoLabel.text = [NSString stringWithFormat:@"视频进度：%.1fs",interval];
}

#pragma mark - BarrageRendererDelegate

- (NSTimeInterval)timeForBarrageRenderer:(BarrageRenderer *)renderer
{
    [self updateMockVideoProgress]; // 仅为演示
    NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:_startTime];
    interval += _predictedTime;
    return interval;
}


- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
        
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    NSLog(@"%@",message);
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
