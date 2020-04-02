//
//  JYLIveInfoMessageCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/4/1.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYLIveInfoMessageCell.h"

@implementation JYLIveInfoMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBA(31, 28, 25, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 30, 20, 20)];
    [self.contentView addSubview:self.iconImage];
    
    self.liveTitle = [UILabel wh_labelWithText:@"中国古代文学简介" textFont:15 textColor:WhiteTextColor frame:CGRectMake(self.iconImage.right+MARGIN_OX, 15, ScreenWidth-self.iconImage.right-MARGIN_OX*2, 20)];
    self.liveTitle.font = [UIFont mediumWithSize:15];
    self.liveTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.liveTitle];
    
    
    self.liveTime = [UILabel wh_labelWithText:@"直播开始时间：2020-04-04 12：00：00" textFont:13 textColor:RGBA(148, 148, 148, 1.0) frame:CGRectMake(self.iconImage.right+MARGIN_OX, self.liveTitle.bottom+5, ScreenWidth-self.iconImage.right-MARGIN_OX*2, 20)];
    self.liveTime.font = [UIFont regularWithSize:13];
    self.liveTime.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.liveTime];
    
}

-(void)setLiveModel:(JYLiveModel *)liveModel{
    if (_liveModel == nil) {
        _liveModel = liveModel;
    }
    
    self.liveTitle.text = liveModel.name;
    NSString * timeStr = [NSString stringWithFormat:@"%ld",liveModel.start];
    NSString * opentimeStr = [[CommonTool manager] getNomalTimeByTimestamp:timeStr];
    self.liveTime.text = [NSString stringWithFormat:@"直播开启时间：%@",opentimeStr];
}

-(void)setIsCheck:(BOOL)isCheck{
    _isCheck = isCheck;
    if (isCheck) {
        self.iconImage.image = [UIImage imageNamed:@"payischeck"];
    }else{
        self.iconImage.image = [UIImage imageNamed:@"payuncheck"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
