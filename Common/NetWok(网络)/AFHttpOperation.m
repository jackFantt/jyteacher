//
//  AFHttpOperation.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "AFHttpOperation.h"

@implementation AFHttpOperation
+ (instancetype)sharedInstance {
    static AFHttpOperation *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        shareInstance = [[AFHttpOperation alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURL] sessionConfiguration:configuration];

        shareInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        shareInstance.securityPolicy = [AFSecurityPolicy defaultPolicy];
        shareInstance.securityPolicy.allowInvalidCertificates = YES;
        shareInstance.securityPolicy.validatesDomainName = NO;

         shareInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"multipart/form-data",@"application/x-www-form-urlencoded",nil];

        [shareInstance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [shareInstance.requestSerializer setValue:@"charset=UTF-8"forHTTPHeaderField:@"Content-Type"];

        shareInstance.requestSerializer.timeoutInterval = 10;
    });
    
    return shareInstance;
}

/**
 *  Get方法发起的Http请求
 *
 *  @param URLString  相对请求路径
 *  @param parameters 参数
 *  @param success    成功后的Block
 *  @param failure    失败后的Block
 */
+ (void)getRequestWithURL:(NSString *)URLString parameters:( id)parameters viewController:(MallBaseVC*)viewController success:( successBlock)success failure:( failureBlock)failure {
    
       NSMutableDictionary *finalPars = [NSMutableDictionary dictionaryWithCapacity:7];
        [AFHttpOperation  sharedInstance].requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *token =  [CommonTool  localObjectForKey:kUDUserToken]; //token
           
           if(!StringIsEmpty(token)) {
    //           [finalPars setObject:token forKey:@"token"];
               NSString * Authorization = [NSString stringWithFormat:@"Bearer %@",token];
               [[AFHttpOperation  sharedInstance].requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
               
               if (parameters != nil) {
                   [finalPars addEntriesFromDictionary:parameters];
               }
           }else{
               if (parameters != nil) {
                   [finalPars addEntriesFromDictionary:parameters];
               }
           }
       [[AFHttpOperation sharedInstance]POST:URLString parameters:finalPars progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if ([[responseObject allKeys]containsObject:@"status"]) {//返回状态码
               NSInteger status = [[responseObject objectForKey:@"code"] integerValue];
               if (success) {
                   //登录账户失效
                   if (status == RESPONSE_CODE_TOKENN_LOST || status == RESPONSE_CODE_TOKENN_INALIDE || status == RESPONSE_CODE_TOKENN_EXPIRE) {
                       if (viewController !=nil) {
                            [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:viewController.view];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [AFHttpOperation loginAgain:viewController];
                                                          
                            });
                       }
                   }else{
                        success(responseObject);
                   }
               }
           }
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           if (failure) {
                [[AXProgressHUDHelper getInstance]dismissOnView:YYKeyWindow];
               failure(error);
               NSLog(@"%@",error);
           }
       }];
      
}

/**
 *  Post方法发起的Http请求
 *
 *  @param URLString  相对请求路径
 *  @param parameters 参数
 *  @param success    成功后的Block
 *  @param failure    失败后的Block
 */
+ (void)postRequestWithURL:(NSString *)URLString parameters:( id)parameters viewController:(UIViewController*)viewController success:( successBlock)success failure:( failureBlock)failure{
    NSMutableDictionary *finalPars = [NSMutableDictionary dictionaryWithCapacity:7];
    [AFHttpOperation  sharedInstance].requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *token =  [CommonTool  localObjectForKey:kUDUserToken]; //token
       
       if(!StringIsEmpty(token)) {
//           [finalPars setObject:token forKey:@"token"];
           NSString * Authorization = [NSString stringWithFormat:@"Bearer %@",token];
           [[AFHttpOperation  sharedInstance].requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
           
           if (parameters != nil) {
               [finalPars addEntriesFromDictionary:parameters];
           }
       }else{
           if (parameters != nil) {
               [finalPars addEntriesFromDictionary:parameters];
           }
       }
    
    if ([URLString isEqualToString:KAPILogin_teacher]) {
        [[AFHttpOperation  sharedInstance].requestSerializer setValue:[UserInfo shareInstance].CaptchaId forHTTPHeaderField:@"Captcha-Id"];
    }
    
    
    [[AFHttpOperation sharedInstance]POST:URLString parameters:finalPars progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        
        if ([URLString isEqualToString:KAPISend_validate_captcha]) {
            [UserInfo shareInstance].CaptchaId = KISDictionaryHaveKey(allHeaders, @"Captcha-Id");
        }
        
        if ([[responseObject allKeys]containsObject:@"code"]) {//返回状态码
            if (success) {
              
                    NSError *error;
                     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                   
                     success(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
                         
                failure(error);
                   
                }
        if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
               NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
               NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
                   NSLog(@"%@",str);
            NSDictionary * dic = [[CommonTool manager] dictionaryWithJsonString:str];
             NSLog(@"%@",dic);
            
            if ([KISDictionaryHaveKey(dic, @"code") integerValue] == RESPONSE_CODE_TOKENN_EXPIRE) {
                //token失效
                
                [[AXProgressHUDHelper getInstance]showTextWithStatus:dic[@"message"] onView:viewController.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[UserInfo shareInstance] cleanUserInfor];
                        MallBaseVC * vc = (MallBaseVC *)viewController;
                        [AFHttpOperation loginAgain:vc];
                                              
                });
                
            }else{
                 [[AXProgressHUDHelper getInstance]showTextWithStatus:dic[@"message"] onView:viewController.view];
                
            }
               }
        
    }];
    
}

