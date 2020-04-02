//
//  JYMylearnRecordModel.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/30.
//  Copyright © 2020 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYMylearnRecordModel : NSObject

@property (nonatomic,copy) NSString * total_learn_minute;
@property (nonatomic,copy) NSString * today_learn_minute;
@property (nonatomic,copy) NSString * continue_days;
@property (nonatomic,copy) NSString * finish_course;
@property (nonatomic,strong) NSMutableArray * learn_course;

@end

NS_ASSUME_NONNULL_END
