//
//  DCBaseSetViewController.m
//  JYEducation
//
//  Created by shuguo on 2019/11/13.
//  Copyright © 2019 smart. All rights reserved.
//

#import "DCBaseSetViewController.h"
// Controllers
#import "DCTabBarController.h"
#import "MaLoginVC.h"

@interface DCBaseSetViewController ()

@end

@implementation DCBaseSetViewController
#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setUpAcceptNote];
}
#pragma mark - 接受跟换控制
- (void)setUpAcceptNote
{
    WEAKSELF();
    [[NSNotificationCenter defaultCenter]addObserverForName:@"LOGINSELECTCENTERINDEX" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.tabBarController.selectedIndex = DCTabBarControllerMaMine; //跳转到我的界面
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (iOS_11_OR_LATER){
         if (@available(iOS 11.0, *)) {
             [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
         } else {
             // Fallback on earlier versions
         }
     }
    self.automaticallyAdjustsScrollViewInsets = NO;
    //解决内容超出fram显示
//    self.edgesForExtendedLayout = UIRectEdgeNone;  ////视图控制器，四条边不指定
//    self.extendedLayoutIncludesOpaqueBars = NO;    ////不透明的操作栏<br>
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCheck) name:XIANGHUAUSERTOKENWRONG object:nil];
}
-(void)loginCheck{
    MaLoginVC *vc = [[MaLoginVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
