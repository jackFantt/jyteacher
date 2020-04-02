//
//  CommonTool.h
//  JYEducation
//
//  Created by wofuli on 2019/11/6.
//  Copyright © 2019 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTool : NSObject
+ (id)  localObjectForKey:(NSString*) keyStr;

+ (void) setLocalObject:(id)value forKey:(NSString*) keyStr;

+ (void) removeObjectForKey:(NSString*) keyStr;


+ (BOOL)  localBoolForKey:(NSString*) keyStr;

+ (void) setLocalBool:(BOOL)value forKey:(NSString*) keyStr;

+ (void) removeBoolForKey:(NSString*) keyStr;


+ (BOOL) isUserLogin;
+ (BOOL) isNewAddress;
+ (CGRect)jiSuanStrWidth:(NSString *)text withUIFont:(UIFont *)font ;
+ (BOOL)checkPrice:(NSString *)price;//检查输入的是不是金额
+(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght;
- (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;

+(instancetype)manager;

/**
 微信支付
 
 @param params 字典
 sample:
 {
 "appid": "wxb4ba3c02aa476ea1",
 "noncestr": "d1e6ecd5993ad2d06a9f50da607c971c",
 "package": "Sign=WXPay",
 "partnerid": "10000100",
 "prepayid": "wx20160218122935e3753eda1f0066087993",
 "timestamp": "1455769775",
 "sign": "F6DEE4ADD82217782919A1696500AF06"
 }
 
 */
-(void)requestWechatPay:(NSDictionary *)params;
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  根据后台返回时间戳获取时间
 *  @param timestamp   后台返回时间戳
 */

-(NSString *)getNomalTimeByTimestamp:(NSString *)timestamp;

/**
 *  获取当天的字符串
 *  @return 格式为年-月-日 时分秒
 */
- (NSString *)getCurrentTimeyyyymmdd;

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr;

/**
*  改变字符串中指定字符串的大小
*  specifiedString : 原始字符串
*  characters:   需改变字符数组
*  fontSize: 大小
* specifiedLabel:需要改变的label
*/

-(void)changeTheSpecialFiedString:(NSString *)specifiedString specialCharacters:(NSArray *)characters specialFontsize:(NSInteger)fontSize speilaLabel:(UILabel*)specialLabel;
@end

NS_ASSUME_NONNULL_END
