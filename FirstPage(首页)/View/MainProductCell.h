//
//  MainProductCell.h
//  JYEducation
//
//  Created by wofuli on 2019/11/7.
//  Copyright © 2019 smart. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface MainProductCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView * productImage;//商品图片
@property (nonatomic,strong) UILabel * productName;//商品名称
@property (nonatomic,strong) UILabel * productPrice;//商品价格
@property (nonatomic,strong) UILabel * market_price;//市场价格


@end

NS_ASSUME_NONNULL_END
