//
//  MallBaseVC.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MallBaseVC.h"
#import "MaLoginVC.h"
#import "MBProgressHUD.h"
#import "YL_PhoneCodeVC.h"

@interface MallBaseVC ()
{
    UILabel* showLabel;//黑底白字 提示文字
    UIView* m_showWindowView;//图片 window
}
// 记录push标志
@property (nonatomic, getter=isPushing) BOOL pushing;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation MallBaseVC
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.pushing == YES) {
        NSLog(@"被拦截");
        return;
    }else{
        NSLog(@"push");
        self.pushing = YES;
    }
    [super.navigationController pushViewController:viewController animated:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
//    self.tabBarController.tabBar.translucent = NO;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.pushing = NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
         if (@available(iOS 11.0,*)) {
             [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
         } else {
             // Fallback on earlier versions
         }
     
    //解决内容超出fram显示
     self.edgesForExtendedLayout = UIRectEdgeNone;  ////视图控制器，四条边不指定
     self.extendedLayoutIncludesOpaqueBars = NO;    ////不透明的操作栏<br>
     self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCheck) name:XIANGHUAUSERTOKENWRONG object:nil];
    
}
- (void)setTopViewWithTitle:(NSString*)titleStr withBackButton:(BOOL)hasBacButton viewColor:(UIColor*)viewColor{
    m_mainTopTitle = titleStr;
    m_baseTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavitionbarHeight)];
    m_baseTopView.backgroundColor = viewColor;
    [self.view addSubview:m_baseTopView];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, NavitionbarHeight-44, ScreenWidth-100, 44)];
    titleLabel.textColor = RGBA(51, 51, 51, 1.0);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = titleStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = PFBold(18);
    [m_baseTopView addSubview:titleLabel];
    
    if (hasBacButton) {
        UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, NavitionbarHeight-44, 44, 44)];
        if ([titleStr isEqualToString:@"注册账号"] || [titleStr isEqualToString:@"找回密码"]) {
         [backButton setImage:[UIImage imageNamed:@"registerback"] forState:UIControlStateNormal];
        }else{
         [backButton setImage:[UIImage imageNamed:@"backgray"] forState:UIControlStateNormal];
        }
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_baseTopView addSubview:backButton];
    }
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight-1, ScreenWidth, 1)];
    lineView.backgroundColor = HexadecimalColor(@"F8F8F8");
    [m_baseTopView addSubview:lineView];
    
}
- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setNavBarToBring
{
    [self.view bringSubviewToFront:m_baseTopView];
}
-(UIScrollView *)getscrolleViewWithFram:(CGRect)rect{
    UIScrollView * scrolleView = [[UIScrollView alloc]initWithFrame:rect];
    if (@available(iOS 11.0, *)) {
        scrolleView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return scrolleView;
}

- (BOOL)loginCheck
{
    if (![UserInfo shareInstance].isLogined) {
        YL_PhoneCodeVC *vc = [[YL_PhoneCodeVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

/**
 *  显示加载状态信息
 *
 *  @param message <#message description#>
 */
-(void)showLoading:(NSString *)message{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    
    _hud.labelText = message;
    _hud.taskInProgress = YES;
    [_hud show:YES];
}
/**
 *  隐藏加载状态信息
 */
-(void)hideLoading{
    if(_hud)
    {
        [_hud removeFromSuperview];
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
