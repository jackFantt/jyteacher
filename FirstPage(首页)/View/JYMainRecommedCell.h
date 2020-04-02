//
//  JYMainRecommedCell.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYRecommendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYMainRecommedCell : UITableViewCell

@property (nonatomic,strong) UIImageView * recommedImage;

@property (nonatomic,strong) UILabel * recommedTitle;
@property (nonatomic,strong) UILabel * recommedDec;
@property (nonatomic,strong) UILabel * recommedTeacher;
@property (nonatomic,strong) UILabel * recommedSkill;

@property (nonatomic,strong) UILabel * recommedRed;
@property (nonatomic,strong) UILabel * recommedPrice;

@property (nonatomic,strong) JYRecommendModel * recommedModel;



@end

NS_ASSUME_NONNULL_END