+ (void)postRequestWithURL:(NSString *)URLString parameters:( id)parameters uploadFiles:(uploadImages)uploadFiles success:( successBlock)success failure:( failureBlock)failure{
    
       NSMutableDictionary *finalPars = [NSMutableDictionary dictionaryWithCapacity:7];
        [AFHttpOperation  sharedInstance].requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *token =  [CommonTool  localObjectForKey:kUDUserToken]; //token
           
           if(!StringIsEmpty(token)) {
    //           [finalPars setObject:token forKey:@"token"];
               NSString * Authorization = [NSString stringWithFormat:@"Bearer %@",token];
               [[AFHttpOperation  sharedInstance].requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
               
               if (parameters != nil) {
                   [finalPars addEntriesFromDictionary:parameters];
               }
           }else{
               if (parameters != nil) {
                   [finalPars addEntriesFromDictionary:parameters];
               }
           }
    
    [[AFHttpOperation sharedInstance] POST:URLString parameters:finalPars constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        uploadFiles(formData);
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject ) {
        if (success) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
                                
                       failure(error);
                          
                       }
               if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
                      NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
                      NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
                          NSLog(@"%@",str);
                   NSDictionary * dic = [[CommonTool manager] dictionaryWithJsonString:str];
                    NSLog(@"%@",dic);
                   
                   if ([KISDictionaryHaveKey(dic, @"code") integerValue] == RESPONSE_CODE_TOKENN_EXPIRE) {
                       //token失效
                       
//                       [[AXProgressHUDHelper getInstance]showTextWithStatus:dic[@"message"] onView:viewController.view];
//                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                               [[UserInfo shareInstance] cleanUserInfor];
//                               MallBaseVC * vc = (MallBaseVC *)viewController;
//                               [AFHttpOperation loginAgain:vc];
//                                                     
//                       });
                       
                   }else{
//                        [[AXProgressHUDHelper getInstance]showTextWithStatus:dic[@"message"] onView:viewController.view];
                       
                   }
                      }
    }];

    
}

#pragma mark 重新登录
+ (void)loginAgain:(MallBaseVC*)viewController
{
    [[UserInfo shareInstance] cleanUserInfor];
    [viewController loginCheck];
}

+ (void)postRequestWithURL:(NSString *)URLString parameters:( id)parameters  success:( successBlock)success failure:( failureBlock)failure{
       NSMutableDictionary *finalPars = [NSMutableDictionary dictionaryWithCapacity:7];
        [AFHttpOperation  sharedInstance].requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *token =  [CommonTool  localObjectForKey:kUDUserToken]; //token
           
           if(!StringIsEmpty(token)) {
    //           [finalPars setObject:token forKey:@"token"];
               NSString * Authorization = [NSString stringWithFormat:@"Bearer %@",token];
               [[AFHttpOperation  sharedInstance].requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
               
               if (parameters != nil) {
                   [finalPars addEntriesFromDictionary:parameters];
               }
           }else{
               if (parameters != nil) {
                   [finalPars addEntriesFromDictionary:parameters];
               }
           }
      [[AFHttpOperation sharedInstance]POST:URLString parameters:finalPars progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if ([[responseObject allKeys]containsObject:@"code"]) {//返回状态码
              if (success) {
                  NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                success(responseObject);
              }
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (failure) {
               [[AXProgressHUDHelper getInstance]dismissOnView:YYKeyWindow];
              failure(error);
              NSLog(@"uuuuu%@",error);
          }
      }];
}

@end
