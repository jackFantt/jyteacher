//
//  AppDelegate.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "DCTabBarController.h"
#import "ViewController.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMConfigure.h>
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>




@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
if (@available(iOS 13.0, *)) {

} else {
    [self.window makeKeyAndVisible];
    
    // 启动图片延时: 1秒
       [NSThread sleepForTimeInterval:1.5];
    
     IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
        keyboardManager.enable = YES; // 控制整个功能是否启用
        keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
        keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
        keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
        keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    //    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字shouldShowToolbarPlaceholder
//        keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
        keyboardManager.keyboardDistanceFromTextField = 10.0f;
    //注册友盟5e7443e4570df336760003d9
//    [UMConfigure initWithAppkey:@"5e7443e4570df336760003d9" channel:@"App Store"];
    //打开调试日志
//      [[UMSocialManager defaultManager] openLog:YES];
    //向微信注册kTPKWECHATeKey
//    [WXApi registerApp:kTPKWECHATeKey enableMTA:YES];
    // U-Share 平台设置
//    [self confitUShareSettings];
    [self configUSharePlatforms];
    //七牛云
    [PLStreamingEnv initEnv];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self setupRootViewController];
    
    
}

    return YES;
}


- (void)confitUShareSettings
{
    
//    1、微信精简版支持1.8.5（不支持Universal Links），完整版支持到1.8.6.1，支持小程序数据回传。
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
        //配置微信平台的Universal Links
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
//    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/",
//                                                        @(UMSocialPlatformType_QQ):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101830139"                                                        };
}


- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kTPKWECHATeKey appSecret:@"9f32f7bfe94be439e2acfa21a9e64926" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_WechatSession appKey:kTPKWECHATeKey appSecret:@"9f32f7bfe94be439e2acfa21a9e64926" redirectURL:@"http://mobile.umeng.com/social"];
    /*设置小程序回调app的回调*/
//        [[UMSocialManager defaultManager] setLauchFromPlatform:(UMSocialPlatformType_WechatSession) completion:^(id userInfoResponse, NSError *error) {
//        NSLog(@"setLauchFromPlatform:userInfoResponse:%@",userInfoResponse);
//    }];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
}



#pragma mark --设置根控制器-----tabBarController
- (void)setupRootViewController
{
    //跳转到主页面
   MainTabBarController *maintabBarvc = [[MainTabBarController alloc]init];
   self.window.rootViewController = maintabBarvc;
    
//       DCTabBarController *maintabBarvc = [[DCTabBarController alloc]init];
//       self.window.rootViewController = maintabBarvc;

    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
     if (!result) {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else if([url.scheme isEqualToString:kTPKWECHATeKey]&&[url.host isEqualToString:@"pay"]) {
        //跳转微信进行支付，处理支付结果
        return [WXApi handleOpenURL:url delegate:self];
        
    }
     }
    return result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
      BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
       if (!result) {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else if([url.scheme isEqualToString:kTPKWECHATeKey]&&[url.host isEqualToString:@"pay"]) {
        //跳转微信进行支付，处理支付结果
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    }
    return YES;
}
#pragma mark 跳转处理
//被废弃的方法. 但是在低版本中会用到.建议写上

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([url.host isEqualToString:kTPKWECHATeKey]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    if ([url.host isEqualToString:@"wechat"]) {
        
    }
    
    return YES;
}
#pragma makr - 微信支付回调
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *response=(SendAuthResp *)resp;
        [self getWeiXinOpenId:response.code];
    }

    //启动微信支付的response
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response=(PayResp *)resp;
        [self handleWithPayResponse:response];
    }
}
/**
 授权返回处理
 
 @param resp SendAuthResp /api/Account/LoginByWeiXin
 */
//通过code获取access_token，openid，unionid
- (void)getWeiXinOpenId:(NSString *)code{
    
    
    //    if ([self.delegate respondsToSelector:@selector(postNotification)]) {
    //        [self.delegate postNotification];
    //    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEXINLOGIN" object:code];
    
    //        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeXinAppID,WeiXinSecret,code];
    //    //
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //            NSURL *zoneUrl = [NSURL URLWithString:url];
    //            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
    //            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                if (data){
    //                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //                    NSString *openID = dic[@"openid"];
    //                    NSString *unionid = dic[@"unionid"];
    //                }
    //            });
    //        });
    
}
/**
 支付返回处理
 
 @param resp PayResp
 */
-(void)handleWithPayResponse:(PayResp *)resp{
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    //支付返回结果，实际支付结果需要去微信服务器端查询
    switch (resp.errCode) {
        case 0:{
            payResoult = @"支付成功";
//            PayResp *result=(PayResp *)resp;
            
            //                [[NSNotificationCenter defaultCenter]postNotificationName:kWECHATNOTIFYNOTICE object:nil];
        }
            break;
        case -1:{
            payResoult = @"支付失败";
            //                [MBProgressHUD showMessage:payResoult ToView:nil RemainTime:1.5];
        }
            break;
        case -2:{
            payResoult = @"取消支付";
            //                [MBProgressHUD showMessage:payResoult ToView:nil RemainTime:1.5];
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"canclePayAction" object:nil];
        }
            break;
        default:{
            payResoult = [NSString stringWithFormat:@"支付失败！\nretcode = %d,\nretstr = %@", resp.errCode,resp.errStr];
            //                [MBProgressHUD showMessage:payResoult ToView:nil RemainTime:1.5];
        }
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WECHATCOMPLECTIONMESSAGE object:@(resp.errCode)];
}
#pragma mark - UISceneSession lifecycle

//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
