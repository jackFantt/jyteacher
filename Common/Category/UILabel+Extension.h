//
//  UILabel+Extension.h
//  YYSY
//
//  Created by Dong Yu on 2017/2/16.
//  Copyright © 2017年 BigCording. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

+ (UILabel *)labelWithFrame:(CGRect)frame textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor*)textColor font:(UIFont *)font;
@end
