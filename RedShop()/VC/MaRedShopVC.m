//
//  MaRedShopVC.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MaRedShopVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import "JYGetLiveInfoVC.h"
#import "JYTuiLiuVC.h"

@interface MaRedShopVC ()<UITextViewDelegate,UITextFieldDelegate>
{
    UILabel *_placeholderLabel;
    dispatch_source_t _timer;
}

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIImageView * touIcon;

@property (nonatomic,strong) UILabel * romeNumber;
@property (nonatomic,strong) UILabel * userName;

@property (nonatomic,strong) UILabel * selectedLive;//选择的直播标题

@property (nonatomic,strong) UITextView * textView;

@property (nonatomic,strong) UILabel * secondsTime;//倒计时时间

@property (nonatomic,copy) NSString * liveID;
@property (nonatomic,copy) NSString * roomName;
@property (nonatomic,copy) NSString * livestartTime;
@property (nonatomic,strong) UIButton * openButton;

@end

@implementation MaRedShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"首页" withBackButton:NO viewColor:WhiteBackColor];
    self.roomName = @"";
    self.liveID = @"";
    self.livestartTime = @"";
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:JYLoginSuccess object:nil];
    
}

-(void)loginSuccess{
     NSString * imageurl = @"http://192.168.1.3/university/api/web/uploads/teacher/1.png";//[UserInfo shareInstance].headerImage;
    [self.touIcon sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"advancetou"]];
    self.userName.text = [UserInfo shareInstance].userName;
    self.romeNumber.text = [NSString stringWithFormat:@"房间号：%@",[UserInfo shareInstance].romeName];
}
-(void)createUI{
    
    WEAKSELF();
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight)];
     self.scrollView.backgroundColor = RGBA(23, 22, 20, 1.0);
     
     [self.view addSubview:self.scrollView];
    
    self.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.scrollView.header endRefreshing];
    }];
    [self.scrollView.header beginRefreshing];
    
    UIImageView * bgImage = [[UIImageView alloc]initWithFrame:self.scrollView.frame];
    bgImage.backgroundColor = RGBA(23, 22, 20, 1.0);
    bgImage.userInteractionEnabled = YES;
    [self.scrollView addSubview:bgImage];
    
    //头像
     self.touIcon = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, NavitionbarHeight, 60, 60)];
     self.touIcon.image = [UIImage imageNamed:@"默认头像"];
     self.touIcon.userInteractionEnabled = YES;
     self.touIcon.layer.masksToBounds = YES;
     self.touIcon.layer.cornerRadius = 30.f;
  
    [bgImage addSubview:self.touIcon];
    
    NSString * teacherName = @"";
    if (StringIsEmpty([UserInfo shareInstance].userName)) {
        teacherName = @"";
    }else{
        teacherName = [UserInfo shareInstance].userName;
    }
    self.userName = [UILabel wh_labelWithText:teacherName textFont:18 textColor:WhiteTextColor frame:CGRectMake(self.touIcon.right+13, self.touIcon.mj_y+8, 150, 20)];
    self.userName.textAlignment = NSTextAlignmentLeft;
    self.userName.font = [UIFont BoldWithSize:18];
    [bgImage addSubview:self.userName];
    
    NSString * roomName = @"暂无";
    if (StringIsEmpty([UserInfo shareInstance].romeName)) {
        roomName = [NSString stringWithFormat:@"房间号：%@",roomName];
    }else{
        roomName = [NSString stringWithFormat:@"房间号：%@",[UserInfo shareInstance].romeName];
    }
    
    self.romeNumber = [UILabel wh_labelWithText:@"房间号：" textFont:14 textColor:RGBA(218, 171, 119, 1.0) frame:CGRectMake(self.touIcon.right+13, self.userName.bottom+5, 150, 20)];
    self.romeNumber.textAlignment = NSTextAlignmentLeft;
    self.romeNumber.font = [UIFont mediumWithSize:14];
    [bgImage addSubview:self.romeNumber];
    
    UIView * centerView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, bgImage.centerY-120, ScreenWidth-MARGIN_OX*2, 240)];
    centerView.backgroundColor = RGBA(39, 37, 38, 1.0);
    centerView.userInteractionEnabled = YES;
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 6.0f;
    [bgImage addSubview:centerView];
    
    UIView * centerTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [centerView width], 80)];
    centerTopView.backgroundColor = [UIColor clearColor];
    centerTopView.userInteractionEnabled = YES;
    [centerView addSubview:centerTopView];
    [centerTopView wh_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [weakSelf PushgetLiveInfoMessageVC];
    }];
    
    self.selectedLive = [UILabel wh_labelWithText:@"选择直播：这是选择后的直播标题" textFont:14 textColor:WhiteTextColor frame:CGRectMake(MARGIN_OX, 50, [centerTopView width]-MARGIN_OX*2-30, 20)];
    self.selectedLive.textAlignment = NSTextAlignmentLeft;
    self.selectedLive.font = [UIFont regularWithSize:14];
    [centerTopView addSubview:self.selectedLive];
    
    UIImageView * roowImage = [[UIImageView alloc]initWithFrame:CGRectMake([centerTopView width]-12-7, 54.5, 7, 11)];
    roowImage.image = [UIImage imageNamed:@"金色箭头"];
    [centerTopView addSubview:roowImage];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, [centerTopView width]-MARGIN_OX*2, [centerTopView height]-1, 1)];
       lineView.backgroundColor = RGBA(230, 230, 230, 1.0);
       [centerTopView addSubview:lineView];
    
    
    //textview
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake([centerView width]/2-120, centerTopView.bottom+15, 240, 70)];
           _textView.delegate = self;
    _textView.textAlignment = NSTextAlignmentCenter;
    _textView.textColor = RGBA(153, 153, 153, 1.0);
    _textView.font = [UIFont mediumWithSize:15];
    _textView.backgroundColor = [UIColor clearColor];
           
           _placeholderLabel = [UILabel wh_labelWithText:@"写个标题吸引更多的学生吧！" textFont:14 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(0, 5, [_textView width], 20)];
           _placeholderLabel.textAlignment = NSTextAlignmentCenter;
           _placeholderLabel.font = [UIFont regularWithSize:14];
           [_textView addSubview:_placeholderLabel];
    [centerView addSubview:self.textView];
    
    
    //倒计时
    self.secondsTime = [UILabel wh_labelWithText:@"暂无直播信息，请先选择直播课程" textFont:13 textColor:WhiteTextColor frame:CGRectMake(MARGIN_OX, [centerView height]-50, [centerView width]-MARGIN_OX*2, 20)];
    self.secondsTime.font = [UIFont mediumWithSize:18];
