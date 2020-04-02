//
//  MaLunBoModel.m
//  JYEducation
//
//  Created by shuguo on 2019/11/18.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MaLunBoModel.h"

@implementation MaLunBoModel


+(NSDictionary *)replacedKeyFromPropertyName{
    
    return @{
             @"ad_id":@"id",
             @"ad_link":@"path"
             };
}
@end
