//
//  CommonTool.m
//  JYEducation
//
//  Created by wofuli on 2019/11/6.
//  Copyright © 2019 smart. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool
static CommonTool *manager=nil;
+(instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[CommonTool alloc]init];
    });
    return manager;
}

-(void)requestWechatPay:(NSDictionary *)params{
    
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]){
        [[AXProgressHUDHelper getInstance]showTextWithStatus:@"未安装微信客户端" onView:YYKeyWindow];
        return;
    }
    //需要创建这个支付对象
    PayReq *req=[[PayReq alloc] init];
    
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID=kTPKWECHATeKey;
    req.openID = [params objectForKey:@"appId"];
    
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr=[params valueForKey:@"nonceStr"];
    
    // 商家id，在注册的时候给的
    req.partnerId=[params valueForKey:@"partnerid"];
    
    // 根据财付通文档填写的数据和签名，这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package = [params valueForKey:@"pkg"];
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId=[params valueForKey:@"prepayid"];
    
    // 这个签名也是后台做的
    req.sign=[params valueForKey:@"sign"];
    
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = [params valueForKey:@"timeStamp"];
    req.timeStamp=stamp.intValue;
    
    //发送请求到微信，等待微信返回onResp
//    [WXApi sendReq:req completion:^(BOOL success) {
//        NSLog(@"收到微信回复");
//    }];
    [WXApi sendReq:req];
    NSLog(@"ooo==%d",[WXApi sendReq:req]);
    
}
+(id)  localObjectForKey:(NSString*) keyStr {
    return  [[NSUserDefaults standardUserDefaults] objectForKey:keyStr];
}

+ (void) setLocalObject:(id)value forKey:(NSString*) keyStr {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:keyStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) removeObjectForKey:(NSString*) keyStr {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)  localBoolForKey:(NSString*) keyStr {
    return [[NSUserDefaults standardUserDefaults] boolForKey:keyStr];
}

+ (void) setLocalBool:(BOOL)value forKey:(NSString*) keyStr {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:keyStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) removeBoolForKey:(NSString*) keyStr {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL) isUserLogin {
    

    BOOL isUserLogin = [CommonTool localBoolForKey:kUDIUserLogin];
    NSLog(@"tool===%d",isUserLogin);
    if (!isUserLogin) {
        [CommonTool setLocalBool:isUserLogin forKey:kUDIUserLogin];
    }


    return isUserLogin;
  
    
}
+ (BOOL) isNewAddress{
     BOOL isAddress = [CommonTool localBoolForKey:kUDIsUserAddress];
    if (!isAddress) {
           [CommonTool setLocalBool:isAddress forKey:kUDIsUserAddress];
       }
       return isAddress;
}
+ (CGRect)jiSuanStrWidth:(NSString *)text withUIFont:(UIFont *)font {
    
    CGRect rect  =[text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect;
    
}
+ (BOOL)checkPrice:(NSString *)price {
    NSString *pattern = @"(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,8}(([.]\\d{0,2})?)))?";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:price];
    
    return isMatch;
    
   
    
}

+(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght

{
    
    NSString *newStr = originalStr;
    
    for (int i = 0; i < lenght; i++) {
        
        NSRange range = NSMakeRange(startLocation, 1);
        
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        
        startLocation ++;
        
    }
    
    return newStr;
    
}

/**
 *  改变行间距和字间距
 */
- (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
//json格式字符串转字典：

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

-(NSString *)getNomalTimeByTimestamp:(NSString *)timestamp{
    NSTimeInterval time=[timestamp doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
}

/**
 *  获取当天的字符串
 *  @return 格式为年-月-日 时分秒
 */
- (NSString *)getCurrentTimeyyyymmdd {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}

/**
*  改变字符串中指定字符串的大小
*  specifiedString : 原始字符串
*  characters:   需改变字符数组
*  fontSize: 大小
* specifiedLabel:需要改变的label
*/

-(void)changeTheSpecialFiedString:(NSString *)specifiedString specialCharacters:(NSArray *)characters specialFontsize:(NSInteger)fontSize speilaLabel:(UILabel*)specialLabel{
    NSString * titleString = specifiedString;
    NSMutableAttributedString * attribueStr = [[NSMutableAttributedString alloc]initWithString:titleString];
    for (NSString * str in characters) {
        NSRange range = [titleString rangeOfString:str];
        [attribueStr addAttribute:NSFontAttributeName value:[UIFont mediumWithSize:fontSize] range:range];
    }
    [specialLabel setAttributedText:attribueStr];
}

@end
