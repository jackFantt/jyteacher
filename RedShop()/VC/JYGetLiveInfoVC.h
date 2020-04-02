//
//  JYGetLiveInfoVC.h
//  JYEducation
//
//  Created by 精英教育 on 2020/4/1.
//  Copyright © 2020 smart. All rights reserved.
//

#import "MallBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^liveClassBlock)(NSString * liveID,NSString * roomName,NSString * liveName,NSInteger livestart);

@interface JYGetLiveInfoVC : MallBaseVC

@property (nonatomic,copy) liveClassBlock liveRoomBlock;

@end

NS_ASSUME_NONNULL_END
