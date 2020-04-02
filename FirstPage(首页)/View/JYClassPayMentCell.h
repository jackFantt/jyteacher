//
//  JYClassPayMentCell.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/26.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYClassPayMentCell : UITableViewCell

@property (nonatomic,strong) UIImageView * iconImage;
@property (nonatomic,strong) UILabel * paymentTitle;
@property (nonatomic,strong) UIImageView * payImage;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) BOOL isCheck;
@end

NS_ASSUME_NONNULL_END
