//
//  UIColor+Extension.h
//  YYSY
//
//  Created by BigCording on 16/9/18.
//  Copyright © 2016年 BigCording. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)kidGrassGreen;
+ (UIColor *)kidBlack;
+ (UIColor *)kidLightGray;
+ (UIColor *)kidShadowGray;

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(NSString *)hex;

//绘制渐变色颜色的方法
+(CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
@end
