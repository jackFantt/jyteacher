//
//  MaLunBoModel.h
//  JYEducation
//
//  Created by shuguo on 2019/11/18.
//  Copyright © 2019 smart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaLunBoModel : NSObject
@property(nonatomic,copy)NSString *location;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *client;
@property(nonatomic,copy)NSString *ad_id;
@property(nonatomic,copy)NSString *status;//
@property(nonatomic,copy)NSString *created_at;//
@property(nonatomic,copy)NSString *ad_link;//轮播图片地址
@property(nonatomic,copy)NSString *updated_at;

@end

NS_ASSUME_NONNULL_END
