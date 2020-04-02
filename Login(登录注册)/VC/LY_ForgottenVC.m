//
//  LY_ForgottenVC.m
//  wofubao
//
//  Created by 张小凡 on 2019/3/18.
//  Copyright © 2019 wofu. All rights reserved.
//

#import "LY_ForgottenVC.h"

@interface LY_ForgottenVC ()
{
    dispatch_source_t timer;
}
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UITextField * userName;//登录名
@property (nonatomic,strong) UIButton * codeBtn;//短信验证码按钮
@property (nonatomic,strong) UITextField * checkCode;//短信验证码
@property (nonatomic,strong) UITextField * passWord;//登录密码
@property (nonatomic,strong) UITextField * surepassWord;//确认登录密码
@property (nonatomic,strong) UIButton * findBtn;//找回密码按钮

@property(nonatomic,copy)NSString *md5Str;
@property(nonatomic,copy)NSString *deviceNo;

@end

@implementation LY_ForgottenVC


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
    [self setTopViewWithTitle:@"找回密码" withBackButton:YES viewColor:WhiteBackColor];
    [self createUI];
}
-(void)createUI{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, ScreenHeight-BottomSafebarHeight-NavitionbarHeight)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.scrollView];
    
    //手机号码
    UIView * nameView = [[UIView alloc]initWithFrame:CGRectMake(YLMARGIN_OX, 60, ScreenWidth - YLMARGIN_OX*2, 45)];
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
//    self.userName.placeholder = @"请输入手机号码";
//    [self.userName setValue:HexadecimalColor(@"#CCCCCC") forKeyPath:@"_placeholderLabel.textColor"];
//    [self.userName setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    NSAttributedString *userNameAttrString = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:
              @{NSForegroundColorAttributeName:HexadecimalColor(@"#CCCCCC"),
                           NSFontAttributeName:[UIFont systemFontOfSize:15]
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
    self.checkCode.keyboardType = UIKeyboardTypeNumberPad;
    self.checkCode.returnKeyType = UIReturnKeyDone;
//    self.checkCode.placeholder = @"请输入短信验证码";
//    [self.checkCode setValue:HexadecimalColor(@"#CCCCCC") forKeyPath:@"_placeholderLabel.textColor"];
//    [self.checkCode setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    NSAttributedString *checkCodeAttrString = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:
                 @{NSForegroundColorAttributeName:HexadecimalColor(@"#CCCCCC"),
                              NSFontAttributeName:[UIFont systemFontOfSize:15]
                      }];
    self.checkCode.attributedPlaceholder = checkCodeAttrString;
    [checkView addSubview:self.checkCode];
    
    WEAKSELF();
    UIButton * codeBtn = [UIButton wh_buttonWithTitle:@"获取验证码" backColor:nil backImageName:@"" titleColor:HexadecimalColor(@"#FF4B4B") fontSize:13 frame:CGRectMake([nameView width]-MARGIN_OX/2-80, 7.5, 80, 30) cornerRadius:15];
    codeBtn.layer.borderColor = [HexadecimalColor(@"#FF4B4B") CGColor];
    codeBtn.layer.borderWidth = 1.0f;
    [checkView addSubview:codeBtn];
    [codeBtn wh_addActionHandler:^{
        [weakSelf getPhoneCode];
    }];
    self.codeBtn = codeBtn;
    
    //新密码
    UIView * passwordView = [[UIView alloc]initWithFrame:CGRectMake(YLMARGIN_OX, getframeOY(checkView)+20, ScreenWidth - YLMARGIN_OX*2, 45)];
    passwordView.backgroundColor = [UIColor clearColor];
    
    [self.scrollView addSubview:passwordView];
    
    UIView * passwordLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [nameView width], 0.65)];
    passwordLineView.backgroundColor = HexadecimalColor(@"#CCCCCC");
    [passwordView addSubview:passwordLineView];
    self.passWord = [[UITextField alloc]initWithFrame:CGRectMake(MARGIN_OX*0.5,2.5, [passwordView width]-MARGIN_OX, 40)];
    self.passWord.secureTextEntry = YES;
    self.passWord.backgroundColor = [UIColor clearColor];
    self.passWord.font = [UIFont systemFontOfSize:15];
    self.passWord.textColor = HexadecimalColor(@"#333333");
    self.passWord.textAlignment = NSTextAlignmentLeft;
    
    self.passWord.returnKeyType = UIReturnKeyDone;
    
