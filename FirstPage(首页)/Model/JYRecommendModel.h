//
//  JYRecommendModel.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/28.
//  Copyright © 2020 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYRecommendModel : NSObject

@property (nonatomic,copy) NSString * introduce;
@property (nonatomic,copy) NSArray * tags;
@property (nonatomic,copy) NSString * created_at;
@property (nonatomic,copy) NSDictionary * goods;
@property (nonatomic,copy) NSString * teacher_id;
@property (nonatomic,copy) NSString * duration;
@property (nonatomic,copy) NSString * pathlink;
@property (nonatomic,copy) NSString * goods_sn;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSDictionary * teacher;


@end

NS_ASSUME_NONNULL_END
