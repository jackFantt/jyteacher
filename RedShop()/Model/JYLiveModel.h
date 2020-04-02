//
//  JYLiveModel.h
//  JYEducation
//
//  Created by 精英教育 on 2020/4/1.
//  Copyright © 2020 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYLiveModel : NSObject

@property (nonatomic,copy) NSString * classid;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * course_id;
@property (nonatomic,assign) NSInteger start;
@end

NS_ASSUME_NONNULL_END