//    [self getsecondTime];
    [centerView addSubview:self.secondsTime];
    
    
    //开启直播按钮RGBA(214, 171, 126, 1.0)
    UIButton * openBtn = [UIButton wh_buttonWithTitle:@"开始直播" backColor:RGBA(39, 37, 38, 1.0) backImageName:@"" titleColor:RGBA(153, 153, 153, 1.0) fontSize:18 frame:CGRectMake(MARGIN_OX, bgImage.height-70, ScreenWidth-MARGIN_OX*2, 50) cornerRadius:25];
    openBtn.titleLabel.font = [UIFont mediumWithSize:20];
    [openBtn wh_addActionHandler:^{
        [weakSelf pushQNliveRoom];
    }];
    [bgImage addSubview:openBtn];
    openBtn.userInteractionEnabled = NO;
    self.openButton = openBtn;
}

#pragma mark--开启q直播
-(void)pushQNliveRoom{
    if (![self openLiveRoomInOneHour:self.livestartTime]) {
        self.openButton.backgroundColor = RGBA(39, 37, 38, 1.0);
        [self.openButton setTitleColor:RGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
        self.openButton.userInteractionEnabled = NO;
        return;
    }
    self.openButton.userInteractionEnabled = YES;
    JYTuiLiuVC * tuiliuVC = [[JYTuiLiuVC alloc]init];
    tuiliuVC.liveplayID = self.liveID;
    tuiliuVC.liveRoomName = self.roomName;
    tuiliuVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tuiliuVC animated:YES];
}

-(void)PushgetLiveInfoMessageVC{
    WEAKSELF();
    JYGetLiveInfoVC * liveInfoVC = [[JYGetLiveInfoVC alloc]init];
    liveInfoVC.hidesBottomBarWhenPushed = YES;

    liveInfoVC.liveRoomBlock = ^(NSString * _Nonnull liveID, NSString * _Nonnull roomName, NSString * _Nonnull liveName, NSInteger livestart) {
                weakSelf.liveID = liveID;
                weakSelf.roomName = roomName;
                weakSelf.selectedLive.text = [NSString stringWithFormat:@"选择直播：%@",liveName];
        
        if (_timer) {
              dispatch_source_cancel(_timer);
              _timer = nil;
          }
        [weakSelf getsecondTime:livestart];
        
    };
    [self.navigationController pushViewController:liveInfoVC animated:YES];
}

