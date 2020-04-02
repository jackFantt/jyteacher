//
//  JYStudyRecondCell.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/24.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYLearn_courseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYStudyRecondCell : UITableViewCell

@property (nonatomic,strong) UIImageView * teacherIcon;

@property (nonatomic,strong) UILabel * teacherName;
@property (nonatomic,strong) UIImageView * skillIcon;
@property (nonatomic,strong) UILabel * skillName;


@property (nonatomic,strong) UILabel * studyTitle;

@property (nonatomic,strong) UILabel * studyDec;

@property (nonatomic,strong) UILabel * studyTime;

@property (nonatomic,strong) JYLearn_courseModel * courseModel;

@end

NS_ASSUME_NONNULL_END
