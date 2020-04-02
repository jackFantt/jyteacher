//
//  JYbargain_videosModel.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/28.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYbargain_videosModel.h"

@implementation JYbargain_videosModel

+(NSDictionary *)replacedKeyFromPropertyName{
    
    return @{
             @"pathlink":@"path",
             @"bargain_id":@"id"
             };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"tags":@"RecommendtagsModel"
    };
}
@end
