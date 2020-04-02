//
//  AFHttpOperation.h
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <Foundation/Foundation.h>
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^successBlock)(id responseObject);

typedef void (^failureBlock)(NSError * error);

typedef void (^uploadImages)(id<AFMultipartFormData>  formData);

@interface AFHttpOperation : AFHTTPSessionManager

+ (AFHttpOperation *) sharedInstance;

+ (void)getRequestWithURL:(NSString *)URLString parameters:( id)parameters viewController:(MallBaseVC*)viewController success:( successBlock)success failure:( failureBlock)failure;

+ (void)postRequestWithURL:(NSString *)URLString parameters:( id)parameters viewController:(UIViewController*)viewController success:( successBlock)success failure:( failureBlock)failure;

+ (void)postRequestWithURL:(NSString *)URLString parameters:( id)parameters uploadFiles:(uploadImages)uploadFiles success:( successBlock)success failure:( failureBlock)failure;

//新增
+ (void)postRequestWithURL:(NSString *)URLString parameters:( id)parameters  success:( successBlock)success failure:( failureBlock)failure;

#pragma mark 重新登录
+ (void)loginAgain:(MallBaseVC*)viewController;

@end

NS_ASSUME_NONNULL_END