//    self.passWord.placeholder = @"请输入新密码";
//    [self.passWord setValue:HexadecimalColor(@"#CCCCCC") forKeyPath:@"_placeholderLabel.textColor"];
//    [self.passWord setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    NSAttributedString *passWordAttrString = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:
                 @{NSForegroundColorAttributeName:HexadecimalColor(@"#CCCCCC"),
                              NSFontAttributeName:[UIFont systemFontOfSize:15]
                      }];
    self.passWord.attributedPlaceholder = passWordAttrString;
    
    [passwordView addSubview:self.passWord];
    
    //确认登录密码
    UIView * surepasswordView = [[UIView alloc]initWithFrame:CGRectMake(YLMARGIN_OX, getframeOY(passwordView)+20, ScreenWidth - YLMARGIN_OX*2, 45)];
    surepasswordView.backgroundColor = [UIColor clearColor];
    
    [self.scrollView addSubview:surepasswordView];
    
    UIView * surepasswordLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [nameView width], 0.65)];
    surepasswordLineView.backgroundColor = HexadecimalColor(@"#CCCCCC");
    [surepasswordView addSubview:surepasswordLineView];
    self.surepassWord = [[UITextField alloc]initWithFrame:CGRectMake(MARGIN_OX*0.5,2.5, [passwordView width]-MARGIN_OX, 40)];
    self.surepassWord.secureTextEntry = YES;
    self.surepassWord.backgroundColor = [UIColor clearColor];
    self.surepassWord.font = [UIFont systemFontOfSize:15];
    self.surepassWord.textColor = HexadecimalColor(@"#333333");
    self.surepassWord.textAlignment = NSTextAlignmentLeft;
    
    self.surepassWord.returnKeyType = UIReturnKeyDone;
    
   NSAttributedString *surepassWordAttrString = [[NSAttributedString alloc] initWithString:@"请确认新密码" attributes:
                 @{NSForegroundColorAttributeName:HexadecimalColor(@"#CCCCCC"),
                              NSFontAttributeName:[UIFont systemFontOfSize:15]
                      }];
    self.surepassWord.attributedPlaceholder = surepassWordAttrString;
    
    [surepasswordView addSubview:self.surepassWord];
    
    UILabel * tishiLabel = [UILabel wh_labelWithText:@"*密码必须是字母或数字，长度为6-16位*" textFont:13 textColor:HexadecimalColor(@"#FD4A4A") frame:CGRectMake(YLMARGIN_OX, getframeOY(surepasswordView)+MARGIN_OY, [nameView width], 20)];
    tishiLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:tishiLabel];
    
    //找回密码按钮
    UIButton * findBtn  = [UIButton wh_buttonWithTitle:@"找回密码" backColor:HexadecimalColor(@"#CCCCCC") backImageName:@"" titleColor:HexadecimalColor(@"#FFFFFF") fontSize:17 frame:CGRectMake(YLMARGIN_OX, getframeOY(tishiLabel)+40, ScreenWidth-YLMARGIN_OX*2, 44) cornerRadius:4];
    [findBtn addTarget:self action:@selector(findPhoneCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:findBtn];
    self.findBtn = findBtn;
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, getframeOY(findBtn)+30);
}

#pragma mark--findPhoneCode
-(void)findPhoneCode:(UIButton *)sender{
    
    UIButton *btn=(UIButton *)sender;
    btn.enabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled=YES;
    });
    
    NSString* wrongMsg = nil;
    NSString* phone = self.userName.text;
    NSString* checkCode = self.checkCode.text;
    NSString* pwd = self.passWord.text ;
    NSString* confirmPwd = self.surepassWord.text;
    
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
        wrongMsg = @"请输入验证码";
          [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return;
        
    }else if(![checkCode checkCode]){
        wrongMsg = @"请输入正确的验证码";
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return;
        
    }else if(StringIsEmpty(pwd)){
        wrongMsg = @"请输入密码";
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return;
        
    }else if(StringIsEmpty(confirmPwd)){
        wrongMsg = @"请输入确认密码";
       [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return;
        
    }else if(![pwd isEqualToString:confirmPwd]){
        wrongMsg = @"两次密码不一致";
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return;
        
    }else if(![pwd checkPassword]){
        wrongMsg = @"密码格式不正确";
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return;
    }
    WEAKSELF();
    
    NSDictionary *  params = @{
                               @"scene":@"2",
                               @"mobile":phone,
                               @"password":pwd,
                               @"check_code":checkCode
                               };
    [AFHttpOperation postRequestWithURL:KAPIForgetPassword parameters:params viewController:self success:^(id  _Nonnull responseObject) {
        [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
               NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
               if (status == 1) {
                   
                   [[AXProgressHUDHelper getInstance]showSuccessWithStatus:responseObject[@"msg"] onView:weakSelf.view];
                   [CommonTool setLocalObject:phone forKey:kUserName];
                   [CommonTool setLocalObject:pwd forKey:kUserPassword];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       //进入登录页面
                       if (self.returnStrBlock) {
                           self.returnStrBlock(phone,pwd);
                       }
                       [weakSelf.navigationController popViewControllerAnimated:YES];
                   });
               }else{
                   [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:self.view];
               }
        
    } failure:^(NSError * _Nonnull error) {
        [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
              [[AXProgressHUDHelper getInstance]showTextWithStatus:@"网络状况不佳" onView:weakSelf.view];
        
    }];

}

#pragma mark--getPhoneCode
-(void)getPhoneCode{
    //获取注册验证码
    [self getRandomStr];
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
    
    NSString *deviceNo=self.deviceNo?self.deviceNo:@"";
    NSString *signtoken=self.md5Str?self.md5Str:@"";
    NSDictionary* params = @{@"mobile":phone,
                             @"scene":@"2",//1为注册  2为忘记密码
                             @"deviceNo":deviceNo,
                             @"signtoken":signtoken
                             };
    
    WEAKSELF();
    [AFHttpOperation postRequestWithURL:KAPISend_validate_code parameters:params viewController:self success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
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
                [self.codeBtn setTitleColor:HexadecimalColor(@"#FF4B4B") forState:UIControlStateNormal];
                
            });
        }else{
            
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
                [self.codeBtn setTitleColor:HexadecimalColor(@"#FF4B4B") forState:UIControlStateNormal];
                
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

#pragma mark -给textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    if (StringIsEmpty(textField.text)) {
        self.findBtn.backgroundColor = HexadecimalColor(@"#CCCCCC");
    }else{
        self.findBtn.backgroundColor = HexadecimalColor(@"#32C141");
    }
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
