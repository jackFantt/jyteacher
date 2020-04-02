//
//  JYRecommendModel.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/28.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYRecommendModel.h"

@implementation JYRecommendModel

+(NSDictionary *)replacedKeyFromPropertyName{
    
    return @{
             @"pathlink":@"path"
             };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"tags":@"RecommendtagsModel"
    };
}

@end
