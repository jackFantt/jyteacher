//
//  JYQNLaLiuVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/31.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYQNLaLiuVC.h"
#import <PLPlayerKit/PLPlayerKit.h>

@interface JYQNLaLiuVC ()<PLPlayerDelegate>

@property (nonatomic, strong) PLPlayer  *player;

@property (nonatomic,strong) NSURL * URL;

@end

@implementation JYQNLaLiuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"直播" withBackButton:YES viewColor:WhiteBackColor];
    [self createQNLaLiUrl];
}
-(void)createQNLaLiUrl{
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    NSURL *url = [NSURL URLWithString:@"rtmp://116.213.200.53/tslsChannelLive/PCG0DuD/live"];
    self.player = [PLPlayer playerWithURL:url option:option];
    self.player.delegate = self;
    
    [self.view addSubview:self.player.playerView];
    [self.player play];
    
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, NavitionbarHeight-44, 44, 44)];
     [backButton setImage:[UIImage imageNamed:@"backgray"] forState:UIControlStateNormal];
     
     backButton.backgroundColor = [UIColor clearColor];
     [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:backButton];
    
}

-(void)backButtonClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
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
