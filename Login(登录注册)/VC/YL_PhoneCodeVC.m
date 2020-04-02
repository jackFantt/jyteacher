//
//  YL_PhoneCodeVC.m
//  wofubao
//
//  Created by 张小凡 on 2019/3/18.
//  Copyright © 2019 wofu. All rights reserved.
//

#import "YL_PhoneCodeVC.h"
#import "LY_RegisterVC.h"
#import "DCTabBarController.h"

@interface YL_PhoneCodeVC ()
{
    dispatch_source_t timer;
}
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UITextField * userName;//登录名
@property (nonatomic,strong) UIButton * codeBtn;//短信验证码按钮
@property (nonatomic,strong) UITextField * checkCode;//短信验证码
@property (nonatomic,strong) UITextField * passWord;//登录密码
@property (nonatomic,strong) UIButton * loginBtn;

@property(nonatomic,copy)NSString *md5Str;
@property(nonatomic,copy)NSString *deviceNo;

@end

@implementation YL_PhoneCodeVC

- (void)viewWillDisappear:(BOOL)animated
{
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void)createUI{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-BottomSafebarHeight)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.scrollView];
    
    //topleft
    UIButton * closebtn = [UIButton wh_buttonWithTitle:@"" backColor:nil backImageName:@"yilian_colse" titleColor:nil fontSize:0 frame:CGRectMake(MARGIN_OX, TopStatuHeight+20, 18, 18) cornerRadius:0];
    [self.scrollView addSubview:closebtn];
    WEAKSELF();
    [closebtn wh_addActionHandler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
//    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, NavitionbarHeight-44, ScreenWidth-100, 44)];
//      titleLabel.textColor = HexadecimalColor(@"333333");
//      titleLabel.backgroundColor = [UIColor clearColor];
//      titleLabel.text = @"登录";
//      titleLabel.textAlignment = NSTextAlignmentCenter;
//      titleLabel.font = BoldFont(20);
//    [self.scrollView addSubview:titleLabel];
    
    
    UILabel * jylabel = [UILabel wh_labelWithText:@"精英大学" textFont:32 textColor:RGBA(211, 172, 126, 1.0) frame:CGRectMake(MARGIN_OX, NavitionbarHeight+44, [self.scrollView width]-MARGIN_OX*2, 40)];
    jylabel.font = BoldFont(32);
    [self.scrollView addSubview:jylabel];
   
    
//    UIButton * registerbtn = [UIButton wh_buttonWithTitle:@"注册" backColor:nil backImageName:@"" titleColor:HexadecimalColor(@"#FF4B4B") fontSize:18 frame:CGRectMake(ScreenWidth-MARGIN_OX-40, TopStatuHeight+20, 40, 18) cornerRadius:0];
//    [self.scrollView addSubview:registerbtn];
//    [registerbtn wh_addActionHandler:^{
//        LY_RegisterVC * registerVC = [[LY_RegisterVC alloc]init];
//        registerVC.whiceVC = @"phoneCodeVC";
//        [weakSelf.navigationController pushViewController:registerVC animated:YES];
//    }];
//
//    //验证码快捷登录
//    UILabel * titlelabel = [UILabel wh_labelWithText:@"验证码快捷登录" textFont:24 textColor:HexadecimalColor(@"#1F1F1F") frame:CGRectMake(YLMARGIN_OX, closebtn.bottom+80, ScreenWidth-YLMARGIN_OX*2, 30)];
//    titlelabel.textAlignment = NSTextAlignmentLeft;
//    [self.scrollView addSubview:titlelabel];
    
    //手机号
    UIView * nameView = [[UIView alloc]initWithFrame:CGRectMake(YLMARGIN_OX, jylabel.bottom+88, ScreenWidth - YLMARGIN_OX*2, 45)];
    [self.scrollView addSubview:nameView];
    UIView * nameLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [nameView width], 0.65)];
    nameLineView.backgroundColor = HexadecimalColor(@"#CCCCCC");
    [nameView addSubview:nameLineView];
    
    self.userName = [[UITextField alloc]initWithFrame:CGRectMake(MARGIN_OX*0.5,2.5, [nameView width]-MARGIN_OX, 40)];
    self.userName.backgroundColor = [UIColor clearColor];
    self.userName.font = [UIFont systemFontOfSize:15];
    self.userName.textColor = HexadecimalColor(@"#333333");
    self.userName.textAlignment = NSTextAlignmentLeft;
    self.userName.keyboardType = UIKeyboardTypeNumberPad;
    self.userName.returnKeyType = UIReturnKeyDone;
    //    self.userName.delegate = self;
 
    NSAttributedString *userNameAttrString = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:
                  @{NSForegroundColorAttributeName:RGBA(179, 179, 179, 1.0),
                               NSFontAttributeName:[UIFont mediumWithSize:14]
                       }];
     self.userName.attributedPlaceholder = userNameAttrString;
    
    [nameView addSubview:self.userName];
    [self.userName addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    //短信验证码
    UIView * checkView = [[UIView alloc]initWithFrame:CGRectMake(YLMARGIN_OX, getframeOY(nameView)+20, ScreenWidth - YLMARGIN_OX*2, 45)];
    checkView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:checkView];
    UIView * checkLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [nameView width], 0.65)];
    checkLineView.backgroundColor = HexadecimalColor(@"#CCCCCC");
    [checkView addSubview:checkLineView];
    self.checkCode = [[UITextField alloc]initWithFrame:CGRectMake(MARGIN_OX*0.5,2.5, [nameView width]-YLMARGIN_OX*2-80, 40)];
    self.checkCode.backgroundColor = [UIColor clearColor];
    self.checkCode.font = [UIFont systemFontOfSize:15];
    self.checkCode.textColor = HexadecimalColor(@"#333333");
    self.checkCode.textAlignment = NSTextAlignmentLeft;
    self.checkCode.keyboardType = UIKeyboardTypeDefault;
    self.checkCode.returnKeyType = UIReturnKeyDone;

    NSAttributedString *checkCodeAttrString = [[NSAttributedString alloc] initWithString:@"获取图形验证码" attributes:
                    @{NSForegroundColorAttributeName:RGBA(179, 179, 179, 1.0),
                                 NSFontAttributeName:[UIFont mediumWithSize:14]
                         }];
    self.checkCode.attributedPlaceholder = checkCodeAttrString;
    [checkView addSubview:self.checkCode];
    UIButton * codeBtn = [UIButton wh_buttonWithTitle:@"获取图形验证码" backColor:RGBA(218, 171, 119, 1.0) backImageName:@"" titleColor:WhiteTextColor fontSize:14 frame:CGRectMake([nameView width]-MARGIN_OX/2-120, 7.5, 120, 30) cornerRadius:6];
    codeBtn.titleLabel.font = [UIFont mediumWithSize:14];
    
    [checkView addSubview:codeBtn];
    [codeBtn wh_addActionHandler:^{
        [weakSelf getPhoneCode];
    }];
    self.codeBtn = codeBtn;
    
    
    //登录密码
           UIView * passwordView = [[UIView alloc]initWithFrame:CGRectMake(40, getframeOY(checkView)+20, ScreenWidth - 40*2, 45)];
           passwordView.backgroundColor = [UIColor clearColor];
           
           [self.scrollView addSubview:passwordView];
           
           UIView * passwordLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [nameView width], 0.65)];
           passwordLineView.backgroundColor = HexadecimalColor(@"#CCCCCC");
           [passwordView addSubview:passwordLineView];
           self.passWord = [[UITextField alloc]initWithFrame:CGRectMake(MARGIN_OX*0.5,2.5, [passwordView width]-21*2-MARGIN_OX*1.5, 40)];
           self.passWord.secureTextEntry = YES;
           self.passWord.backgroundColor = [UIColor clearColor];
           self.passWord.font = [UIFont systemFontOfSize:15];
           self.passWord.textColor = HexadecimalColor(@"#333333");
           self.passWord.textAlignment = NSTextAlignmentLeft;
           
           self.passWord.returnKeyType = UIReturnKeyDone;
           
           NSAttributedString *passWordattrString = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:
               @{NSForegroundColorAttributeName:RGBA(179, 179, 179, 1.0),
                            NSFontAttributeName:[UIFont systemFontOfSize:14]
                    }];
           self.passWord.attributedPlaceholder = passWordattrString;
           [passwordView addSubview:self.passWord];
           
           [self.passWord addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
           
           UIButton *secureBtn = [UIButton wh_buttonWithTitle:@"" backColor:nil backImageName:@"yilian_noseepassword" titleColor:nil fontSize:0 frame:CGRectMake([passwordView width]-21, 12, 21, 21) cornerRadius:0];
           [passwordView addSubview:secureBtn];
           [secureBtn wh_addActionHandler:^{
               self.passWord.secureTextEntry = YES;
           }];
           
           UIButton *seeBtn = [UIButton wh_buttonWithTitle:@"" backColor:nil backImageName:@"yilian_seepassword" titleColor:nil fontSize:0 frame:CGRectMake([passwordView width]-21-MARGIN_OX-21, 12, 21, 21) cornerRadius:0];
           [passwordView addSubview:seeBtn];
           [seeBtn wh_addActionHandler:^{
               self.passWord.secureTextEntry = NO;
           }];
    
    //登录按钮
    UIButton * loginBtn  = [UIButton wh_buttonWithTitle:@"登录" backColor:RGBA(237, 238, 242, 1.0) backImageName:@"" titleColor:RGBA(153, 153, 153, 1.0) fontSize:16 frame:CGRectMake(YLMARGIN_OX, getframeOY(passwordView)+80, ScreenWidth-YLMARGIN_OX*2, 44) cornerRadius:6];
    [loginBtn addTarget:self action:@selector(checkcodeLogin:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont mediumWithSize:16];
    [self.scrollView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, loginBtn.bottom+30);
    
    
    //账号密码登录
//    UIButton * maBtn = [UIButton wh_buttonWithTitle:@"账号密码登录" backColor:nil backImageName:@"" titleColor:RGBA(153, 153, 153, 1.0) fontSize:13 frame:CGRectMake(YLMARGIN_OX, loginBtn.bottom+40, 100, 20) cornerRadius:0];
//    maBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.scrollView addSubview:maBtn];
//    [maBtn wh_addActionHandler:^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    }];
}

#pragma mark--checkcodeLogin
-(void)checkcodeLogin:(UIButton *)sender{
    UIButton *btn=(UIButton *)sender;
    btn.enabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled=YES;
    });
    
    NSString* wrongMsg = nil;
    NSString* phone = self.userName.text;
    NSString* checkCode = self.checkCode.text;
     NSString* password = self.passWord.text;
    
    if (StringIsEmpty(phone)) {
        wrongMsg = @"请输入手机号码";
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        
        return;
    }else if (phone.length!=11){
        wrongMsg = @"手机号不正确";
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return;
    }
    
    if (StringIsEmpty(checkCode)) {
        wrongMsg = @"请输入图形验证码";
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return;
        
    }
    
    if (StringIsEmpty(password)) {
        wrongMsg = @"请输入密码";
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return;
        
    }
  
    
    NSDictionary * params = @{
                              @"mobile":phone,
                              @"captcha":checkCode,
                              @"password":password
                              };
    WEAKSELF();
     [[AXProgressHUDHelper getInstance]showWithStatus:@"正在登录..." onView:self.view];
    [AFHttpOperation postRequestWithURL:KAPILogin_teacher parameters:params viewController:self success:^(id  _Nonnull responseObject) {
        [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
               if ([responseObject[@"code"] integerValue] == 200) {
                   [[AXProgressHUDHelper getInstance]showSuccessWithStatus:@"登录成功" onView:self.view];
                   NSDictionary* dataDic = kParseData(responseObject);
                   if (![dataDic isKindOfClass:[NSDictionary class]]) {
                       return;
                   }
                   [UserInfo shareInstance].isLogined = YES;
                   
                   [UserInfo shareInstance].userToken = KISDictionaryHaveKey(dataDic, @"token");
                   
                   [CommonTool setLocalBool:[UserInfo shareInstance].isLogined forKey:kUDIsUserLogin];
                   [UserInfo saveUserName];
                   
                   
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       
//                       if (@available(iOS 13.0, *)) {
//
//                       } else {
//
//                       }
                       if (weakSelf.refrshuiBlock) {
                           weakSelf.refrshuiBlock();
                       }
                       [weakSelf.navigationController popViewControllerAnimated:YES];
                   });
                   
                   
               }else{
                   [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:weakSelf.view];
               }
        
    } failure:^(NSError * _Nonnull error) {
        [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
              [[AXProgressHUDHelper getInstance]showTextWithStatus:kHUDNetWorkErrorText onView:self.view];

    }];
}

