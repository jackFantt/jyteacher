//
//  JYPurchaseCell.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYPurchaseCell : UITableViewCell

@property (nonatomic,strong) UIImageView * goodsImage;
@property (nonatomic,strong) UILabel * purchaseTitle;
@property (nonatomic,strong) UILabel * purchaseDec;
@property (nonatomic,strong) UILabel * purchaseTeacher;
@property (nonatomic,strong) UILabel * purchaseSkill;
@property (nonatomic,strong) UILabel * purchaseTime;

@end

NS_ASSUME_NONNULL_END
