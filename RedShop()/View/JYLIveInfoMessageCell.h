//
//  JYLIveInfoMessageCell.h
//  JYEducation
//
//  Created by 精英教育 on 2020/4/1.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYLiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYLIveInfoMessageCell : UITableViewCell

@property (nonatomic,strong) UIImageView * iconImage;
@property (nonatomic,strong) UILabel * liveTitle;
@property (nonatomic,strong) UILabel * liveTime;
@property (nonatomic,assign) BOOL isCheck;

@property (nonatomic,strong) JYLiveModel * liveModel;

@end

NS_ASSUME_NONNULL_END
