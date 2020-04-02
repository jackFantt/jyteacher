//
//  JYMainRecommedCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYMainRecommedCell.h"
#import "RecommendtagsModel.h"

@interface JYMainRecommedCell ()
{
    UILabel * jytagLabel[3];
}

@end

@implementation JYMainRecommedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBA(242, 242, 242, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, 0, ScreenWidth-MARGIN_OX* 2, 184)];
    bottomView.backgroundColor = WhiteBackColor;
    [self.contentView addSubview:bottomView];
    
    
    self.recommedImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 12, 115, 160)];
    self.recommedImage.layer.masksToBounds = YES;
    self.recommedImage.layer.cornerRadius = 12;
    [bottomView addSubview:self.recommedImage];
    
    self.recommedTitle = [UILabel wh_labelWithText:@"这是个课程推荐标题，视频标题" textFont:16 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(self.recommedImage.right+12, 12, [bottomView width]-MARGIN_OX-self.recommedImage.right-12, 20)];
    self.recommedTitle.textAlignment = NSTextAlignmentLeft;
    self.recommedTitle.font = PFBold(16);
    [bottomView addSubview:self.recommedTitle];
    
    self.recommedDec = [UILabel wh_labelWithText:@"这是个课程推荐简介，视频的主要内容在这里呈现，学习视频" textFont:14 textColor:RGBA(102, 102, 102, 1.0) frame:CGRectMake(self.recommedImage.right+12, self.recommedTitle.bottom+12, [self.recommedTitle width], 20)];
    self.recommedDec.textAlignment = NSTextAlignmentLeft;
    self.recommedDec.font = PFMedium(14);
    [bottomView addSubview:self.recommedDec];
    
    self.recommedTeacher = [UILabel wh_labelWithText:@"张老师" textFont:12 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(self.recommedImage.right+12, self.recommedDec.bottom+12, 100, 20)];
    self.recommedTeacher.textAlignment = NSTextAlignmentLeft;
    self.recommedTeacher.font = PFRegular(12);
    [bottomView addSubview:self.recommedTeacher];
    
    self.recommedSkill = [UILabel wh_labelWithText:@"精英资深老师" textFont:12 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(self.recommedTeacher.right+12, self.recommedDec.bottom+12, [bottomView width]-self.recommedTeacher.right-MARGIN_OX*2, 20)];
    self.recommedSkill.textAlignment = NSTextAlignmentLeft;
    self.recommedSkill.font = PFRegular(12);
    [bottomView addSubview:self.recommedSkill];
    
    UIImageView * boleftImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.recommedImage.right+12, self.recommedTeacher.bottom+12+3.5, 22, 13)];
    boleftImage.image = [UIImage imageNamed:@"眼睛图标"];
    [bottomView addSubview:boleftImage];
    
    self.recommedRed = [UILabel wh_labelWithText:@"2387" textFont:15 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(boleftImage.right+12, self.recommedTeacher.bottom+12, 80, 20)];
    self.recommedRed.textAlignment = NSTextAlignmentLeft;
    self.recommedRed.font = PFRegular(12);
    [bottomView addSubview:self.recommedRed];
    
    self.recommedPrice = [UILabel wh_labelWithText:@"￥980" textFont:15 textColor:RGBA(218, 171, 119, 1.0) frame:CGRectMake(self.recommedRed.right+12, self.recommedTeacher.bottom+12, 150, 20)];
    self.recommedPrice.textAlignment = NSTextAlignmentLeft;
    self.recommedPrice.font = PFBold(16);
    [bottomView addSubview:self.recommedPrice];
    
    NSArray * tagArr = @[@"专升本",@"通俗易懂",@"轻松学习"];
    
    CGFloat labelWidth = ([bottomView width] -self.recommedImage.right-MARGIN_OX*4)/3;
    for (int i = 0; i<tagArr.count; i++) {
        jytagLabel[i] = [UILabel wh_labelWithText:tagArr[i] textFont:13 textColor:RGBA(175, 155, 130, 1.0) frame:CGRectMake(self.recommedImage.right+MARGIN_OX+i%3*(labelWidth+MARGIN_OX), self.recommedRed.bottom+12, labelWidth, 20)];
        jytagLabel[i].backgroundColor = RGBA(254, 241 , 224, 1.0);
        jytagLabel[i].layer.masksToBounds = YES;
        jytagLabel[i].layer.cornerRadius = 4.0f;
        [bottomView addSubview:jytagLabel[i]];
        jytagLabel[i].hidden = YES;
    }
    
    
    UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(0, 183, [bottomView width], 1)];
    linevIew.backgroundColor = RGBA(230, 230, 230, 1.0);
    [bottomView addSubview:linevIew];
    
    
}

-(void)setRecommedModel:(JYRecommendModel *)recommedModel{
    if (_recommedModel == nil) {
          _recommedModel = recommedModel;
      }
    NSString * imageUrl = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,KISDictionaryHaveKey(recommedModel.teacher, @"avatar")];
    [self.recommedImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placelmage1"]];
     self.recommedTitle.text = recommedModel.name;
    self.recommedDec.text = recommedModel.introduce;
    self.recommedTeacher.text = KISDictionaryHaveKey(recommedModel.teacher, @"name");
    self.recommedSkill.text = KISDictionaryHaveKey(recommedModel.teacher, @"title");
    self.recommedPrice.text = [NSString stringWithFormat:@"￥%@",KISDictionaryHaveKey(recommedModel.goods, @"price")];
    
    //tag数据处理
    
    for (int i = 0; i<recommedModel.tags.count; i++) {
        RecommendtagsModel * tagModel = recommedModel.tags[i];
        jytagLabel[i].text = tagModel.content;
        jytagLabel[i].hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
