//
//  LY_ForgottenVC.h
//  wofubao
//
//  Created by 张小凡 on 2019/3/18.
//  Copyright © 2019 wofu. All rights reserved.
//

#import "MallBaseVC.h"
typedef void (^ReturnBlock) (NSString * userName,NSString * passWord);

@interface LY_ForgottenVC : MallBaseVC
@property (nonatomic,copy) ReturnBlock returnStrBlock;
@end
