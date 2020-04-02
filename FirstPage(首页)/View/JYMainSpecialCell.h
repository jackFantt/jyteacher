//
//  JYMainSpecialCell.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^cellspecialBlock)(NSInteger index);

@interface JYMainSpecialCell : UITableViewCell

@property (nonatomic,strong) UIView * bottomView;
@property (nonatomic,strong) UIImageView * specialImage;

@property (nonatomic,strong) UILabel * specialTitle;
@property (nonatomic,strong) UILabel * specialDec;
@property (nonatomic,strong) UILabel * specialRed;
@property (nonatomic,strong) UILabel * markPrice;
@property (nonatomic,strong) UILabel * specialPrice;

@property (nonatomic,copy) cellspecialBlock specialBlock;

-(void)setRefrshSpecialImageWithImageArr:(NSMutableArray *)imageArr;

@end

NS_ASSUME_NONNULL_END
