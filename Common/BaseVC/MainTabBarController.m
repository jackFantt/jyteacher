//
//  MainTabBarController.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MainTabBarController.h"
#import "MaMainVC.h"
#import "MaClassifyVC.h"
#import "MaRedShopVC.h"
#import "MaShopCar.h"
#import "MaMineVC.h"
#import "JYLearnVC.h"
#import "JYPurchasedVC.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTabBar];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
}
-(void)setMyTabBar{
     //首页
     MaRedShopVC * homeVC = [[MaRedShopVC alloc]init];
     UINavigationController *homenav=[[UINavigationController alloc]initWithRootViewController:homeVC];
     homenav.tabBarItem.title=@"首页";
     homenav.navigationBar.hidden = YES;
     [homenav.tabBarItem setImage:[[UIImage imageNamed:@"shouye"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     [homenav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"shouyeselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    //分类
//      JYLearnVC *classifyVC=[[JYLearnVC alloc]init];
//      UINavigationController *Returnnav=[[UINavigationController alloc]initWithRootViewController:classifyVC];
//      Returnnav.tabBarItem.title=@"学习";
//      Returnnav.navigationBar.hidden = YES;
//      [Returnnav.tabBarItem setImage:[[UIImage imageNamed:@"classifynomal"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//      [Returnnav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"classifyselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    
//    //购物车
//    JYPurchasedVC *shopcarVC=[[JYPurchasedVC alloc]init];
//    UINavigationController *Scorucenav=[[UINavigationController alloc]initWithRootViewController:shopcarVC];
//    Scorucenav.tabBarItem.title=@"已购";
//    Scorucenav.navigationBar.hidden = YES;
//    [Scorucenav.tabBarItem setImage:[[UIImage imageNamed:@"shopcarnomal"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [Scorucenav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"shopcarselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //我的
     MaMineVC *myvc=[[MaMineVC alloc]init];
     UINavigationController *mynav=[[UINavigationController alloc]initWithRootViewController:myvc];
     mynav.tabBarItem.title=@"我的";
     mynav.navigationBar.hidden = YES;
     [mynav.tabBarItem setImage:[[UIImage imageNamed:@"wode"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     [mynav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"wodeselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

     [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBA(153, 153, 153, 1.0),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:11]} forState:UIControlStateNormal];
     [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBA(218, 171, 119, 1.0),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:11]} forState:UIControlStateSelected];
//     self.viewControllers=@[homenav,Returnnav,Scorucenav,mynav];
     self.viewControllers=@[homenav,mynav];
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
