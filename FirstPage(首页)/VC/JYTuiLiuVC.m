//
//  JYTuiLiuVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/31.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYTuiLiuVC.h"
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>


@interface JYTuiLiuVC ()
@property (nonatomic, strong) PLMediaStreamingSession *session;

@property (nonatomic,copy) NSString * pushUrl;

@property (nonatomic,strong) UIButton * button;


@end

@implementation JYTuiLiuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setTopViewWithTitle:@"推流" withBackButton:YES viewColor:WhiteBackColor];
    self.pushUrl = @"";
    [self cretetuiliuSdk];
    [self gettuiliuSdkUrl];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.session destroy];
}


-(void)gettuiliuSdkUrl{
    
    
}
-(void)cretetuiliuSdk{
    PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
    PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    
    self.session = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:nil];
    
    [self.session setBeautifyModeOn:YES];
    [self.session setBeautify:0.8];
    [self.session setWhiten:0.8];

     [self.view addSubview:self.session.previewView];
    
    
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, NavitionbarHeight-44, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"backgray"] forState:UIControlStateNormal];
    
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"start" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 44);
    button.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 80);
    [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    
    
    UIButton *zhuanbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [zhuanbutton setTitle:@"转" forState:UIControlStateNormal];
    zhuanbutton.frame = CGRectMake(button.right+40, button.mj_y, 100, 44);
   
    [zhuanbutton addTarget:self action:@selector(actionzhuanbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhuanbutton];
    


}

-(void)backButtonClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)actionzhuanbuttonClick:(UIButton *)btn{
    [self.session toggleCamera];
}
#pragma mark --获取推流地址
-(void)getpushQNliuMessage{
    WEAKSELF();
    NSDictionary * param = @{@"live_id":self.liveplayID,
                             @"room_name":self.liveRoomName
    };
    [AFHttpOperation postRequestWithURL:KAPIJY_teacherlivestart parameters:param viewController:self success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == RESPONSE_CODE_SUCCESS) {
            NSDictionary * dataDic = kParseData(responseObject);
            if (dataDic == nil) {
                return ;
            }
            weakSelf.pushUrl = KISDictionaryHaveKey(dataDic, @"publish_url");
            [weakSelf startPushLiuMessage];
            
            
        }else{
            [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:weakSelf.view];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark--开始推流直播
-(void)startPushLiuMessage{
    
    WEAKSELF();
    
    NSURL *pushURL = [NSURL URLWithString:self.pushUrl];
    
        if (!self.session.isStreamingRunning) {
    
                weakSelf.button.enabled = NO;
                [self.session startStreamingWithPushURL:pushURL feedback:^(PLStreamStartStateFeedback feedback) {
                    NSString *log = [NSString stringWithFormat:@"session start state %lu",(unsigned long)feedback];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"%@", log);
                        weakSelf.button.enabled = YES;
                        if (PLStreamStartStateSuccess == feedback) {
                            [[AXProgressHUDHelper getInstance]showSuccessWithStatus:@"直播开始了哦!" onView:weakSelf.view];
                            [weakSelf.button setTitle:@"stop" forState:UIControlStateNormal];
                        } else {
    
                            // 重新获取有效的URL，即更换 token，播放端的地址不会变
                            [weakSelf getpushQNliuMessage];
                        }
                    });
                }];
            } else {
//                [self.session stopStreaming];
//                [weakSelf.button setTitle:@"start" forState:UIControlStateNormal];
                
                
                [weakSelf finshQNlivePlayer];
            }
    
}

#pragma mark--直播结束
-(void)finshQNlivePlayer{
    WEAKSELF();
    NSDictionary * param = @{@"live_id":self.liveplayID};
    [AFHttpOperation postRequestWithURL:KAPIJY_teacherlivefinsh parameters:param viewController:self success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == RESPONSE_CODE_SUCCESS) {
             [[AXProgressHUDHelper getInstance]showSuccessWithStatus:@"直播结束了哦!" onView:weakSelf.view];
            [weakSelf.session stopStreaming];
            [weakSelf.button setTitle:@"start" forState:UIControlStateNormal];
        }else{
             [[AXProgressHUDHelper getInstance]showSuccessWithStatus:responseObject[@"msg"] onView:weakSelf.view];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)actionButtonPressed:(UIButton *)button {
    
    
    [self getpushQNliuMessage];
//        NSURL *pushURL = [NSURL URLWithString:@"rtmp://pili-pulish.zsb100.cn/zsb100/test_uni896352?e=1585652328&token=RzKKIdX9l0xrFbO1SNN8LbbJ0hf3-q7xjiyTvdrO:1WgzsI_mF_OtMyiFNGK8eOVBMfE="];
//
//    if (!self.session.isStreamingRunning) {
//
//            button.enabled = NO;
//            [self.session startStreamingWithPushURL:pushURL feedback:^(PLStreamStartStateFeedback feedback) {
//                NSString *log = [NSString stringWithFormat:@"session start state %lu",(unsigned long)feedback];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSLog(@"%@", log);
//                    button.enabled = YES;
//                    if (PLStreamStartStateSuccess == feedback) {
//                        [button setTitle:@"stop" forState:UIControlStateNormal];
//                    } else {
//
//                        // 重新获取有效的URL，即更换 token，播放端的地址不会变
////                        [self _generateStreamURLFromServerWithURL:_streamCloudURL];
//                    }
//                });
//            }];
//        } else {
//            [self.session stopStreaming];
//            [button setTitle:@"start" forState:UIControlStateNormal];
//        }
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
