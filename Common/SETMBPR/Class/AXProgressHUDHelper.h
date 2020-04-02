//
//  AXProgressHUDHelper.h
//
//  Created by Volcno on 16/7/28.
//  Copyright © 2016年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ AfterHudDisappearBlock) (void);

@interface AXProgressHUDHelper : NSObject

@property (nonatomic, assign) CGFloat autoHideTime;

+ (AXProgressHUDHelper*)getInstance;

// 在window上显示hud
// 参数：
// caption:标题
// bActive：是否显示转圈动画
// time：自动消失时间，如果为0，则不自动消失

- (void)showHudOnWindow:(NSString *)caption
                  image:(UIImage *)image
              acitivity:(BOOL)bAcitve
           autoHideTime:(NSTimeInterval)time;
// 在当前的view上显示hud
// 参数：
// view：要添加hud的view
// caption:标题
// image:图片
// bActive：是否显示转圈动画
// time：自动消失时间，如果为0，则不自动消失
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time;

//有loading 状态
- (void)showWithStatus:(NSString *) status onView:(UIView *)view;
- (void)dismissOnView:(UIView *)view;

//有感叹号提示
- (void)showInfoWithStatus:(NSString*)status onView:(UIView *)view;
- (void)showWithStatusOnWindow:(NSString *)caption;
- (void)showInfoWithStatus:(NSString*)status onView:(UIView *)view autoHideTime:(NSTimeInterval)time;

- (void)showInfoOnWindowWithStatus:(NSString*)status;
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
             animated:(BOOL)animated;

- (void)showAutoTimeHudOnWindow:(NSString *)caption;

- (void)showAutoTimeHudOnView:(UIView *)view
                      caption:(NSString *)caption;

- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
         autoHideTime:(NSTimeInterval)time;

- (void)showHudOnWindow:(NSString *)caption autoHideTime:(NSTimeInterval)autoHideTimeInterval;
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
              doBlock:(AfterHudDisappearBlock)block;

// 隐藏hud
- (void)hideHudInView:(UIView *)parentView;
- (void)hideHudInView:(UIView *)parentView after:(NSTimeInterval)time;
- (void)hideHudInWindow;

/** oading状态*/
- (void)showThemeLoadingOnView:(UIView *)view;
/** 屏蔽用户交互行为，带对勾的文案*/
- (void)showSuccessWithStatus:(NSString *) statue onView:(UIView *)view;
/** 不屏蔽用户交互行为，带对勾的文案*/
- (void)showInteractiveSuccessWithStatus:(NSString *) status onView:(UIView *)view;
/** 屏蔽用户交互行为，带叉子的文案*/
- (void)showErrorWithStatus:(NSString*)status onView:(UIView *)view;
/** 不屏蔽用户交互行为，带叉子的文案*/
- (void)showInteractiveErrorWithStatus:(NSString*)status onView:(UIView *)view;
/** 展示文字和自定义图片,如果无法获取当前view，传nil也可获得当前最上层的view*/
- (void)showImageTextWithStatus:(NSString *)statusStr image:(UIImage *)image onView:(UIView *)view;
/** 展示文字,如果无法获取当前view，传nil也可获得当前最上层的view*/
- (void)showTextWithStatus:(NSString *)statusStr onView:(UIView *)view;

@end
