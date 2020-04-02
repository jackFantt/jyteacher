//
//  DCTabBarController.h
//  JYEducation
//
//  Created by shuguo on 2019/11/13.
//  Copyright © 2019 smart. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSInteger ,DCTabBarControllerType){
    DCTabBarControllerMaMain = 0,  //首页
    DCTabBarControllerMaClassify = 1, //分类
    DCTabBarControllerMaRedShop = 2,  //网红小店
    DCTabBarControllerMaShopCar = 3, //购物车
    DCTabBarControllerMaMine = 4, //个人中心
};

NS_ASSUME_NONNULL_BEGIN

@interface DCTabBarController : UITabBarController
/* 控制器type */
@property (assign , nonatomic)DCTabBarControllerType tabVcType;
@end

NS_ASSUME_NONNULL_END
