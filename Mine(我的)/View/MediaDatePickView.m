//
//  MediaDatePickView.m
//  ZHDatePickerViewDemo
//
//  Created by 张小凡 on 2017/11/24.
//  Copyright © 2017年 Lebronjames_zh. All rights reserved.
//

#import "MediaDatePickView.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
static float ToolbarH  = 54;

@interface MediaDatePickView (){
    UIView * _contentView;
}
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation MediaDatePickView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initContentView];
    }
    return self;
}
-(void)initContentView{
    self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    self.backgroundColor = [UIColor colorWithRed:0/255.0
                                           green:0/255.0
                                            blue:0/255.0
                                           alpha:0.3];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissMissView)];
    [self addGestureRecognizer:tapGester];
    
    if(_contentView == nil){
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H-270, SCREEN_W, 270)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
            UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, ToolbarH-1,SCREEN_W, 1)];
            topView.backgroundColor = RGBA(243, 243, 243, 1.0);
            [_contentView addSubview:topView];
        UIButton * cancleBtn = [UIButton wh_buttonWithTitle:@"取消" backColor:nil backImageName:@"" titleColor:RGBA(58, 148, 248, 1.0) fontSize:middle_fontsize frame:CGRectMake(70, 0, 60, ToolbarH) cornerRadius:0];
        [_contentView addSubview:cancleBtn];
        [cancleBtn wh_addActionHandler:^{
            
            [self dissMissView];
        }];
        UIButton * sureBtn = [UIButton wh_buttonWithTitle:@"确定" backColor:nil backImageName:@"" titleColor:RGBA(58, 148, 248, 1.0) fontSize:middle_fontsize frame:CGRectMake(SCREEN_W-70-60, 0, 60, ToolbarH) cornerRadius:0];
        [_contentView addSubview:sureBtn];
        [sureBtn wh_addActionHandler:^{
            NSDate *select = self.datePicker.date;
            NSDateFormatter *dateFormmater = [[NSDateFormatter alloc]init];
            [dateFormmater setDateFormat:@"yyyy-MM-dd"];
            NSString *resultString = [dateFormmater stringFromDate:select];
            if (self.pickDateDelegate && [self.pickDateDelegate respondsToSelector:@selector(pickerViewdidSelectDateString:)]) {
                [self.pickDateDelegate pickerViewdidSelectDateString:resultString];
            }
            [self dissMissView];
        }];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [_contentView addSubview:self.datePicker];
   
}
}
-(void)dissMissView{
    
    [_contentView setFrame:CGRectMake(0, SCREEN_H-270, SCREEN_W, 270)];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
        [_contentView setFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 270)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_contentView removeFromSuperview];
    }];
}

-(void)showSelectedView:(UIView *)view{
    if (!view) {
        return;
    }
    [view addSubview:self];
    [view addSubview:_contentView];
    [_contentView setFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 270)];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        [_contentView setFrame:CGRectMake(0, SCREEN_H-270, SCREEN_W, 270)];
    }];
}
#pragma mark -- 懒加载

/**
 DatePicker
 */
- (UIDatePicker *)datePicker
{
    if (!_datePicker)
    {
        _datePicker   = [[UIDatePicker alloc] init];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.backgroundColor = [UIColor whiteColor];
        // UIDatePicker默认高度216
        _datePicker.frame = CGRectMake(0, ToolbarH , SCREEN_W, _datePicker.frame.size.height);
    }
    return _datePicker;
}

@end
