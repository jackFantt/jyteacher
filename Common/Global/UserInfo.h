//
//  UserInfo.h
//  JYEducation
//
//  Created by wofuli on 2019/11/6.
//  Copyright © 2019 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject
@property(nonatomic, assign)BOOL isLogined;//是否登录
@property(nonatomic, copy)NSString* userToken;//authtoken
@property(nonatomic, copy)NSString* userName;
@property(nonatomic, copy)NSString* password;
@property(nonatomic,copy)NSString *user_id;//id
@property(nonatomic,copy)NSString *headerImage;
@property(nonatomic,copy)NSString *account;//账号
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *edu_background;
@property(nonatomic, copy)NSString* userSex;
@property(nonatomic, copy)NSString* userStatus;
@property(nonatomic, copy)NSString* CaptchaId;//教师端q登录请求头配置
@property(nonatomic, copy)NSString* romeName;//教师端q登录请求头配置

@property (nonatomic,strong) NSMutableDictionary * infoDic;
@property(nonatomic,copy)NSString *is_sign; //判断认证

@property (nonatomic,strong) NSMutableArray * goods_cats;//首页分类数据

+ (UserInfo *)shareInstance;
+ (void)saveUserName;
- (void)cleanUserInfor;
@end

NS_ASSUME_NONNULL_END