#pragma mark -给textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    
    NSLog(@"值是---%@",textField.text);
    if (StringIsEmpty(textField.text)) {
        self.loginBtn.backgroundColor = RGBA(237, 238, 242, 1.0);
         [self.loginBtn setTitleColor:RGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
    }else{
        self.loginBtn.backgroundColor = RGBA(218, 171, 119, 1.0);
        [self.loginBtn setTitleColor:WhiteTextColor forState:UIControlStateNormal];
    }
}

#pragma mark--getPhoneCode
-(void)getPhoneCode{
//    [self getRandomStr];
//    [self sendYzm];//发送验证码
    [self getphoneImageData];
}

#pragma mark--获取图形验证码
-(void)getphoneImageData{
    WEAKSELF();
    NSDictionary * param = @{};
    [AFHttpOperation postRequestWithURL:KAPISend_validate_captcha parameters:param viewController:self success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            [[AXProgressHUDHelper getInstance]showSuccessWithStatus:responseObject[@"message"] onView:weakSelf.view];
            NSDictionary * dataDic = kParseData(responseObject);
            if (dataDic == nil) {
                return ;
            }
            NSString * base64Str = KISDictionaryHaveKey(dataDic, @"captcha");
            NSString * phpStr = @"data:image/png;base64,";
            NSString * newbase64Str = [base64Str substringFromIndex:[phpStr length]];
            
            NSData *decodedImgData = [[NSData alloc] initWithBase64EncodedString:newbase64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:decodedImgData];
            // 图片数据
            
//            [weakSelf.codeBtn setImage:decodedImage forState:UIControlStateNormal];
            [weakSelf.codeBtn setBackgroundImage:decodedImage forState:UIControlStateNormal];
            [weakSelf.codeBtn setTitle:@"" forState:UIControlStateNormal];
            

        }else{
            [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:weakSelf.view];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark--获取验证码随机字符串后发送验证码
-(void)getRandomStr{
    NSString *deviceNo=[UIDevice currentDevice].identifierForVendor.UUIDString;//（设备号）
    self.deviceNo=deviceNo;
    
    NSDictionary *paramas=@{
                            @"deviceNo":deviceNo?deviceNo:@""
                            };
    
    [AFHttpOperation postRequestWithURL:KAPIGetRand parameters:paramas viewController:self success:^(id  _Nonnull responseObject) {
        if(responseObject && [[responseObject allKeys] containsObject:@"result"]){
                   NSDictionary *result=responseObject[@"result"];
                   if(result && [[result allKeys] containsObject:@"autokey"]){
                       NSString *autokey=result[@"autokey"];
                       NSString *endStr=[@"farm" stringByAppendingString:autokey];
                       NSString *MD5Str=[endStr toMD5];
                       self.md5Str=MD5Str;
                       [self sendYzm];//发送验证码
                   }
               }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];

}

/**
 *  发送验证码
 */
- (void)sendYzm{
    NSString* phone = [self.userName text];
    if (StringIsEmpty(phone)) {
        [[AXProgressHUDHelper getInstance]showTextWithStatus:@"请输入手机号码!" onView:self.view];
        return;
    }
    if(phone.length!=11){
        
        [[AXProgressHUDHelper getInstance]showTextWithStatus:@"手机号码有误!" onView:self.view];
        
        return;
    }
    
   
    NSDictionary* params = @{@"mobile":phone,
                             };
    
    WEAKSELF();
    [AFHttpOperation postRequestWithURL:KAPISend_validate_code parameters:params viewController:self success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
                   [weakSelf leftTime];
                   [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:self.view];
               }else{
                   [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:self.view];
               }
        
    } failure:^(NSError * _Nonnull error) {
        [[AXProgressHUDHelper getInstance]showTextWithStatus:kHUDNetWorkErrorText onView:self.view];
        
    }];
   
    
}

//倒计时
- (void)leftTime
{
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
    __block int timeout = 59;
    dispatch_queue_t que  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, que);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
            timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
                [self.codeBtn setTitleColor:WhiteTextColor forState:UIControlStateNormal];
                
            });
        }else{
            
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
                [self.codeBtn setTitleColor:WhiteTextColor forState:UIControlStateNormal];
                
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
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
