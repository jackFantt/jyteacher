/**
 
 * $description: 页面控件统一处理公共类
 */

#import <Foundation/Foundation.h>

@interface SPUIViewCommon : NSObject


/**
 *  设置按钮状态
 *
 *  @param btn     btn description
 *  @param isCheck isCheck description
 */
+(void)setButtonSelectOrNo:(UIButton*)btn isCheck:(BOOL)isCheck;

/**
 *  设置按钮默认样式:  背景 , 文本颜色, 圆角
 *
 *  @param btn btn description
 */
+(void)setButtonStyle:(UIButton*)btn;

@end