-(void)getsecondTime:(NSInteger)startTime{
    
    NSString * liveopenTime = [NSString stringWithFormat:@"%ld",startTime];
    // 倒计时的时间 测试数据
    NSString *deadlineStr = [[CommonTool manager] getNomalTimeByTimestamp:liveopenTime];
     self.livestartTime = deadlineStr;
       // 当前时间的时间戳
    NSString *nowStr = [[CommonTool manager] getCurrentTimeyyyymmdd];
   
//    [self openLiveRoomInOneHour:deadlineStr];
       // 计算时间差值
    NSInteger secondsCountDown = [[CommonTool manager] getDateDifferenceWithNowDateStr:nowStr deadlineStr:deadlineStr];
    
   
    [self getSecondTimeMessage:secondsCountDown isCanOpenTime:deadlineStr];
}

#pragma park--判断延期一小时内可直播
-(BOOL)openLiveRoomInOneHour:(NSString *)livetime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
       NSDate *timeDate = [dateFormatter dateFromString:livetime];
       NSDate *currentDate = [NSDate date];
       NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
      long temp = 0;
    BOOL canOpen = NO;
    NSString *result;
       if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
        canOpen = YES;
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
        canOpen = YES;
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
        canOpen = NO;
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
        canOpen = NO;
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
        canOpen = NO;
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
        canOpen = NO;
    }
    
    NSLog(@"result===%@",result);
    return canOpen;
    
}


-(void)getSecondTimeMessage:(NSInteger)secondsCountDown isCanOpenTime:(NSString *)livetime
{
    __weak __typeof(self) weakSelf = self;
     NSArray * arr = @[@"天",@"时",@"分",@"秒"];
    
    if (_timer == nil) {
        __block NSInteger timeout = secondsCountDown; // 倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                    //延误时间在1小时内可以直播
                    if ([self openLiveRoomInOneHour:livetime]) {
                        dispatch_source_cancel(_timer);
                        _timer = nil;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            weakSelf.openButton.backgroundColor = RGBA(102, 101, 99, 1.0);
                                                   [weakSelf.openButton setTitleColor:RGBA(214, 171, 126, 1.0) forState:UIControlStateNormal];
                                                   weakSelf.openButton.userInteractionEnabled = YES;
                                                   
                                                   NSString *strTime = @"00 天 00 时 00 分 00 秒";
                                                    [[CommonTool manager] changeTheSpecialFiedString:strTime specialCharacters:arr specialFontsize:12 speilaLabel:weakSelf.secondsTime];
                            
                        });
                       
                        
                    }else{
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.secondsTime.text = @"当前直播已结束";
                        weakSelf.openButton.backgroundColor = RGBA(39, 37, 38, 1.0);
                        [weakSelf.openButton setTitleColor:RGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
                        weakSelf.openButton.userInteractionEnabled = NO;
                        
                    });
                    }
                } else { // 倒计时重新计算 时/分/秒
                    NSInteger days = (int)(timeout/(3600*24));
                    NSInteger hours = (int)((timeout-days*24*3600)/3600);
                    NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                    NSString *strTime = [NSString stringWithFormat:@"00 天 %02ld 时 %02ld 分 %02ld 秒", (long)hours, (long)minute, (long)second];
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days == 0) {
//                            weakSelf.secondsTime.text = strTime;
                            [[CommonTool manager] changeTheSpecialFiedString:strTime specialCharacters:arr specialFontsize:12 speilaLabel:weakSelf.secondsTime];
                        } else {
                            NSString * dateStr = [NSString stringWithFormat:@"%ld 天 %02ld 时 %02ld 分 %02ld 秒", (long)days, (long)hours, (long)minute, (long)second];
                            [[CommonTool manager] changeTheSpecialFiedString:dateStr specialCharacters:arr specialFontsize:12 speilaLabel:weakSelf.secondsTime];
                        }
                        
                        weakSelf.openButton.backgroundColor = RGBA(102, 101, 99, 1.0);
                        [weakSelf.openButton setTitleColor:RGBA(214, 171, 126, 1.0) forState:UIControlStateNormal];
                        weakSelf.openButton.userInteractionEnabled = YES;
                        
                    });
                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                }
            });
            dispatch_resume(_timer);
        }
    }

}

#pragma mark ---textView代理方法---
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length) {
        _placeholderLabel.text = @"";
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSString * placeHodel = @"写个标题吸引更多的学生吧！";
    if (textView.text.length == 0) {
        _placeholderLabel.text = placeHodel;
        
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _placeholderLabel.text = @"";
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
