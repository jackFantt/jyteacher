//
//  AXProgressHUDHelper.m
//
//  Created by Volcno on 16/7/28.
//  Copyright © 2016年 SEU. All rights reserved.
//

#import "AXProgressHUDHelper.h"
#import "MBProgressHUD.h"

@interface AXProgressHUDHelper ()
@property (nonatomic, strong) NSString      *showingCaption;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView        *parentView;
@end

@implementation AXProgressHUDHelper
static AXProgressHUDHelper* hudInstance = nil;

- (id)init
{
    self = [super init];
    if (self) {
        self.autoHideTime = 1.5;
    }
    return self;
}

#pragma mark - public method
+ (AXProgressHUDHelper*) getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hudInstance = [[AXProgressHUDHelper alloc] init];
    });
    return hudInstance;
}
// 在window上显示hud
- (void)showHudOnWindow:(NSString *)caption
                  image:(UIImage *)image
              acitivity:(BOOL)bAcitve
           autoHideTime:(NSTimeInterval)time
{
    UIView *v = [[UIApplication sharedApplication].delegate window];
    
    [self showHudOnView:v
                caption:caption
                  image:image
              acitivity:bAcitve
           autoHideTime:time];
}

// 在当前的view上显示hud
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
{
    if (!view) {
        view = [self getTopController].view;
    }
    [self showHudOnView:view
                caption:caption
                  image:image
              acitivity:bAcitve
           autoHideTime:time
               animated:YES];
}


// 在当前的view上显示hud，带动画选项
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
             animated:(BOOL)animated
{
    // 删除此view上原有的hud
    NSArray *array;
    if (view) {
        array = [MBProgressHUD allHUDsForView:view];
    } else {
        view = [self getTopController].view;
        array = [MBProgressHUD allHUDsForView:[self getTopController].view];
    }
    
    for (MBProgressHUD *obj in array) {
        [obj hide:NO];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.detailsLabelText = caption;
    
    if (!bAcitve) {
        hud.mode = MBProgressHUDModeText;
    } else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    if (image != nil) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:image];
    }
    
    if (time > 0.0f) {
        [hud hide:YES afterDelay:time];
    }
    [hud layoutSubviews];
}

- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
              doBlock:(AfterHudDisappearBlock)block
{
    // 删除此view上原有的hud
    NSArray *array;
    if (view) {
        array = [MBProgressHUD allHUDsForView:view];
    } else {
        view = [self getTopController].view;
        array = [MBProgressHUD allHUDsForView:[self getTopController].view];
    }
    
    for (MBProgressHUD *obj in array) {
        [obj hide:NO];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = caption;
    hud.completionBlock = block;
    
    if (!bAcitve) {
        hud.mode = MBProgressHUDModeText;
    } else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    if (image != nil) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:image];
    }
    
    if (time > 0.0f) {
        [hud hide:YES afterDelay:time];
    }
    [hud layoutSubviews];
}

- (void)showAutoTimeHudOnWindow:(NSString *)caption {
    [self showHudOnWindow:caption autoHideTime:self.autoHideTime];
}

- (void)showAutoTimeHudOnView:(UIView *)view
                      caption:(NSString *)caption
{
    if (!view) {
        view = [self getTopController].view;
    }
    [self showHudOnView:view caption:caption image:nil acitivity:NO autoHideTime:self.autoHideTime];
}


- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
         autoHideTime:(NSTimeInterval)autoHideTimeInterval
{
    if (!view) {
        view = [self getTopController].view;
    }
    [self showHudOnView:view caption:caption image:nil acitivity:NO autoHideTime:autoHideTimeInterval];
}

- (void)showHudOnWindow:(NSString *)caption autoHideTime:(NSTimeInterval)autoHideTimeInterval
{
    UIView *v = [[UIApplication sharedApplication].delegate window];
    
    [self showHudOnView:v caption:caption image:nil acitivity:NO autoHideTime:autoHideTimeInterval];
}

// 隐藏hud
- (void)hideHudInView:(UIView *)parentView
{
    if (!parentView) {
        parentView = [self getTopController].view;
    }
    [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
}

- (void)hideHudInView:(UIView *)parentView after:(NSTimeInterval)time
{
    NSArray *array;
    if (parentView) {
    } else {
        parentView = [self getTopController].view;
    }
    array = [MBProgressHUD allHUDsForView:parentView];
    
    for (MBProgressHUD *hud in array) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:time];
    }
}

- (void)hideHudInWindow
{
    UIView *v = [UIApplication sharedApplication].keyWindow;
    [self hideHudInView:v];
}

