//
//  MediaDatePickView.h
//  ZHDatePickerViewDemo
//
//  Created by 张小凡 on 2017/11/24.
//  Copyright © 2017年 Lebronjames_zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MediaDatePickDelegate <NSObject>
@optional
/**
 返回选择的时间字符串
 
 @param pickerView pickerView
 @param dateString 时间字符串
 */
- (void)pickerViewdidSelectDateString:(NSString *)dateString;
@end
@interface MediaDatePickView : UIView

@property (nonatomic,weak) id<MediaDatePickDelegate> pickDateDelegate;
-(void)showSelectedView:(UIView *)view;
-(void)dissMissView;
@end
