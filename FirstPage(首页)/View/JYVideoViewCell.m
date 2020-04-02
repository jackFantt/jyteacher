//
//  JYVideoViewCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/26.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYVideoViewCell.h"

@implementation JYVideoViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = WhiteBackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 16, 153, 96)];
    self.goodsImage.backgroundColor = RGBA(119, 156, 247, 1.0);
    self.goodsImage.layer.masksToBounds = YES;
    self.goodsImage.layer.cornerRadius = 12;
    self.goodsImage.image = [UIImage imageNamed:@"课程封面"];
    [self.contentView addSubview:self.goodsImage];
    
    
       self.videoTitle = [UILabel wh_labelWithText:@"3月8日：疫情危机下，中小企业如何用互联网思维摆脱困难局面" textFont:14 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(self.goodsImage.right+MARGIN_OX, 16, ScreenWidth-MARGIN_OX-self.goodsImage.right-MARGIN_OX, 40)];
     self.videoTitle.numberOfLines = 0 ;
       self.videoTitle.textAlignment = NSTextAlignmentLeft;
       self.videoTitle.font = [UIFont boldSystemFontOfSize:14];
       [self.contentView addSubview:self.videoTitle];
    [self changeSpaceForLabel:self.videoTitle withLineSpace:4 WordSpace:1];
    
   self.onlinetranslation = [UILabel wh_labelWithText:@"33522人气" textFont:12 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(self.goodsImage.right+12, self.videoTitle.bottom +12, ScreenWidth-self.goodsImage.right-12-MARGIN_OX, 12)];
     self.onlinetranslation.textAlignment = NSTextAlignmentLeft;
     self.onlinetranslation.font = [UIFont regularWithSize:12];
     [self.contentView addSubview:self.onlinetranslation];
    
    self.videoTime = [UILabel wh_labelWithText:@"2019-03-16 12:15" textFont:13 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(self.goodsImage.right+12, self.onlinetranslation.bottom +12, ScreenWidth-self.goodsImage.right-12-MARGIN_OX, 12)];
    self.videoTime.textAlignment = NSTextAlignmentLeft;
    self.videoTime.font = [UIFont regularWithSize:12];
    [self.contentView addSubview:self.videoTime];
    
    
    UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, self.goodsImage.bottom+15, ScreenWidth-MARGIN_OX*2, 1)];
    linevIew.backgroundColor = RGBA(230, 230, 230, 1.0);
    [self.contentView addSubview:linevIew];
    
}
/**
 *  改变行间距和字间距
 */
- (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
