//
//  JYMainLiveCell.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^cellliveBlock)(NSInteger index);

@interface JYMainLiveCell : UITableViewCell

@property (nonatomic,strong) UIView * bottomView;

@property (nonatomic,strong) UILabel * leftLabel;

//@property (nonatomic,strong) UIImageView * liveImage;

@property (nonatomic,strong) UIButton * moreBtn;

@property (nonatomic,strong) UILabel *rightLabel;

@property (nonatomic,strong) UILabel * liveTitle;

@property (nonatomic,strong) UILabel * livePrice;

@property (nonatomic,copy) cellliveBlock liveBlock;


-(void)setRefrshLiveImageWithImageArr:(NSMutableArray *)imageArr;


@end

NS_ASSUME_NONNULL_END
