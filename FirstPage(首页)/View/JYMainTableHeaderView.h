//
//  JYMainTableHeaderView.h
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^searchCourseBlock)(void);
typedef void(^JYSectionBlock)(NSInteger index);

@interface JYMainTableHeaderView : UIView
-(instancetype)initWithJYheaderView;

@property (nonatomic,copy) searchCourseBlock searchBlock;
@property (nonatomic,copy) JYSectionBlock sectionBlock;

-(void)refrshJYHeaderBanner:(NSMutableArray *)banner;

@end

NS_ASSUME_NONNULL_END
