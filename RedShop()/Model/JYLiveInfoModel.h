//
//  JYLiveInfoModel.h
//  JYEducation
//
//  Created by 精英教育 on 2020/4/1.
//  Copyright © 2020 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYLiveInfoModel : NSObject

@property (nonatomic,copy) NSString * created_at;
@property (nonatomic,copy) NSString * roomid;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * play_url;
@property (nonatomic,copy) NSString * publish_url;
@property (nonatomic,copy) NSString * show_id;
@property (nonatomic,copy) NSString * classid;
@property (nonatomic,copy) NSString * snapshot_url;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * teacher_id;
@property (nonatomic,copy) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END
