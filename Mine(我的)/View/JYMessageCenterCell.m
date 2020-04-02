//
//  JYMessageCenterCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/18.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYMessageCenterCell.h"

@implementation JYMessageCenterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBA(245, 245, 245, 1.0);;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

-(void)createUI{
   UIView * bottomView  = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, 10, ScreenWidth-MARGIN_OX*2, 180)];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 6.0f;
    bottomView.backgroundColor = WhiteBackColor;
//    bottomView.layer.borderColor = [HexadecimalColor(@"#F3F3F3") CGColor];
//    bottomView.layer.borderWidth = 1.0f;
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    
    self.messageTitle = [UILabel wh_labelWithText:@"这是个消息的标题" textFont:16 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(MARGIN_OX, 16, [bottomView width]-MARGIN_OX*2, 20)];
    self.messageTitle.font = [UIFont boldSystemFontOfSize:16];
    self.messageTitle.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:self.messageTitle];
    
    self.messageDec = [UILabel wh_labelWithText:@"" textFont:14 textColor:RGBA(102, 102, 102, 1.0) frame:CGRectZero];
    self.messageDec.font = [UIFont mediumWithSize:14];
    self.messageDec.textAlignment = NSTextAlignmentLeft;
    self.messageDec.numberOfLines = 0;
    [self.bottomView addSubview:self.messageDec];
    
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, [self.bottomView height]-52, 20, 20)];
    self.iconImage.image = [UIImage imageNamed:@"时间"];
    [self.bottomView addSubview:self.iconImage];
    
    self.messageTime = [UILabel wh_labelWithText:@"2020-03-09 12:16" textFont:13 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(self.iconImage.right+5, self.iconImage.centerY-10, [self.bottomView width]-self.iconImage.right-5-MARGIN_OX, 20)];
    self.messageTime.textAlignment = NSTextAlignmentLeft;
    self.messageTime.font = [UIFont regularWithSize:13];
    [self.bottomView addSubview:self.messageTime];
    
}

-(void)setCellMessageDec:(NSString *)decMessage
{
    
    self.messageDec.text = decMessage;
    UIFont * font = [UIFont mediumWithSize:14];
    [[CommonTool manager] changeSpaceForLabel:self.messageDec withLineSpace:3 WordSpace:1];
    CGRect rect = [decMessage boundingRectWithSize:CGSizeMake([self.bottomView width]-MARGIN_OX*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    CGFloat messageHeight = rect.size.height;
    CGFloat h = [[CommonTool manager] getSpaceLabelHeight:decMessage withFont:[UIFont mediumWithSize:14] withWidth:[self.bottomView width]-MARGIN_OX*2];
//    NSNumber *count = @((messageHeight) / self.messageDec.font.lineHeight);
    self.messageDec.frame = CGRectMake(MARGIN_OX, self.messageTitle.bottom+12, [self.bottomView width]-MARGIN_OX*2, h);
    [self.bottomView setMj_h:92+h];
    [self.iconImage setY:self.messageDec.bottom+12];
    [self.messageTime setY:self.iconImage.centerY - 10];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
