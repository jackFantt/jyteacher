//
//  MaLoginVC.m
//  JYEducation
//
//  Created by wofuli on 2019/11/6.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MaLoginVC.h"
#import "LY_RegisterVC.h"
#import "LY_ForgottenVC.h"
#import "YL_PhoneCodeVC.h"
#import "DCTabBarController.h"

@interface MaLoginVC ()
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UITextField * userName;//登录名
@property (nonatomic,strong) UITextField * passWord;//登录密码
@property (nonatomic,strong) UIButton * loginBtn;

@end

@implementation MaLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self createUI];
    //接受通知刷新个人界面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changmyPhoneandPasswod) name:@"ANXINBAOBEI_SelfMessage" object:nil];
    
    //接受注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changmyPhoneandPasswod) name:@"BAIQUFENQI_REGISTER" object:nil];
}
-(void)changmyPhoneandPasswod{
    if (! StringIsEmpty( [CommonTool localObjectForKey:kUserName]) && !StringIsEmpty([CommonTool localObjectForKey:kUserPassword])) {
        self.userName.text= [CommonTool localObjectForKey:kUserMobile];
        self.passWord.text=[CommonTool localObjectForKey:kUserPassword];
        self.loginBtn.backgroundColor = HexadecimalColor(@"#FF4B4B");
    }
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
            [self.navigationController popViewControllerAnimated:YES];
        
        }];
        
        UIButton * registerbtn = [UIButton wh_buttonWithTitle:@"注册" backColor:nil backImageName:@"" titleColor:HexadecimalColor(@"#333333") fontSize:18 frame:CGRectMake(ScreenWidth-MARGIN_OX-40, TopStatuHeight+20, 40, 18) cornerRadius:0];
        [self.scrollView addSubview:registerbtn];
        [registerbtn wh_addActionHandler:^{
            LY_RegisterVC * registerVC = [[LY_RegisterVC alloc]init];
            registerVC.returnStrBlock = ^(NSString *userName, NSString *passWord) {
                weakSelf.userName.text = userName;
                weakSelf.passWord.text = passWord;
                weakSelf.loginBtn.backgroundColor = HexadecimalColor(@"#FF4B4B");
            };
            [weakSelf.navigationController pushViewController:registerVC animated:YES];
        }];
        
        //账号密码登录
        UILabel * titlelabel = [UILabel wh_labelWithText:@"账号密码登录" textFont:24 textColor:HexadecimalColor(@"#1F1F1F") frame:CGRectMake(40, closebtn.bottom+80, ScreenWidth-80, 30)];
        titlelabel.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:titlelabel];
        
        //手机号
        UIView * nameView = [[UIView alloc]initWithFrame:CGRectMake(40, titlelabel.bottom+80, ScreenWidth - 40*2, 45)];
        [self.scrollView addSubview:nameView];
        UIView * nameLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [nameView width], 0.65)];
        nameLineView.backgroundColor = HexadecimalColor(@"#CCCCCC");
        [nameView addSubview:nameLineView];
        
        self.userName = [[UITextField alloc]initWithFrame:CGRectMake(MARGIN_OX*0.5,2.5, [nameView width]-MARGIN_OX, 40)];
        self.userName.backgroundColor = [UIColor clearColor];
        self.userName.font = [UIFont systemFontOfSize:15];
        self.userName.textColor = HexadecimalColor(@"#333333");
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.returnKeyType = UIReturnKeyDone;
        
        //ios13
        // 就下面这两行是重点
           NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:
           @{NSForegroundColorAttributeName:HexadecimalColor(@"#CCCCCC"),
                        NSFontAttributeName:[UIFont systemFontOfSize:15]
                }];
           self.userName.attributedPlaceholder = attrString;
       

        
        [nameView addSubview:self.userName];
        [self.userName addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        
        //登录密码
        UIView * passwordView = [[UIView alloc]initWithFrame:CGRectMake(40, getframeOY(nameView)+20, ScreenWidth - 40*2, 45)];
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
        
        NSAttributedString *passWordattrString = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:
            @{NSForegroundColorAttributeName:HexadecimalColor(@"#CCCCCC"),
                         NSFontAttributeName:[UIFont systemFontOfSize:15]
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
        UIButton * loginBtn  = [UIButton wh_buttonWithTitle:@"立即登录" backColor:HexadecimalColor(@"#CCCCCC") backImageName:@"" titleColor:HexadecimalColor(@"#FFFFFF") fontSize:17 frame:CGRectMake(40, getframeOY(passwordView)+40, ScreenWidth-80, 44) cornerRadius:0];
        
        [loginBtn addTarget:self action:@selector(loginMainVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:loginBtn];
        self.loginBtn = loginBtn;
        
         [self changmyPhoneandPasswod];
       
        
        //验证码登录
        UIButton * maBtn = [UIButton wh_buttonWithTitle:@"验证码快捷登录" backColor:nil backImageName:@"" titleColor:HexadecimalColor(@"#1F1F1F") fontSize:13 frame:CGRectMake(40, loginBtn.bottom+40, 100, 20) cornerRadius:0];
        maBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:maBtn];
        [maBtn wh_addActionHandler:^{
            YL_PhoneCodeVC * phondeVC= [[YL_PhoneCodeVC alloc]init];
            [weakSelf.navigationController pushViewController:phondeVC animated:YES];
        }];
        
        //忘记密码
        UIButton * forgotBtn = [UIButton wh_buttonWithTitle:@"忘记密码" backColor:nil backImageName:@"" titleColor:HexadecimalColor(@"#1F1F1F") fontSize:13 frame:CGRectMake(ScreenWidth-40-80, loginBtn.bottom+40, 80, 20) cornerRadius:0];
        forgotBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.scrollView addSubview:forgotBtn];
        [forgotBtn wh_addActionHandler:^{
            
            LY_ForgottenVC * forgttonVC = [[LY_ForgottenVC alloc]init];
            forgttonVC.returnStrBlock = ^(NSString *userName, NSString *passWord) {
                weakSelf.userName.text = userName;
                weakSelf.passWord.text = passWord;
            };
            [weakSelf.navigationController pushViewController:forgttonVC animated:YES];
        }];
        
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, getframeOY(forgotBtn)+50);
        
}

