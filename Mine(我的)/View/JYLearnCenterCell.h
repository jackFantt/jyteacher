//
//  JYLearnCenterCell.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/18.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYLearnCenterCell : UITableViewCell

@property (nonatomic,strong) UIImageView * teacherIcon;
@property (nonatomic,strong) UILabel * teacherName;
@property (nonatomic,strong) UIImageView * skillIcon;
@property (nonatomic,strong) UILabel * skillName;

@property (nonatomic,strong) UILabel * decMessage;

@property (nonatomic,strong) UILabel * timeMessage;

@end

NS_ASSUME_NONNULL_END
