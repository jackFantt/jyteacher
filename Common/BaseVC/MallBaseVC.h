//
//  MallBaseVC.h
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MallBaseVC : UIViewController{
    UIView* m_baseTopView;
    UIView* m_notDataView;
    NSString* m_mainTopTitle;//页面名称 友盟统计页面访问路径
}

@property (nonatomic,strong) UITableView * basaicTableView;
/**
 防止连点
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated ;

/**
 设置导航条
 */
- (void)setTopViewWithTitle:(NSString*)titleStr withBackButton:(BOOL)hasBacButton viewColor:(UIColor*)viewColor;
/**
 *  把导航条设置在最前面
 */
- (void) setNavBarToBring;
/**
*  设置UIScrollView
*/
-(UIScrollView *)getscrolleViewWithFram:(CGRect)rect;
/**
未登录则跳登录页
 */
- (BOOL)loginCheck;
/**
 *  显示加载状态信息
 *
 *  @param message <#message description#>
 */
-(void)showLoading:(NSString *)message;
/**
 *  隐藏加载状态信息
 */
-(void)hideLoading;

@end

NS_ASSUME_NONNULL_END