#pragma mark 封装
- (void)showWithStatus:(NSString *) status onView:(UIView *)view
{
    if (view) {
        [self showHudOnView:view caption: status image: nil acitivity: true autoHideTime: 0];
    } else {
        [self showHudOnView:[self getTopController].view caption: status image: nil acitivity: true autoHideTime: 0];
    }
}

- (void)showThemeLoadingOnView:(UIView *)view {
    if (view) {
        [self showHudOnView:view caption:@"正在加载" image: nil acitivity: true autoHideTime: 0];
    } else {
        [self showHudOnView:[self getTopController].view caption:@"正在加载" image:nil acitivity:true autoHideTime: 0];
    }
}

- (void)showWithStatusOnWindow:(NSString *)status
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showHudOnView: window caption: status image: nil acitivity: true autoHideTime: 0];
}

- (void)dismissOnView:(UIView *)view
{
    if (!view) {
        view = [self getTopController].view;
    }
    [self hideHudInView:view];
}

- (void)showWithStatus:(NSString *)status image:(UIImage *)image interactive:(BOOL)interactive onView:(UIView *)view{
    // 删除此view上原有的hud
    NSArray *array;
    if (view) {
        array = [MBProgressHUD allHUDsForView:view];
    } else {
        view = [self getTopController].view;
        array = [MBProgressHUD allHUDsForView:[self getTopController].view];
    }

    for (MBProgressHUD *obj in array) {
        [obj hide:NO];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = !interactive;
    hud.detailsLabelText = status;
    hud.mode = MBProgressHUDModeText;
    hud.mode = MBProgressHUDModeCustomView;
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image];
    imageView1.tintColor = [UIColor whiteColor];
    hud.customView = imageView1;
    NSTimeInterval time = [self displayDurationForString:status];
    if ([self displayDurationForString:status] < 2.0) {
        time = 2.0f;
    }
    [hud hide:YES afterDelay:time];
    [hud layoutSubviews];
}

//不可交互成功框
- (void)showSuccessWithStatus:(NSString *) status onView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:@"success.png"];
    [self showWithStatus:status image:image interactive:NO onView:view];
}

//不可交互失败框
- (void)showErrorWithStatus:(NSString*)status onView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:@"error.png"];
    [self showWithStatus:status image:image interactive:NO onView:view];
}

//可交互成功框
- (void)showInteractiveSuccessWithStatus:(NSString *)status onView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:@"success.png"];
    [self showWithStatus:status image:image interactive:YES onView:view];
}

//可交互失败框
- (void)showInteractiveErrorWithStatus:(NSString*)status onView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:@"error.png"];
    [self showWithStatus:status image:image interactive:YES onView:view];
}

//展示文字和图片
- (void)showImageTextWithStatus:(NSString *)statusStr image:(UIImage *)image onView:(UIView *)view {
    [self showWithStatus:statusStr image:image interactive:YES onView:view];
}

//直接展示文字
- (void)showTextWithStatus:(NSString *)statusStr onView:(UIView *)view {
    [self showWithStatus:statusStr image:nil interactive:YES onView:view];
}

- (void)showInfoWithStatus:(NSString*)status onView:(UIView *)view{
    [self showInfoWithStatus:status onView:view autoHideTime:[self displayDurationForString:status]];
}

- (void)showInfoWithStatus:(NSString*)status onView:(UIView *)view autoHideTime:(NSTimeInterval)time{
    // 删除此view上原有的hud
    NSArray *array;
    if (view) {
        array = [MBProgressHUD allHUDsForView:view];
    } else {
        view = [self getTopController].view;
        array = [MBProgressHUD allHUDsForView:[self getTopController].view];
    }
    
    for (MBProgressHUD *obj in array) {
        [obj hide:NO];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = status;
    
    hud.mode = MBProgressHUDModeText;
    
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *successImage = [UIImage imageNamed:@"info.png"];
    successImage = [successImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:successImage];
    [hud.customView setTintColor:[UIColor whiteColor]];
    
    [hud hide:YES afterDelay:time];
    [hud layoutSubviews];
}

- (void)showInfoOnWindowWithStatus:(NSString*)status{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showHudOnView: window caption: status image: nil acitivity: NO autoHideTime: 4.5];
}

- (NSTimeInterval)displayDurationForString:(NSString*)string{
    return MIN((float)string.length * 0.06 + 0.5, 5.0);
}

- (UIViewController *)getTopController {
    UIViewController *blockViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (blockViewController.presentedViewController) {
        blockViewController = blockViewController.presentedViewController;
    }
    
    if ([blockViewController respondsToSelector:@selector(selectedViewController)]) {
        blockViewController = [blockViewController performSelector:@selector(selectedViewController)];
    }
    
    if ([blockViewController isKindOfClass:[UINavigationController class]]) {
        blockViewController = [(UINavigationController *)blockViewController topViewController];
    }
    return blockViewController;
}
@end
