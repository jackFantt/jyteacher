//
//  DCTabBarController.m
//  JYEducation
//
//  Created by shuguo on 2019/11/13.
//  Copyright © 2019 smart. All rights reserved.
//

#import "DCTabBarController.h"
#import "DCNavigationController.h"
#import "MaMainVC.h"
#import "MaClassifyVC.h"
#import "MaRedShopVC.h"
#import "MaShopCar.h"
#import "MaMineVC.h"

@interface DCTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) MaMainVC * mainvc;
@property (nonatomic, strong) NSMutableArray *tabBarItems;
//给item加上badge
@property (nonatomic, weak) UITabBarItem *item;
@end

@implementation DCTabBarController

#pragma mark - LazyLoad
- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        _tabBarItems = [NSMutableArray array];
    }
    
    return _tabBarItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
     
     [self addDcChildViewContorller];
     
     self.selectedViewController = [self.viewControllers objectAtIndex:DCTabBarControllerMaMain]; //默认选择商城index为1
}
#pragma mark - 添加子控制器
- (void)addDcChildViewContorller
{
    NSArray *childArray = @[
                            @{MallClassKey  : @"MaMainVC",
                              MallTitleKey  : @"精英教育",
                              MallImgKey    : @"shouye",
                              MallSelImgKey : @"shouyeselected"},
                            
                            @{MallClassKey  : @"DCHandPickViewController",
                              MallTitleKey  : @"分类",
                              MallImgKey    : @"classifynomal",
                              MallSelImgKey : @"classifyselected"},
                            
                            @{MallClassKey  : @"DCMediaListViewController",
                              MallTitleKey  : @"网红小店",
                              MallImgKey    : @"redShopnomal",
                              MallSelImgKey : @"redShopselected"},
                            
                            @{MallClassKey  : @"DCBeautyShopViewController",
                              MallTitleKey  : @"购物车",
                              MallImgKey    : @"shopcarnomal",
                              MallSelImgKey : @"shopcarselected"},
                            
                            @{MallClassKey  : @"DCMyCenterViewController",
                              MallTitleKey  : @"我的",
                              MallImgKey    : @"wode",
                              MallSelImgKey : @"wodeselected"},
                            
                            ];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dict[MallClassKey]) new];
        DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.image = [UIImage imageNamed:dict[MallImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[MallSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);//（当只有图片的时候）需要自动调整
        [self addChildViewController:nav];
        WEAKSELF();
        if ([dict[MallTitleKey] isEqualToString:@"精英教育"]) {
            weakSelf.mainvc = (MaMainVC *)vc; //给首页赋值
        }
        
        // 添加tabBarItem至数组
        [self.tabBarItems addObject:vc.tabBarItem];
    }];
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
