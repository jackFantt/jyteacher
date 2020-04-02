//
//  JYMyselfCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYMyselfCell.h"

@implementation JYMyselfCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = WhiteBackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    
    self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 20, 20, 20)];
    [self.contentView addSubview:self.leftImage];
    
    self.leftLabel = [UILabel wh_labelWithText:@"" textFont:16 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(self.leftImage.right+MARGIN_OX, self.leftImage.centerY-10, 120, 20)];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    self.leftLabel.font = [UIFont regularWithSize:16];
    [self.contentView addSubview:self.leftLabel];
    
    UIImageView * rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-MARGIN_OX-7, self.leftImage.centerY-5.5, 7, 11)];
    rightImage.image = [UIImage imageNamed:@"灰色箭头"];
    [self.contentView addSubview:rightImage];
    
    UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, self.leftImage.bottom+19, ScreenWidth-MARGIN_OX*2, 1)];
    linevIew.backgroundColor = RGBA(230, 230, 230, 1.0);
    [self.contentView addSubview:linevIew];
    
    self.rightLabel = [UILabel wh_labelWithText:@"" textFont:14 textColor:RGBA(218, 171, 119, 1.0) frame:CGRectMake(rightImage.mj_x-150, self.leftImage.centerY-10, 130, 20)];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.font = [UIFont mediumWithSize:14];
    [self.contentView addSubview:self.rightLabel];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
