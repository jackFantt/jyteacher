//
//  ViewHeader.h
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#ifndef ViewHeader_h
#define ViewHeader_h

#define StringAddString(x,xx)  [NSString stringWithFormat:@"%@%@",x,xx]
#define intToStr(x) [NSString stringWithFormat:@"%d",x]
#define float1ToStr(x) [NSString stringWithFormat:@"%.1f",x]
#define float2ToStr(x) [NSString stringWithFormat:@"%.2f",x]
#define StringIsEmpty(x) (x == nil || [x isEqualToString:@""])
#define ArrayIsEmpty(x) (x == nil || [x count] == 0)
#define WEAKSELF() __weak __typeof(&*self)weakSelf = self

#define kUDIsUserLogin   @"kUDIsUserLogin"


#define kParseData(responseObject) (([[responseObject allKeys] containsObject:@"data"]) ? responseObject[@"data"] : nil)

#define KISDictionaryHaveKey(dict,key) [[dict allKeys] containsObject:key] && ([dict objectForKey:key] != (NSString*)[NSNull null]) ? [dict objectForKey:key] : @""
#define iOS_11_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

//16进制颜色宏定义
#define HexadecimalColor(HexadecimalStr) [UIColor wh_colorWithHexString:HexadecimalStr alpha:1]

#define RGBA(r,g,b,a)         [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
/**
 *  background color
 */
#define WhiteBackColor          [UIColor wh_colorWithHexString:@"FFFFFF" alpha:1]
#define GrayBackColor           [UIColor wh_colorWithHexString:@"f6f6f6" alpha:1]
#define topBarViewColor         [UIColor wh_colorWithHexString:@"4468FB" alpha:1]
#define RedBackColor            [UIColor redColor]

#define WhiteTextColor          [UIColor wh_colorWithHexString:@"FFFFFF" alpha:1]

/**
 *  获取当前主窗口
 */
#define YYKeyWindow [UIApplication sharedApplication].keyWindow

#define TopStatuHeight       [[UIApplication sharedApplication] statusBarFrame].size.height
#define TabbarHeight         ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) //
#define NavitionbarHeight    ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:64) // 适配iPhone x 导航高度
 #define BottomSafebarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0) // 适配iPhone x 导航高度
#define ScreenWidth             [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight            [[UIScreen mainScreen] bounds].size.height

/******************    TabBar          *************/
#define MallClassKey   @"rootVCClassString"
#define MallTitleKey   @"title"
#define MallImgKey     @"imageName"
#define MallSelImgKey  @"selectedImageName"

//适配屏幕
#define BNXRealValue(value) ((value)/375.0f*[UIScreen mainScreen].bounds.size.width)
#define BNYRealValue(value) ((value)/667.0f*[UIScreen mainScreen].bounds.size.height)
// ==== view fit rect = //
#define getframeOX(xx)              (xx.frame.size.width + xx.frame.origin.x)
#define getframeOY(x)               (x.frame.size.height + x.frame.origin.y)
#define Rect_Heigh(oy,y)            CGRectMake(0, oy, ScreenWidth, y)
#define cview_rect_H(oy,y)          [[UIView alloc]initWithFrame:Rect_Heigh(oy, y)];

#define MARGIN_OX_10                8
#define MARGIN_OX                   12                              //控件默认的ox
#define YLMARGIN_OX                 40                              //控件默认的ox
#define MARGIN_WIDTH                ScreenWidth - MARGIN_OX*2
#define MARGIN_OY_10                8
#define MARGIN_OY                   12                              //控件默认的oy
#define TEXT_SPACING                6                               //label默认的行距

/** 获取机型*/
#define iOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS_10_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOS_11_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

#define Is_iphoneX    UIApplication.sharedApplication.statusBarFrame.size.height >= 44
#define iPhoneSE_width 320
#define iPhone6s_width 375
#define iPhone6P_width 621
#define iPhoneX_Height 812

/**
 *  common font size
 */
#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"
#define small_fontsize    12
#define small_m_fontsize  14
#define middle_fontsize   16
#define large_fontsize    18
#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR18Font [UIFont fontWithName:PFR size:18];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];
#define PFR9Font [UIFont fontWithName:PFR size:9];
#define PFR8Font [UIFont fontWithName:PFR size:8];

#define BoldFont(fontsize) [UIFont fontWithName:@"Helvetica-Bold" size:fontsize];
#define PFRegular(fontsize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontsize];
#define PFMedium(fontsize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontsize];
#define PFBold(fontsize) [UIFont fontWithName:@"PingFangSC-Bold" size:fontsize];

#pragma --服务器接口访问返回code

//缺少token
#define RESPONSE_CODE_SUCCESS 200
//缺少token
#define RESPONSE_CODE_TOKENN_LOST -100
//token无效
#define RESPONSE_CODE_TOKENN_INALIDE -101
//token过期
#define RESPONSE_CODE_TOKENN_EXPIRE 10001

#endif /* ViewHeader_h */
