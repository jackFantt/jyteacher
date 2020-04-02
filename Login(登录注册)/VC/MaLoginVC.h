//
//  MaLoginVC.h
//  JYEducation
//
//  Created by wofuli on 2019/11/6.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MallBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^refrshBlock)(void);

@interface MaLoginVC : MallBaseVC
@property (nonatomic,copy) refrshBlock refrshuiBlock;

@end

NS_ASSUME_NONNULL_END
