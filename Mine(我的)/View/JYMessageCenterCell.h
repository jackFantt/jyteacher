//
//  JYMessageCenterCell.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/18.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYMessageCenterCell : UITableViewCell

@property (nonatomic,strong) UIView * bottomView;

@property (nonatomic,strong) UILabel * messageTitle;

@property (nonatomic,strong) UILabel * messageDec;

@property (nonatomic,strong) UIImageView * iconImage;

@property (nonatomic,strong) UILabel * messageTime;

-(void)setCellMessageDec:(NSString *)decMessage;

@end

NS_ASSUME_NONNULL_END
