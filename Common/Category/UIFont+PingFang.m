//
//  UIFont+PingFang.h.m
//  YYSY
//
//  Created by BigCording on 2017/8/22.
//  Copyright © 2017年 BigCording. All rights reserved.
//

#import "UIFont+PingFang.h"

@implementation UIFont (PingFang)

+(instancetype)regularWithSize:(CGFloat) size {
    if (iOS_9_OR_LATER) {

      return  [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }
    
    return [UIFont systemFontOfSize:size];
}

+(instancetype)mediumWithSize:(CGFloat) size {
    if (iOS_9_OR_LATER) {
        return  [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }
    
    return [UIFont boldSystemFontOfSize:size];
    
}

+(instancetype)lightWithSize:(CGFloat) size {
    if (iOS_9_OR_LATER) {
        return  [UIFont fontWithName:@"PingFangSC-Light" size:size];
    }
    
    return [UIFont systemFontOfSize:size];
}
+(instancetype)ThinWithSize:(CGFloat) size {
    if (iOS_9_OR_LATER) {
        return  [UIFont fontWithName:@"PingFangSC-Thin" size:size];
    }
    
    return [UIFont systemFontOfSize:size];
}

+(instancetype)BoldWithSize:(CGFloat) size {
    if (iOS_9_OR_LATER) {
        return  [UIFont fontWithName:@"PingFang-SC-Bold" size:size];
    }
    
    return [UIFont systemFontOfSize:size];
}

@end