#pragma mark--Login
-(void)loginMainVC:(UIButton *)sender{
    
    sender.enabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled=YES;
        
    });
    WEAKSELF();
    if (![self checkData]) {
        return;
    }
    
   [[AXProgressHUDHelper getInstance]showWithStatus:@"正在登录..." onView:self.view];
    NSString* username = self.userName.text;
    NSString* password = self.passWord.text;
    
    NSDictionary* params = @{
                             @"username":username,//username,
                             @"password":password,
                             @"version_source":@"1"//IOS表示，用于存到数据库，不是必须传
                             };
    [AFHttpOperation postRequestWithURL:KAPILogin parameters:params viewController:self success:^(id  _Nonnull responseObject) {
        [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
               
              if ([responseObject[@"status"] integerValue] == 1) {
                  [[AXProgressHUDHelper getInstance]showSuccessWithStatus:@"登录成功" onView:self.view];
                      NSDictionary* dataDic = kParseData(responseObject);
                      if (![dataDic isKindOfClass:[NSDictionary class]]) {
                          return;
                      }
                      [UserInfo shareInstance].isLogined = YES;
                      [UserInfo shareInstance].userToken = KISDictionaryHaveKey(dataDic, @"token");
                      [UserInfo shareInstance].userName = KISDictionaryHaveKey(dataDic, @"nickname");
                      [UserInfo shareInstance].user_id = KISDictionaryHaveKey(dataDic, @"user_id");
                      [UserInfo shareInstance].headerImage = KISDictionaryHaveKey(dataDic, @"head_pic");
                      [UserInfo shareInstance].account = KISDictionaryHaveKey(dataDic, @"account");
                      [UserInfo shareInstance].mobile = KISDictionaryHaveKey(dataDic, @"mobile");
                      [UserInfo shareInstance].password = password;
          
//                      [CommonTool setLocalBool:[UserInfo shareInstance].isLogined forKey:kUDIsUserLogin];
                      [UserInfo saveUserName];
                  
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      //跳转到主页面
//                      DCTabBarController *maintabBarvc=[[DCTabBarController alloc]init];
//                      [UIApplication sharedApplication].delegate.window.rootViewController=maintabBarvc;
                        if (weakSelf.refrshuiBlock) {
                            weakSelf.refrshuiBlock();
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                      
              }else{
                   [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:weakSelf.view];
              }
        
    } failure:^(NSError * _Nonnull error) {
         [[AXProgressHUDHelper getInstance]showTextWithStatus:kHUDNetWorkErrorText onView:weakSelf.view];
    }];

}



//检查输入合法性
- (BOOL)checkData
{
    NSString *wrongMsg = nil;
    
    if (StringIsEmpty(self.userName.text)) {
        wrongMsg = @"用户名不能为空";
    }
    else if(StringIsEmpty(self.passWord.text)){
        wrongMsg = @"密码不能为空";
    }
    
    
    if (wrongMsg) {
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        return NO;
    }
    
    if(self.userName.text.length != 11){
    wrongMsg = @"请输入正确的手机号码";
     }
    else if(![self.passWord.text checkPassword]){
        wrongMsg = @"密码不能少于6个字符";
    }
    
    if (wrongMsg) {
        [[AXProgressHUDHelper getInstance]showTextWithStatus:wrongMsg onView:self.view];
        
        return NO;
    }
    
    return YES;
}

#pragma mark -给textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    
    if (StringIsEmpty(textField.text)) {
        self.loginBtn.backgroundColor = HexadecimalColor(@"#CCCCCC");
    }else{
         self.loginBtn.backgroundColor = HexadecimalColor(@"#32C141");
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
