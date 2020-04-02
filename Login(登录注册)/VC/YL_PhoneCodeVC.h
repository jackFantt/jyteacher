//
//  YL_PhoneCodeVC.h
//  wofubao
//
//  Created by 张小凡 on 2019/3/18.
//  Copyright © 2019 wofu. All rights reserved.
//

#import "MallBaseVC.h"

typedef void(^refrshloginBlock)(void);

@interface YL_PhoneCodeVC : MallBaseVC

@property (nonatomic,copy) refrshloginBlock refrshuiBlock;

@end
