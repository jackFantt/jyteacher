

#import "SPUIViewCommon.h"

#define ColorLightRed [UIColor wh_colorWithHex:0xf15353]//京东红
#define ColorSelectRed [UIColor wh_colorWithHex:0xf03f3f]//京东红:选中背景颜色

@implementation SPUIViewCommon

/**
 *  设置按钮状态
 *
 *  @param btn     btn description
 *  @param isCheck isCheck description
 */
+(void)setButtonSelectOrNo:(UIButton*)btn isCheck:(BOOL)isCheck{
   
    btn.layer.borderWidth = 0.5;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 15;
    
    if (isCheck) {
        [btn setTitleColor:ColorLightRed forState:UIControlStateNormal];
        [btn setTitleColor:ColorSelectRed forState:UIControlStateSelected];
        btn.layer.borderColor = ColorLightRed.CGColor;
    }else{
        [btn setTitleColor:HexadecimalColor(@"333333") forState:UIControlStateNormal];
        [btn setTitleColor:HexadecimalColor(@"333333") forState:UIControlStateSelected];
        btn.layer.borderColor = HexadecimalColor(@"333333").CGColor;
    }
}

/**
 *  设置按钮默认样式:  背景 , 文本颜色, 圆角
 *
 *  @param btn btn description
 */
+(void)setButtonStyle:(UIButton*)btn{
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = ColorLightRed;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 15;
    
}




@end
