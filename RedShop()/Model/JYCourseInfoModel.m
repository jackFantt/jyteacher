//
//  JYCourseInfoModel.m
//  JYEducation
//
//  Created by 精英教育 on 2020/4/1.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYCourseInfoModel.h"

@implementation JYCourseInfoModel

+(NSDictionary *)replacedKeyFromPropertyName{
    
    return @{
             @"infoid":@"id"
             };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"lives":@"JYLiveModel"
    };
}

@end
