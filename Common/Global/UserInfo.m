//
//  UserInfo.m
//  JYEducation
//
//  Created by wofuli on 2019/11/6.
//  Copyright © 2019 smart. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+(UserInfo *)shareInstance{
    static UserInfo * user = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        user = [[self alloc]init];
    });
    return user;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.infoDic = [NSMutableDictionary new];
        self.isLogined = NO;
        self.userToken = @"";
        self.password = @"";
        self.userName = @"";
        self.mobile = @"";
        self.romeName = @"";
        [self buildUserName];
    }
    return self;
}
//获取常用的用户信息，用户名，用户id，用户头像，用户token，登录状态，登录密码
- (void)buildUserName
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserName] != nil) {
        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserMobile] != nil) {
           self.mobile = [[NSUserDefaults standardUserDefaults] objectForKey:kUserMobile];
       }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserEdu_background] != nil) {
        self.edu_background = [[NSUserDefaults standardUserDefaults] objectForKey:kUserEdu_background];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserPassword] != nil) {
        self.password = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPassword];
    }
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserAccount] != nil) {
//        self.user_id = [[NSUserDefaults standardUserDefaults] objectForKey:kUserUserID];
//    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserUserID] != nil) {
        self.user_id = [[NSUserDefaults standardUserDefaults] objectForKey:kUserUserID];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserHead_pic] != nil) {
        self.headerImage = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead_pic];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserHead_pic] != nil) {
          self.userSex = [[NSUserDefaults standardUserDefaults] objectForKey:kUserEdu_UerSex];
      }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserEdu_UerStatus] != nil) {
          self.userStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kUserEdu_UerStatus];
      }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserRoomName] != nil) {
             self.romeName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRoomName];
         }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDUserToken] != nil) {
        self.userToken = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUserToken];
        self.isLogined = YES;
    }

}
//保存用户信息
+ (void)saveUserName
{
    //保存用户名、密码以及实名认证信息
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].userName forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].userToken forKey:kUDUserToken];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].account forKey:kUserAccount];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].password forKey:kUserPassword];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].user_id forKey:kUserUserID];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].headerImage forKey:kUserHead_pic];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].mobile forKey:kUserMobile];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].edu_background forKey:kUserEdu_background];
     [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].userSex forKey:kUserEdu_UerSex];
     [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].userStatus forKey:kUserEdu_UerStatus];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo shareInstance].romeName forKey:kUserRoomName];
    [[NSUserDefaults standardUserDefaults] setBool:[UserInfo shareInstance].isLogined forKey:kUDIUserLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//清空用户信息
- (void)cleanUserInfor
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUDUserToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.isLogined = NO;
    [[NSUserDefaults standardUserDefaults] setBool:[UserInfo shareInstance].isLogined forKey:kUDIUserLogin];
    self.userToken = @"";
    self.userName = @"";
    self.password = @"";
    self.mobile = @"";
}
-(NSMutableArray *)goods_cats{
    if (!_goods_cats) {
        _goods_cats = [NSMutableArray new];
    }
    return _goods_cats;
}
@end
