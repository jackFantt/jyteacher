//
//  JYCourseInfoModel.h
//  JYEducation
//
//  Created by 精英教育 on 2020/4/1.
//  Copyright © 2020 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYCourseInfoModel : NSObject

@property (nonatomic,copy) NSString * infoid;
@property (nonatomic,copy) NSString * teacher_id;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSArray * lives;

@end

NS_ASSUME_NONNULL_END
