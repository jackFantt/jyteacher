//
//  JYLearn_courseModel.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/30.
//  Copyright © 2020 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYLearn_courseModel : NSObject

@property (nonatomic,copy) NSString * coureid;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * introduce;
@property (nonatomic,copy) NSString * duration;
@property (nonatomic,copy) NSString * teacher_id;
@property (nonatomic,copy) NSDictionary * teacher;
@property (nonatomic,copy) NSString * class_hours;

@end

NS_ASSUME_NONNULL_END
